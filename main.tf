provider "aws" {
  region = "eu-central-1"
}

resource "aws_s3_bucket" "finance" {

  bucket = "finance-210920202"
  tags = {
    Description = "Finance and payroll"
  }
}

resource "aws_s3_bucket_object" "finance-2020" {
  content  ="c:/text.txt"
  key = "text.txt"
  bucket   = aws_s3_bucket.finance.id
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.finance.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

data "aws_iam_group" "finance-date" {
  group_name = "finance-analysts"
}

resource "aws_s3_bucket_policy" "finance-policy" {
  bucket = aws_s3_bucket.finance.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "*",
        Effect   = "Allow"
        Resource = "arn:aws:s3:::${aws_s3_bucket.finance.id}/*"
        Principal: "*"
      },
    ],

  })
  depends_on = [aws_s3_bucket_public_access_block.example]
}


