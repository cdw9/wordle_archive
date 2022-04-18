resource "aws_ecr_repository" "wordle_archive" {
  name                 = "wordle_archive"
  image_tag_mutability = "MUTABLE"
}

# resource "aws_ecr_repository_policy" "wordle_archive" {
#   repository = aws_ecr_repository.wordle_archive.name

#   policy = <<EOF
# {
#     "Version": "2008-10-17",
#     "Statement": [
#       {
#       "Sid": "new policy",
#       "Effect": "Allow",
#       "Principal": {
#         "AWS": "${aws_iam_role.wordle_archive.arn}"
#       },
#       "Action": [
#           "ecr:*"
#       ]
#     }
#   ]
# }
# EOF
# }

resource "aws_apprunner_service" "wordle_archive" {
  service_name = "wordle_archive"

  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.wordle_archive.arn
    }
    image_repository {
      image_configuration {
        port = "8080"
        runtime_environment_variables = {
          WORDLE  = "true"
          ARCHIVE = "yay"
        }
      }
      image_identifier      = "${aws_ecr_repository.wordle_archive.repository_url}:latest"
      image_repository_type = "ECR"
    }
  }

  tags = {
    Name = "wordle_archive"
  }
}

resource "aws_iam_role" "wordle_archive" {
  name               = "wordle_archive"
  assume_role_policy = data.aws_iam_policy_document.wordle_archive_trust.json
}

resource "aws_iam_policy" "wordle_archive" {
  name   = "wordle_archive"
  path   = "/"
  policy = data.aws_iam_policy_document.wordle_archive.json
}

resource "aws_iam_role_policy_attachment" "wordle_archive" {
  role       = aws_iam_role.wordle_archive.name
  policy_arn = aws_iam_policy.wordle_archive.arn
}

data "aws_iam_policy_document" "wordle_archive_trust" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["build.apprunner.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "wordle_archive" {
  statement {
    resources = [
      aws_ecr_repository.wordle_archive.arn,
      "${aws_ecr_repository.wordle_archive.arn}/*",
    ]
    actions = ["ecr:*"]
  }
  statement {
    resources = ["*"]
    actions   = ["ecr:GetAuthorizationToken"]
  }
}

