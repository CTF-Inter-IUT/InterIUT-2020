

# Team specific namespace
resource "kubernetes_namespace" "team-namespace" {
    metadata {
        name = var.name
    }
}

# Private registry secret
resource "kubernetes_secret" "registry-auth" {
    metadata {
        name = "registry-auth"
        namespace = kubernetes_namespace.team-namespace.metadata.0.name
    }

    data = {
        ".dockerconfigjson" = <<DOCKER
{
	"auths": {
		"registry.alfred.cafe": {
			"auth": "aW50ZXJpdXQ6YWlmIWxlZUBMTzBzb3Vz"
		}
	}
}
DOCKER
    }

    type = "kubernetes.io/dockerconfigjson"
}


module "web_challenges" {
    for_each = var.challenges.web

    source = "./challz/web"
//    depends_on = [null_resource.ctfd_is_up]

    name = each.value.name
    challz_folder = var.challz_folder
    namespace = kubernetes_namespace.team-namespace.metadata.0.name

    require_mysql = try(each.value.require_mysql, false)
    mysql_user = try(each.value.mysql_user, "challenge")
    mysql_password = try(each.value.mysql_password, "")
    mysql_database = try(each.value.mysql_database, "")
    mysql_init_script = try(each.value.mysql_init_script, null)
    
    require_mongo = try(each.value.require_mongo, false)
    mongo_user = try(each.value.mongo_user, "challenge")
    mongo_password = try(each.value.mongo_password, "")

    image_pull_secrets = kubernetes_secret.registry-auth.metadata[0].name
}

module "tcp_challenge" {
    for_each = var.challenges.tcp

    source = "./challz/tcp"
    namespace = kubernetes_namespace.team-namespace.metadata.0.name
//    depends_on = [null_resource.ctfd_is_up]

    name = each.value.name
    port = try(each.value.port, 1337)
    image_pull_secrets = kubernetes_secret.registry-auth.metadata[0].name
    disable_checks = try(each.value.disable_checks, false)
}

module "wireguard" {
    source = "./wireguard"
    namespace = kubernetes_namespace.team-namespace.metadata.0.name
    config_content = var.wg_conf
//    index = var.index
    external_ip = var.external_ip
    external_port = var.external_port
}

# resource "kubernetes_network_policy" "wireguard-namespace-only" {
#     metadata {
#         name = "wireguard-namespace-only"
#         namespace = var.namespace
#     }
#     spec {
#         pod_selector {
#             match_labels = {
#                 # name = "wireguard_front"
# //                name = kubernetes_service.wireguard-front.metadata[0].labels.name
#             }
#         }

#         policy_types = ["Egress"]

#         egress {
#             ports {
#                 port = "53"
#                 protocol = "UDP"
#             }
#             ports {
#                 port = "53"
#                 protocol = "TCP"
#             }
#         }
#     }
# }
