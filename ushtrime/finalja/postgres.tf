# Pulls the image
resource "docker_image" "postgres" {
  name = "postgres:latest"
}

# Create a container
resource "docker_container" "postgres" {
  image = docker_image.postgres.image_id
  name  = "postgres"
  ports {
    internal = 5432
    external = 5432
  }
volumes {
    container_path  = "/var/lib/postgresql/data"
    }
  env = [
   "POSTGRES_PASSWORD=mysecretpassword"
  ]

}

resource "docker_network" "private_network" {
  name = "rrjeti"
}

resource "docker_volume" "volum" {
    name = "volumi"
}
