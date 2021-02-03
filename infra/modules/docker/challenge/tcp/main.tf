module "challenge" {
    source = "../"
    chall_path = var.chall_path
}


# Registry images
data "docker_registry_image" "challenge_image" {
    name = "registry.alfred.cafe/interiut/${basename(var.chall_path)}"
}

# Docker images
resource "docker_image" "challenge_image" {
    name = data.docker_registry_image.challenge_image.name
    pull_triggers = [data.docker_registry_image.challenge_image.sha256_digest]
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
        label = "traefik.tcp.routers.${basename(var.chall_path)}.entryPoints"
        value = basename(var.chall_path)
    }
    labels {
        label = "traefik.tcp.routers.${basename(var.chall_path)}.rule"
        value = "HostSNI(`*`)"
    }

    start = true
    restart = "always"

    networks_advanced {
        name = var.public_network
    }

    lifecycle {
        ignore_changes = [ working_dir ]
    }
}
