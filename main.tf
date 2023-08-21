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
  #  policy = ""
  bucket   = aws_s3_bucket.finance.id
}

data "aws_iam_group" "finance-date" {
  group_name = "finance-analysts"
}

resource "aws_s3_bucket_policy" "finance-policy" {
  bucket = aws_s3_bucket.finance.id
  policy = <<EOF
        {
        "Version": "2012-10-17",
              "Statement": [
                    {
                        "Action": "*" ,
                        "Effect": "Allow" ,
                        "Resource": "arn:aws:s3:::${aws_s3_bucket.finance.id}/*",
                        "Principal": {
                            "aws": [
                                    "${data.aws_iam_group.finance-date.arn}"
                                    ]
                            }
                    }
                  ]
        }
            EOF

}





