data "archive_file" "lambda-archive" {
  type        = "zip"
  source_dir  = "lambda_zip/"
  output_path = "packages/Python-package.zip"
  depends_on  = [null_resource.build_lambda_layer]
}

locals {
  // All lambda codes zip and layer zip file directory
  lambda_artifact_dir       = "${path.module}/lambda_zip"
  lambda_layer_zipfile_name = "layer"
  python_version            = "python2.7"
}



// Generate zipfile for lambda layer
resource "null_resource" "build_lambda_layer" {
  provisioner "local-exec" {
    when    = create
    command = "./${path.module}/build_layer.sh"


  }

  triggers = {
    // Trigger only when something changes in Pipfile
    run_on_requirements_change = filemd5("${abspath(path.module)}/requirements.txt")
  }
}

resource "aws_lambda_layer_version" "lambda_layer" {
  filename            = "packages/Python-package.zip"
  layer_name          = "lambda_layer_new"
  compatible_runtimes = [local.python_version]
  // It will run after lambda layer zipfile build
  depends_on = [null_resource.build_lambda_layer]
  # source_code_hash    = "filebase64sha256(packages/Python-package.zip)"
  source_code_hash = "data.archive_file.lambda-archive.output_base64sha256"


  lifecycle {
    create_before_destroy = true
  }
}
