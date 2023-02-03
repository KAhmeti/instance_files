# Pulls the image
resource "docker_image" "redis2" {
  name = "redislabs/redisearch:latest"
}

# Create a container
resource "docker_container" "redis2" {
  image = docker_image.redis2.image_id
  name  = "redis2"
  ports {
    internal = 8001
    external = 8001
  }
}

resource "docker_network" "private_network" {
  name = "rrjeti"
}
