# Pulls the image
resource "docker_image" "redis" {
  name = "redis:latest"
}

# Create a container
resource "docker_container" "redis" {
  image = docker_image.redis.image_id
  name  = "redis"
  ports {
    internal = 6739
    external = 6739
  }
}

resource "docker_network" "private_network" {
  name = "rrjeti"
}
