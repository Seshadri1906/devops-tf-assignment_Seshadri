locals {
  function_name   = "helloworld-localstack" // or var.name if you have a variable declared with the desired name
  lambda_zip_name = "lambda-${random_string.r.result}.zip"
}

resource "random_string" "r" {
  length  = 16
  special = false
  keepers = {
    # A value that changes on each run, to enforce a new random string each time
    always_change = "${timestamp()}"
  }
}

# Any other resources or configurations that are global or pertain to main.tf
