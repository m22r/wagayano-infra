resource "aws_rds_cluster" "default" {
  cluster_identifier              = "${var.prefix}-${var.engine}-cluster"
  engine                          = var.engine
  engine_version                  = var.engine_version
  availability_zones              = var.availability_zones
  database_name                   = var.db_name
  master_username                 = var.db_user
  master_password                 = var.db_pass
  vpc_security_group_ids          = var.vpc_security_group_ids
  db_subnet_group_name            = aws_db_subnet_group.default.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.default.id
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  backup_retention_period         = var.backup_retention_period
  preferred_backup_window         = var.preferred_backup_window
  preferred_maintenance_window    = var.preferred_maintenance_window
  skip_final_snapshot             = var.skip_final_snapshot
}

resource "aws_db_subnet_group" "default" {
  name       = "${var.prefix}-${var.engine}-subnetgroup"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.prefix}-${var.engine}-subnetgroup"
  }
}

resource "aws_rds_cluster_parameter_group" "default" {
  name   = "${var.prefix}-${var.engine}-clusterparamgroup"
  family = var.family

  dynamic "parameter" {
    for_each = var.cluster_params
    content {
      name         = parameter.key
      value        = parameter.value
      apply_method = "pending-reboot"
    }
  }
}

resource "aws_rds_cluster_instance" "default" {
  count                   = var.instance_count
  identifier              = "${aws_rds_cluster.default.id}-instance${count.index}"
  cluster_identifier      = aws_rds_cluster.default.id
  instance_class          = var.instance_class
  engine                  = var.engine
  engine_version          = var.engine_version
  availability_zone       = var.availability_zones[count.index % length(var.availability_zones)]
  db_parameter_group_name = aws_db_parameter_group.default.id
}

resource "aws_db_parameter_group" "default" {
  name   = "${var.prefix}-${var.engine}-paramgroup"
  family = var.family

  dynamic "parameter" {
    for_each = var.db_params
    content {
      name         = parameter.key
      value        = parameter.value
      apply_method = "pending-reboot"
    }
  }
}
