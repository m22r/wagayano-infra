resource "aws_iam_role" "admin" {
  name               = var.admin_role
  assume_role_policy = data.template_file.admin_role.rendered
}

resource "aws_iam_role_policy_attachment" "admin" {
  role       = aws_iam_role.admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role_policy_attachment" "billing" {
  role       = aws_iam_role.admin.name
  policy_arn = "arn:aws:iam::aws:policy/job-function/Billing"
}

resource "aws_iam_group" "admin" {
  name = var.admin_group
}

resource "aws_iam_group_policy" "admin" {
  name   = "${var.admin_group}-policy"
  group  = aws_iam_group.admin.id
  policy = data.template_file.admin_group_policy.rendered
}

resource "aws_iam_user" "admin" {
  count = length(var.admin_users)
  name  = var.admin_users[count.index]
}

resource "aws_iam_user_group_membership" "admin" {
  count = length(var.admin_users)
  user  = var.admin_users[count.index]

  groups = [
    aws_iam_group.admin.name,
  ]
}
