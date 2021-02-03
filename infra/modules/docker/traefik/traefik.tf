resource "docker_container" "traefik" {
    name = "traefik"
    image = docker_image.traefik.latest

    ports {
        internal = 80
        external = 80
    }

    ports {
        internal = 8080
        external = 8080
    }

    ports {
        internal = 1337
        external = 1337
    }

    upload {
        content = templatefile("${path.module}/traefik.yml", {
            docker_network = var.public_network
            tcp_challenges = var.tcp_challenges
        })
        file = "/etc/traefik/traefik.yml"
    }

    mounts {
        source = "/var/run/docker.sock"
        target = "/var/run/docker.sock"
        type= "bind"
        read_only = true
    }

    networks_advanced {
        name = var.public_network
    }

    start = true
    restart = "unless-stopped"
}

resource "docker_image" "traefik" {
    name = "traefik:latest"
}
