


resource "aws_s3_bucket" "rohits3logbuck" {
  bucket = var.bucket_name

  tags = {
    Name        = "rohits3logbuck"
    Environment = "dev"
  }
}

resource "aws_s3_bucket_public_access_block" "rohits3logprivate" {
  bucket = aws_s3_bucket.rohits3logbuck.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_iam_role" "rohits3loguploaderrole" {
  name = "rohits3loguploaderrole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "rohits3loguploadpolicy" {
  name = "rohits3loguploadpolicy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:PutObject"
      ]
      Resource = "${aws_s3_bucket.rohits3logbuck.arn}/*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "rohits3loguploadpolicyattach" {
  role       = aws_iam_role.rohits3loguploaderrole.name
  policy_arn = aws_iam_policy.rohits3loguploadpolicy.arn
}

resource "aws_iam_group" "rohits3logdevelopersgroup" {
  name = "rohits3logdevelopersgroup"
}

# resource "aws_iam_role" "rohits3logdevelopersrole" {
#   name = "rohits3logdevelopersrole"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Effect = "Allow"
#       Principal = {
#         AWS =
#       }
#       Action = "sts:AssumeRole"
#     }]
#   })
# }

resource "aws_iam_policy" "rohits3logdevelopersreadpolicy" {
  name = "rohits3logdevelopersreadpolicy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.rohits3logbuck.arn,
          "${aws_s3_bucket.rohits3logbuck.arn}/*"
        ]
      }
    ]
  })
}


resource "aws_iam_group_policy_attachment" "rohits3logdevelopersreadpolicyattach" {
  group      = aws_iam_group.rohits3logdevelopersgroup.name
  policy_arn = aws_iam_policy.rohits3logdevelopersreadpolicy.arn
}

resource "aws_s3_bucket_policy" "rohits3logdenydeletelogspolicy" {
  bucket = aws_s3_bucket.rohits3logbuck.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "DenyDeleteForAll"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:DeleteObject"
        Resource  = "${aws_s3_bucket.rohits3logbuck.arn}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_lifecycle_configuration" "rohits3loglifecycledelete" {
  bucket = aws_s3_bucket.rohits3logbuck.id

  rule {
    id     = "rohits3loglifecycledelete"
    status = "Enabled"

    expiration {
      days          = 365

    }
  }
  }

