provider "docker" {
    host = "ssh://root@challz.interiut.ctf"

    registry_auth {
        address = "registry.alfred.cafe"
        username = "interiut"
        password = "aif!lee@LO0sous" 
    }
}

resource "null_resource" "ctfd_is_up" {
    provisioner "module.inputs-exec" {
        interpreter = ["bash", "-c"]
        command = "until \u0024(curl --output /dev/null --silent --head --fail http://ctfd.interiut.ctf); do sleep 1; done"
    }
}

resource "docker_network" "traefik" {
    name = "traefik_public"
}

module "traefik" {
    source = "../../../modules/docker/traefik"
    public_network = docker_network.traefik.name
    tcp_challenges = module.inputs.challenges.tcp
}

module "web_challenges" {
    for_each = module.inputs.challenges.web

    source = "../../../modules/docker/challenge/web"
    depends_on = [null_resource.ctfd_is_up]

    chall_path = "${module.inputs.challz_folder}/challz/${each.value.path}"
    require_mysql = try(each.value.require_mysql, 0)
    mysql_init_script = try(each.value.mysql_init_script, null)
    public_network = docker_network.traefik.name
}

module "tcp_challenge" {
    for_each = module.inputs.challenges.tcp

    source = "../../../modules/docker/challenge/tcp"
    depends_on = [null_resource.ctfd_is_up]

    chall_path = "${module.inputs.challz_folder}/challz/${each.value.path}"
    public_network = docker_network.traefik.name
}

module "file_challenge" {
    for_each = module.inputs.challenges.file

    source = "../../../modules/docker/challenge/"
    depends_on = [null_resource.ctfd_is_up]

    chall_path = "${module.inputs.challz_folder}/challz/${each.value.path}"
}
