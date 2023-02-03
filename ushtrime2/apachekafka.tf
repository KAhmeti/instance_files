# Pulls the image
resource "docker_image" "apache2" {
  name = "bitnami/kafka:latest"
}

# Create a container
resource "docker_container" "apache2" {
  image = docker_image.apache2.image_id
  name  = "apache_kafka"
  ports {
    internal = 9092
    external = 9092
  }
  networks = ["rrjeti2"]

  env = ["KAFKA_CFG_ZOOKEEPER_CONNECT=zookeeper:2181","ALLOW_PLAINTEXT_LISTENER=yes"]

  provisioner "local-exec" {
    working_dir = "/opt/bitnami/kafka/bin/"
    command = "kafka-topics.sh --list --bootstrap-server kafka-server:9092"
   }
}
