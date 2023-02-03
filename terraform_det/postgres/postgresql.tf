# Pulls the image
resource "docker_image" "postgres" {
  name = "postgres:latest"
}

# Create a container
resource "docker_container" "postgres" {
  image = docker_image.postgres.image_id
  name  = "postgres" 
  env = ["POSTGRES_PASSWORD=mysecretpassword"]
  ports {
    internal = 8080
    external = 8080
  }
}
