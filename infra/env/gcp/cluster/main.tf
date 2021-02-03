resource "google_container_cluster" "interiut_cluster" {
    name = "interiut-cluster"
    location = "europe-west1-b"

    initial_node_count = 1
}


resource "google_container_node_pool" "interiut_node_pool" {
    name       = "interiut-node-pool"
    location   = "europe-west1-b"
    cluster    = google_container_cluster.interiut_cluster.name

    autoscaling {
        min_node_count = 1
        max_node_count = 10
    }

    node_config {
        machine_type = "e2-highcpu-8"
        labels = {
            target = "ctf"
        }
        metadata = {
            disable-legacy-endpoints = "true"
        }

        oauth_scopes = [
            "https://www.googleapis.com/auth/cloud-platform",
            "https://www.googleapis.com/auth/logging.write",
            "https://www.googleapis.com/auth/monitoring",
        ]
    }
}

resource "google_container_node_pool" "interiut_ctfd_node_pool" {
    name       = "ctfd-node-pool"
    location   = "europe-west1-b"
    cluster    = google_container_cluster.interiut_cluster.name

    node_count = 1

    node_config {
        machine_type = "e2-highcpu-8"
        labels = {
            target = "ctfd"
        }
        metadata = {
            disable-legacy-endpoints = "true"
        }

        oauth_scopes = [
            "https://www.googleapis.com/auth/cloud-platform",
            "https://www.googleapis.com/auth/logging.write",
            "https://www.googleapis.com/auth/monitoring",
        ]
    }
}