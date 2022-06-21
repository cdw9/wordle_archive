resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

resource "aws_iam_role" "github" {
  name               = "github-oidc-wordle-archive"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Principal": {
                "Federated": "${aws_iam_openid_connect_provider.github.arn}"
            },
            "Condition": {
                "StringEquals": {
                    "token.actions.githubusercontent.com:aud": [
                        "sts.amazonaws.com"
                    ]
                },
                "StringLike": {
                    "token.actions.githubusercontent.com:sub": "repo:cdw9/wordle_archive:*"
                }
            }
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "github" {
  role       = aws_iam_role.github.name
  policy_arn = aws_iam_policy.wordle_archive.arn
}

resource "aws_iam_policy" "wordle_archive" {
  name   = "wordle_archive"
  path   = "/"
  policy = data.aws_iam_policy_document.wordle_archive.json
}

data "aws_iam_policy_document" "wordle_archive" {
  statement {
    resources = [
      aws_s3_bucket.aw.arn,
      "${aws_s3_bucket.aw.arn}/*",
    ]
    actions = ["s3:*"]
  }
}

