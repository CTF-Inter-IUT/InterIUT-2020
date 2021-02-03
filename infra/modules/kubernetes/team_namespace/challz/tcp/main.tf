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
                container {
                    image = "registry.alfred.cafe/interiut/${var.name}"
                    name = var.name
                    image_pull_policy = "Always"

                    port {
                        container_port = var.port
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

                    dynamic "liveness_probe" {
                        for_each = var.disable_checks ? [] : [true]

                        content {
                            tcp_socket {
                                port = var.port
                            }
                            initial_delay_seconds = 3
                            period_seconds = 20
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
            port = var.port
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
