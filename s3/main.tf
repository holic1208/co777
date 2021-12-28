provider "aws" {
  region = "ap-northeast-2"
}


resource "aws_s3_bucket" "co777-state-file-bucket" {
  bucket = "co777-final-pro"

  tags = {
    Name = "${var.tag_s3_name}_bucket"
  }

  lifecycle {
    prevent_destroy = false
  }

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket" "co777-state-file-bucket2" {
  bucket = "co777-final-logs"

  tags = {
    Name = "${var.tag_s3_name}_logs_bucket"
  }

  lifecycle {
    prevent_destroy = false
  }

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

#dynamodb
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "co777-final-dynamo"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
