

# Team specific namespace
resource "kubernetes_namespace" "team-namespace" {
    metadata {
        name = local.namespace_name

        labels = {
            team = local.id
        }
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
    require_mysql = try(each.value.require_mysql, 0)
    mysql_init_script = try(each.value.mysql_init_script, null)
    image_pull_secrets = kubernetes_secret.registry-auth.metadata[0].name
    namespace = kubernetes_namespace.team-namespace.metadata.0.name
}

module "tcp_challenge" {
    for_each = var.challenges.tcp

    source = "./challz/tcp"
    namespace = kubernetes_namespace.team-namespace.metadata.0.name
//    depends_on = [null_resource.ctfd_is_up]

    name = each.value.name
    image_pull_secrets = kubernetes_secret.registry-auth.metadata[0].name
}

module "wireguard" {
    source = "./wireguard"
    namespace = kubernetes_namespace.team-namespace.metadata.0.name
    config_content = var.wg_conf
    index = var.index
    external_ip = var.external_ip
}