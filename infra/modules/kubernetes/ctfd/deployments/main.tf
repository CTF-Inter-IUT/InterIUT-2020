resource "random_password" "mysql_password" {
    length = 16
    special = false
}

resource "kubernetes_secret" "mysql_config" {
    metadata {
        name = "database-config"
    }
    data = {
        password = random_password.mysql_password.result
        DATABASE_URL = "mysql+pymysql://ctfd:${random_password.mysql_password.result}@ctfd-mysql/ctfd"
    }
}

resource "random_password" "redis_password" {
    length = 16
    special = false
}

resource "kubernetes_secret" "redis_config" {
    metadata {
        name = "redis-config"
    }
    data = {
        password = random_password.redis_password.result
        REDIS_URL = "redis://:${random_password.redis_password.result}@ctfd-redis:6379"
    }
}

resource "google_service_account_key" "ctfd_sa" {
    service_account_id = "ctfd-uploads@interiut.iam.gserviceaccount.com"
}

resource "kubernetes_secret" "ctfd_sa_credentials" {
    metadata {
        name = "ctfd-sa-credentials"
    }
    data = {
        credentialsjson = base64decode(google_service_account_key.ctfd_sa.private_key)
    }
}

resource "kubernetes_deployment" "ctfd" {
    metadata {
        name = "ctfd"
        labels = {
            app = "ctfd"
        }
    }
    spec {
        selector {
            match_labels = {
                app = "ctfd"
            }
        }
        
        replicas = 1
        template {
            metadata {
                labels = {
                    app = "ctfd"
                }
            }
            spec {
                container {
                    image = "registry.alfred.cafe/interiut/ctfd"
                    name = "ctfd"

                    env {
                        name = "DATABASE_URL"
                        value_from {
                            secret_key_ref {
                                name = kubernetes_secret.mysql_config.metadata.0.name
                                key = "DATABASE_URL"
                            }
                        }
                    }
                    env {
                        name = "REDIS_URL"
                        value_from {
                            secret_key_ref {
                                name = kubernetes_secret.redis_config.metadata.0.name
                                key = "REDIS_URL"
                            }
                        }
                    }
                    env {
                        name = "GCP_CREDENTIALS_PATH"
                        value = "/credentials.json"
                    }
                    env {
                        name = "GCP_BUCKET"
                        value = "interiut-ctfd-files"
                    }

                    port {
                        container_port = 8000
                    }

                    volume_mount {
                         name = "secret-key"
                         mount_path = "/opt/CTFd/.ctfd_secret_key"
                         sub_path = "secret_key"
                    }
                    volume_mount {
                         name = "gcp-credentials"
                         mount_path = "/credentials.json"
                         sub_path = "credentialsjson"
                    }

                    resources {
                        requests {
                            cpu = "1"
                            memory = "256Mi"
                        }
                        limits {
                            memory = "512Mi"
                        }
                    }

                    readiness_probe {
                        http_get {
                            path = "/"
                            port = 8000
                        }
                        initial_delay_seconds = 3
                        period_seconds = 3
                    }
                }

                image_pull_secrets {
                    name = var.image_pull_secret
                }

                volume {
                   name = "secret-key"
                   secret {
                       secret_name = var.secret_key
                   }
                }
                volume {
                    name = "gcp-credentials"
                    secret {
                        secret_name = kubernetes_secret.ctfd_sa_credentials.metadata.0.name
                    }
                }
            }
        }
    }

    lifecycle {
        ignore_changes = [ spec.0.replicas ]
    }
}

resource "kubernetes_horizontal_pod_autoscaler" "ctfd_autoscaler" {
    metadata {
        name = "ctfd-autoscaler"
    }

    spec {
        scale_target_ref {
            api_version = "apps/v1"
            kind = "Deployment"
            name = kubernetes_deployment.ctfd.metadata.0.name
        }
        min_replicas = 1
        max_replicas = 30

        metric {
            type = "Resource"
            resource {
                name = "cpu"
                target {
                    type = "Utilization"
                    average_utilization = 70
                }
            }
        }
    }
}

# resource "kubernetes_service" "ctfd_service" {
#     metadata {
#         name = "ctfd"
#     }
#     spec {
#         # type = "NodePort"
#         # session_affinity = "ClientIP"
#         type = "LoadBalancer"
#         load_balancer_ip = var.external_ip

#         selector = {
#             app = kubernetes_deployment.ctfd.metadata.0.labels.app
#         }
#         port {
#             port = 8000
#             # target_port = 8000
#         }
#     }
# }

resource "kubernetes_service" "ctfd_ingress" {
    metadata {
        name = "ctfd-ingress"
    }
    spec {
        selector = {
            app = kubernetes_deployment.ctfd.metadata.0.labels.app
        }
        # session_affinity = "ClientIP"
        port {
            port = 8000
            target_port = 8000
        }

        type = "NodePort"
        # load_balancer_ip = var.external_ip
    }
}

resource "kubernetes_service" "ctfd_service" {
    metadata {
        name = "ctfd"
    }
    spec {
        selector = {
            app = kubernetes_deployment.ctfd.metadata.0.labels.app
        }
        session_affinity = "ClientIP"
        port {
            port = 80
            target_port = 8000
        }

        type = "LoadBalancer"
        load_balancer_ip = var.external_ip
    }
}

resource "tls_private_key" "ctfd_private_key" {
    algorithm = "RSA"
}

