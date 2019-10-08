output "cluster_id" {
  value = aws_rds_cluster.default.id
}

output "instance_ids" {
  value = aws_rds_cluster_instance.default.*.id
}
