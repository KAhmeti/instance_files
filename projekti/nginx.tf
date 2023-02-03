# Pulls the image
resource "docker_image" "nginx" {
  name = "nginx:latest"
}

# Create a container
resource "docker_container" "nginx" {
  count = 2 
  image = docker_image.nginx.image_id
  name  = "nginx${count.index}"
  ports {
    internal = 80
    external = "8${count.index}"
  }
}

resource "docker_network" "private_network" {
  name = "rrjeti"
}
