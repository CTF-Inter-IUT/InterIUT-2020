resource "kubernetes_pod" "challenge" {
    metadata {
        name = var.name
        namespace = var.namespace
        labels = {
            chall = var.name
        }
    }
    spec {
        container {
            image = "registry.alfred.cafe/interiut/${var.name}"
            name = var.name

            port {
                container_port = 1337
            }
        }
        image_pull_secrets {
            name = var.image_pull_secrets
        }
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
            port = 1337
        }
        selector = {
            chall = var.name
        }
    }
}

//resource "kubernetes_horizontal_pod_autoscaler" "autoscaler" {
//    metadata {
//        name = local.name
//        namespace = var.namespace
//    }
//    spec {
//        min_replicas = 0
//        max_replicas = 4
//        scale_target_ref {
//            api_version = "apps/v1"
//            kind = "Deployment"
//            name = local.name
//        }
//    }
//}
