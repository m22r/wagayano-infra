data "template_file" "admin_role" {
  template = file("${path.module}/templates/admin_role.json.template")

  vars = {
    admin_user_arns = join("\", \"", aws_iam_user.admin.*.arn)
  }
}

data "template_file" "admin_group_policy" {
  template = file("${path.module}/templates/admin_group_policy.json.template")

  vars = {
    admin_role_arn = aws_iam_role.admin.arn
    tfstate_bucket = var.tfstate_bucket
  }
}
