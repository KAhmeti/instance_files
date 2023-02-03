# Pulls the image
resource "docker_image" "pgadmin" {
  name = "dpage/pgadmin4:latest"
}

# Create a container
resource "docker_container" "pgadmin" {
  image = docker_image.pgadmin.image_id
  name  = "pgadmin"
  ports {
    internal = 80
    external = 80
  }
  env = [
   "PGADMIN_DEFAULT_EMAIL=user@domain.com",
   "PGADMIN_DEFAULT_PASSWORD=SuperSecret"
  ]
}

resource "docker_network" "private_network" {
  name = "rrjeti"
}
