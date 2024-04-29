resource "null_resource" "install_aws_cli" {
  provisioner "local-exec" {
    command = "brew install awscli"
  }
}