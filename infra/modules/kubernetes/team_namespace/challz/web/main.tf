resource "kubernetes_config_map" "mysql_init_script" {
    count = var.require_mysql ? 1 : 0

    metadata {
        name = "mysql-init-script-${var.name}"
        namespace = var.namespace
    }
    data = {
        "init-script" = file("${var.challz_folder}/${var.name}/${var.mysql_init_script}")
    }
}

resource "kubernetes_deployment" "challenge" {
    metadata {
        name = var.name
        namespace = var.namespace

        labels = {
            chall = var.name
        }
    }
    spec {
        selector {
            match_labels = {
                chall = var.name
            }
        }
        template {
            metadata {
                name = var.name
                labels = {
                    chall = var.name
                }
            }
            spec {
                node_selector = {
                    target = "ctf"
                }
                container {
                    image_pull_policy = "Always"
                    image = "registry.alfred.cafe/interiut/${var.name}"
                    name = var.name

                    port {
                        container_port = 80
                    }

                    resources {
                        requests {
                            memory = "15Mi"
                        }
                        limits {
                            memory = "200Mi"
                            cpu = "100m"
                        }
                    }

                    liveness_probe {
                        http_get {
                            path = "/"
                            port = 80
                        }
                        initial_delay_seconds = 3
                        period_seconds = 3
                    }
                }

                dynamic "container" {
                    for_each = var.require_mysql ? [true] : []
                    
                    content {
                        name = "mysql"
                        image = "mysql:5"

                        env {
                            name = "MYSQL_RANDOM_ROOT_PASSWORD"
                            value = "yes"
                        }

                        env {
                            name = "MYSQL_USER"
                            value = var.mysql_user
                        }

                        env {
                            name = "MYSQL_PASSWORD"
                            value = var.mysql_password
                        }

                        env {
                            name = "MYSQL_DATABASE"
                            value = var.mysql_database
                        }

                        port {
                            container_port = 3306
                        }

                        resources {
                            requests {
                                memory = "256Mi"
                            }
                            limits {
                                memory = "512Mi"
                            }
                        }

                        volume_mount {
                            name = "init-script"
                            mount_path = "docker-entrypoint-initdb.d/init.sql"
                            sub_path = "init-script"
                        }
                    }
                }

                dynamic "container" {
                    for_each = var.require_mongo ? [true] : []
                    
                    content {
                        name = "mongo"
                        image = "mongo"

                        env {
                            name = "MONGO_INITDB_ROOT_USERNAME"
                            value = var.mongo_user
                        }

                        env {
                            name = "MONGO_INITDB_ROOT_PASSWORD"
                            value = var.mongo_password
                        }

                        resources {
                            limits {
                                memory = "512Mi"
                            }
                        }
                    }
                }

                dynamic "volume" {
                    for_each = var.require_mysql ? [true] : []

                    content {
                        name = "init-script"
                        config_map {
                            name = kubernetes_config_map.mysql_init_script[0].metadata.0.name
                        }   
                    }
                }

                image_pull_secrets {
                    name = var.image_pull_secrets
                }
            }
        }
    }

    lifecycle {
        ignore_changes = [
            spec.0.replicas
        ]
    }
}

resource "kubernetes_service" "service" {
    metadata {
        namespace = var.namespace
        name = substr(var.name, 3, -1)
        labels = {
            chall = var.name
        }
    }
    spec {
        port {
            port = 80
        }
        selector = {
            chall = var.name
        }
    }
}

resource "kubernetes_horizontal_pod_autoscaler" "autoscaler" {
    metadata {
        name = var.name
        namespace = var.namespace
    }
    spec {
        min_replicas = 2
        max_replicas = 5

        scale_target_ref {
            api_version = "apps/v1"
            kind = "Deployment"
            name = var.name
        }
    }
}
