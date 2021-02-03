resource "kubernetes_config_map" "wg-config" {
    metadata {
        name = "wg-config"
        namespace = var.namespace
    }
    data = {
        "wg0.conf" = var.config_content
    }
}

resource "kubernetes_config_map" "coredns_config" {
    metadata {
        name = "coredns-config"
        namespace = var.namespace
    }
    data = {
        "Corefile" = templatefile("${path.module}/Corefile.tpl", {
            namespace = var.namespace
        })
    }
}

resource "kubernetes_pod" "wireguard" {
    metadata {
        name = "wireguard"
        namespace = var.namespace
        labels = {
            app = "wireguard"
        }
    }

    spec {
        node_selector = {
            target = "ctf"
        }

        init_container {
            name = "sysctls"
            image = "busybox"
            command = [
                "sh",
                "-c",
                "sysctl -w net.ipv4.ip_forward=1 && sysctl -w net.ipv4.conf.all.forwarding=1"
            ]
            security_context {
                capabilities {
                    add = ["NET_ADMIN"]
                }
                privileged = true
            }
        }

        container {
            image = "masipcat/wireguard-go:latest"
            name = "wireguard"

            port {
                container_port = 51820
                protocol = "UDP"
                name = "wireguard"
            }
            env {
                name = "LOG_LEVEL"
                value = "debug"
            }
            security_context {
                capabilities {
                    add = ["NET_ADMIN"]
                }
            }
            volume_mount {
                name = "tun"
                mount_path = "/dev/net/tun"
            }
            volume_mount {
                name = "wg-cfgmap"
                mount_path = "/etc/wireguard/wg0.conf"
                sub_path = "wg0.conf"
            }
        }

        container {
            name = "coredns"
            image = "coredns/coredns"

            args = ["-conf", "/Corefile"]

            volume_mount {
                name = "coredns-cfgmap"
                mount_path = "/Corefile"
                sub_path = "Corefile"
            }
        }

        volume {
            name = "tun"
            host_path {
                path = "/dev/net/tun"
            }
        }
        volume {
            name = "wg-cfgmap"
            config_map {
                name = kubernetes_config_map.wg-config.metadata[0].name
            }
        }
        volume {
            name = "coredns-cfgmap"
            config_map {
                name = kubernetes_config_map.coredns_config.metadata[0].name
            }
        }
    }
}

resource "kubernetes_service" "wireguard-front" {
    depends_on = [kubernetes_pod.wireguard]

    metadata {
        name = "wireguard-front"
        namespace = var.namespace

        labels = {
            name = "wireguard-front"
        }
    }
    spec {
        type = "LoadBalancer"
        load_balancer_ip = var.external_ip

        port {
            port = 51000 + var.index
            target_port = 51820
            protocol = "UDP"
        }
        selector = {
            app = "wireguard"
        }
    }
}

//resource "kubernetes_network_policy" "wireguard-namespace-only" {
//    metadata {
//        name = "wireguard-namespace-only"
//        namespace = var.namespace
//    }
//    spec {
//        pod_selector {
//            match_labels = {
//                name = "wireguard_front"
////                name = kubernetes_service.wireguard-front.metadata[0].labels.name
//            }
//        }
//
//        policy_types = ["Egress"]
//
//        egress {
//            ports {
//                port = "53"
//                protocol = "UDP"
//            }
//            ports {
//                port = "53"
//                protocol = "TCP"
//            }
//        }
//    }
//}