resource "tls_self_signed_cert" "ctfd_certificate" {
    key_algorithm   = tls_private_key.ctfd_private_key.algorithm
    private_key_pem = tls_private_key.ctfd_private_key.private_key_pem

    # Certificate expires after 12 hours.
    validity_period_hours = 24 * 30

    # Generate a new certificate if Terraform is run within three
    # hours of the certificate's expiration time.
    early_renewal_hours = 3

    # Reasonable set of uses for a server SSL certificate.
    allowed_uses = [
        "key_encipherment",
        "digital_signature",
        "server_auth",
    ]

    #   dns_names = []

    subject {
        common_name  = var.external_ip
        organization = "Hack2G2"
    }
}

resource "kubernetes_secret" "tls_secret" {
    type = "kubernetes.io/tls"

    metadata {
        name = "tls-secret"
    }

    data = {
        "tls.crt" = tls_self_signed_cert.ctfd_certificate.cert_pem
        "tls.key" = tls_private_key.ctfd_private_key.private_key_pem
    }
}

resource "kubernetes_ingress" "ctfd_ingress" {
    metadata {
        name = "ctfd"
        annotations = {
            "kubernetes.io/ingress.global-static-ip-name" = "ctfd-ip"
        }
    }

    spec {
        backend {
            service_name = "ctfd-ingress"
            service_port = 8000 
        }
        # rule {
        #     http {
        #         path {
        #             path = "/*"
        #             backend {
        #                 service_name = "ctfd-ingress"
        #                 service_port = 8000
        #             }
        #         }
        #     }
        # }

        tls {
            secret_name = kubernetes_secret.tls_secret.metadata.0.name
        }
    }
}

resource "kubernetes_deployment" "ctfd_redis" {
    metadata {
        name = "ctfd-redis"
        labels = {
            app = "ctfd-redis"
        }
    }
    spec {
        replicas = 1

        selector {
            match_labels = {
                app = "ctfd-redis"
            }
        }
        template {
            metadata {
                labels = {
                    app = "ctfd-redis"
                }
            }
            spec {
                container {
                    image = "redis:3.2"
                    name = "ctfd-redis"
                    args = [ "--requirepass", "$(REDIS_PASSWORD)"]

                    env {
                        name = "REDIS_PASSWORD"
                        value_from {
                            secret_key_ref {
                                name = kubernetes_secret.redis_config.metadata.0.name
                                key = "password"
                            }
                        }
                    }

                    port {
                        container_port = 6379
                        protocol = "TCP"
                    }

                    resources {
                        limits {
                            memory = "256Mi"
                        }
                    }
                }
            }
        }
    }
}

resource "kubernetes_service" "ctfd_redis" {
    metadata {
        name = "ctfd-redis"
        labels = {
            app = "ctfd-redis"
        }
    }
    spec {
        port {
            port = 6379
            target_port = 6379
        }
        selector = {
            app = kubernetes_deployment.ctfd_redis.metadata.0.labels.app
        }
    }
}

resource "kubernetes_deployment" "ctfd_mysql" {
    metadata {
        name = "ctfd-mysql"
        labels = {
            app = "ctfd-mysql"
        }
    }
    spec {
        replicas = 1
        selector {
            match_labels = {
                app = "ctfd-mysql"
            }
        }
        template {
            metadata {
                labels = {
                    app = "ctfd-mysql"
                }
            }
            spec {
                container {
                    image = "mysql:5"
                    name = "redis-mysql"

                    env {
                        name = "MYSQL_DATABASE"
                        value = "ctfd"
                    }
                    env {
                        name = "MYSQL_RANDOM_ROOT_PASSWORD"
                        value = "yes"
                    }
                    env {
                        name = "MYSQL_USER"
                        value = "ctfd"
                    }
                    env {
                        name = "MYSQL_PASSWORD"
                        value_from {
                            secret_key_ref {
                                name = kubernetes_secret.mysql_config.metadata.0.name
                                key = "password"
                            }
                        }
                    }

                    port {
                        container_port = 3306
                    }

                    resources {
                        limits {
                            memory = "6G"
                        }
                    }

                    liveness_probe {
                        initial_delay_seconds = 30
                        tcp_socket {
                            port = 3306
                        }
                        timeout_seconds = 1
                    }
                }
            }
        }
    }
}

resource "kubernetes_service" "mysql" {
    metadata {
        name = "ctfd-mysql"
        labels = {
            app = "ctfd-mysql"
        }
    }
    spec {
        port {
            port = 3306
            target_port = 3306
            protocol = "TCP"
        }
        selector = {
            app = kubernetes_deployment.ctfd_mysql.metadata.0.labels.app
        }
    }
}

# resource "null_resource" "ctfd_is_up" {
#     provisioner "module.inputs-exec" {
#         interpreter = ["bash", "-c"]
#         command = "until \u0024(curl --output /dev/null --silent --head --fail http://${kubernetes_service.ctfd_service.load_balancer_ingress.0.ip}:${kubernetes_service.ctfd_service.load_balancer_ingress.0.port}); do sleep 1; done"
#     }
# }

resource "random_password" "ctfd_password" {
    length = 16
    special = false
}

module "ctfd_setup" {
    source = "matti/resource/shell"
    # depends_on = [ null_resource.ctfd_is_up ]
    command = <<EOF
        python3 ${path.module}/configureCtfd.py \
            --hostname ${kubernetes_service.ctfd_service.load_balancer_ingress.0.ip} \
            --port ${kubernetes_service.ctfd_service.spec.0.port.0.port} \
            --name InterIUT \
            --username admin \
            --email admin@interiut.ctf \
            --password ${random_password.ctfd_password.result} \
            --create-access-token \
            --disable-registration
    EOF
}
