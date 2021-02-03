data "local_file" "challenge_config" {
    filename = "${var.chall_path}/challenge.yml"
}

resource "null_resource" "sync_ctfd" {
    triggers = {
        challenge_config = data.local_file.challenge_config.content
    }

//    provisioner "local-exec" {
//        command = "ctf challenge add ${data.local_file.challenge_config.filename}"
//    }

    provisioner "local-exec" {
        command = "ctf challenge install ${data.local_file.challenge_config.filename}"
    }

    provisioner "local-exec" {
        command = "ctf challenge sync ${data.local_file.challenge_config.filename}"
    }
}
