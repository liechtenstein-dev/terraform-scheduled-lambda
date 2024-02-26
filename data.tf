data "archive_file" "lambda_function_zip" {
  source_dir  = var.source_dir
  output_path = "/tmp/lambda.zip"
  type        = "zip"
}

data "aws_caller_identity" "current" {}

resource "null_resource" "install_python_dependencies" {
  provisioner "local-exec" {
    command = "bash ${path.module}/scripts/create_pkg.sh"

    environment = {
      source_code_path = var.source_dir
      function_name = var.function_name
      path_module = path.module
      runtime = var.lambda_runtime_handler
      path_cwd = path.cwd
    }
  }
}

data "archive_file" "create_dist_pkg" {
  depends_on = ["null_resource.install_python_dependencies"]
  source_dir = "${path.cwd}/lambda_dist_pkg/"
  output_path = var.output_path 
  type = "zip"
}
