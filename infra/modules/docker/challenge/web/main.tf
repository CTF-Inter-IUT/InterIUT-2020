module "challenge" {
    source = "../"
    chall_path = var.chall_path
}

# Registry images
data "docker_registry_image" "challenge_image" {
    name = "registry.alfred.cafe/interiut/${basename(var.chall_path)}"
}
data "docker_registry_image" "mysql" {
    name = "mysql:5"
}

# Docker images
resource "docker_image" "challenge_image" {
    name = data.docker_registry_image.challenge_image.name
    pull_triggers = [data.docker_registry_image.challenge_image.sha256_digest]
}
resource "docker_image" "mysql" {
    name = data.docker_registry_image.mysql.name
    pull_triggers = [data.docker_registry_image.mysql.sha256_digest]
}

# Common network
resource "docker_network" "challenge_network" {
    name = basename(var.chall_path)
}

# Docker containers
resource "docker_container" "challenge" {
    name = basename(var.chall_path)
    image = docker_image.challenge_image.latest

    labels {
        label = "traefik.enable"
        value = "true"
    }
    labels {
        label = "traefik.http.routers.${basename(var.chall_path)}.entrypoints"
        value = "http"
    }
    labels {
        label = "traefik.http.routers.${basename(var.chall_path)}.rule"
        value = "Host(`${substr(basename(var.chall_path), 3, -1)}.challz.interiut.ctf`)"
    }
    start = true
    restart = "always"
    networks_advanced {
        name = docker_network.challenge_network.id
    }
    networks_advanced {
        name = var.public_network
    }

    lifecycle {
        ignore_changes = [ working_dir ]
    }
}

resource "docker_container" "mysql_server" {
    count = var.require_mysql # Create only if require_mysql == 1

    name = "${basename(var.chall_path)}-mysql"
    image = docker_image.mysql.latest
    start = true
    restart = "unless-stopped"

    networks_advanced {
        name = docker_network.challenge_network.id
        aliases = ["database"]
    }

    env = ["MYSQL_ALLOW_EMPTY_PASSWORD=yes"]

    upload {
        content = file("${var.chall_path}/${var.mysql_init_script}")
        file = "/docker-entrypoint-initdb.d/init.sql"
    }

//    network_mode = "container:${docker_container.challenge.id}"
}
