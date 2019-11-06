output "aws_access_key_id_for_phoenix_ci" {
  value = module.phoenix_ci_user.id
}
output "aws_secret_access_key_for_phoenix_ci" {
  value = module.phoenix_ci_user.secret
}
output "aws_access_key_id_for_rainbows_ci" {
  value = module.rainbows_ci_user.id
}
output "aws_secret_access_key_for_rainbows_ci" {
  value = module.rainbows_ci_user.secret
}
