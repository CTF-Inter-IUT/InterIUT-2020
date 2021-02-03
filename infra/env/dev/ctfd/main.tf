provider "docker" {
    host = "ssh://root@ctfd.interiut.ctf"
}

data "local_file" "ctfd_db" {
    filename = "${path.module}/ctfd.db"
}

resource "null_resource" "database_provisioner" {
    triggers = {
        ctfd_db = sha1(data.local_file.ctfd_db.content)
    }

    connection {
        type = "ssh"
        user = "root"
        password = "interiut"
        host = "ctfd.interiut.ctf"
    }

    provisioner "file" {
        source = data.local_file.ctfd_db.filename
        destination = "/opt/ctfd.db"
    }

    provisioner "remote-exec" {
        inline = [ "chmod o+w /opt/ctfd.db" ]
    }
}

data "docker_registry_image" "ctfd" {
    name = "ctfd/ctfd:latest"
}

resource "docker_image" "ctfd" {
    name = data.docker_registry_image.ctfd.name
    pull_triggers = [data.docker_registry_image.ctfd.sha256_digest]
}

resource "docker_container" "ctfd" {
    depends_on = [null_resource.database_provisioner]

    image    = docker_image.ctfd.latest
    name     = "ctfd"
    hostname = "ctfd.interiut.ctf"
    working_dir = "/opt/CTFd"
    ports {
        internal = 8000
        external = 80
    }
    env     = ["SWAGGER_UI=True"]
    start   = true
    restart = "always"

    volumes {
        host_path = "/opt/ctfd.db"
        container_path = "/opt/CTFd/CTFd/ctfd.db"
    }
}
