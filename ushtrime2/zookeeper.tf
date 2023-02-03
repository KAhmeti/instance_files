# Pulls the image
resource "docker_image" "zookeeper" {
  name = "zookeeper:latest"
}

# Create a container
resource "docker_container" "zookeeper" {
  image = docker_image.zookeeper.image_id
  name  = "zookeeper"
  ports {
    internal = 2181
    external = 2181
  }
  networks = ["rrjeti2"]

  env = ["ALLOW_ANONYMOUS_LOGIN=yes"]
}
