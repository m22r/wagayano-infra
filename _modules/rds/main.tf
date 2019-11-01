resource "aws_db_instance" "default" {
  identifier                      = "${var.prefix}-${var.engine}-instance"
  allocated_storage               = 10
  max_allocated_storage           = 1000
  storage_type                    = "gp2"
  engine                          = var.engine
  engine_version                  = var.engine_version
  instance_class                  = var.instance_class
  name                            = var.db_name
  username                        = var.db_user
  password                        = var.db_pass
  db_subnet_group_name            = aws_db_subnet_group.default.id
  option_group_name               = aws_db_option_group.default.id
  parameter_group_name            = aws_db_parameter_group.default.id
  multi_az                        = var.multi_az
  vpc_security_group_ids          = var.vpc_security_group_ids
  maintenance_window              = var.maintenance_window
  backup_window                   = var.backup_window
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  backup_retention_period         = var.backup_retention_period
}

resource "aws_db_subnet_group" "default" {
  name       = "${var.prefix}-${var.engine}-subnetgroup"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.prefix}-${var.engine}-subnetgroup"
  }
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

resource "aws_db_option_group" "default" {
  name                 = "${var.prefix}-${var.engine}-optiongroup"
  engine_name          = var.engine
  major_engine_version = replace(var.engine_version, "/\\.\\d+$/", "")

  dynamic "option" {
    for_each = var.options
    content {
      option_name = option.key
      dynamic "option_settings" {
        for_each = option.value
        content {
          name  = option_settings.key
          value = option_settings.value
        }
      }
    }
  }
}
