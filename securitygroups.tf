resource "aws_security_group" "general_sg" {
  description = "HTTP egress to anywhere"
  vpc_id      = aws_vpc.main.id

  tags = {
    Project = "kpmg"
  }
}

resource "aws_security_group" "db_sg" {
  description = "MYSQL access from app server to DB server"
  vpc_id      = aws_vpc.main.id

  tags = {
    Project = "kpmg"
  }
}

resource "aws_security_group" "appserver_sg" {
  description = "App traffic from the web server"
  vpc_id      = aws_vpc.main.id
  tags = {
    Project = "kpmg"
  }
}

resource "aws_security_group" "webserver_sg" {
  description = "HTTP and HTTPS access from the world"
  vpc_id      = aws_vpc.main.id
  tags = {
    Project = "kpmg"
  }
}

resource "aws_security_group_rule" "out_http" {
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.general_sg.id
}

resource "aws_security_group_rule" "out_http_app" {
  type              = "egress"
  description       = "Allow TCP internet traffic egress from app layer"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.appserver_sg.id
}

resource "aws_security_group_rule" "in_http_server" {
  type              = "ingress"
  description       = "Allow TCP internet traffic ingress from Internet"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.webserver_sg.id
}

resource "aws_security_group_rule" "in_https_server" {
  type              = "ingress"
  description       = "Allow TCP internet traffic ingress from Internet"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.webserver_sg.id
}

resource "aws_security_group_rule" "in_mysql_from_app" {
  type                     = "ingress"
  description              = "Allow MSQL access from the app server"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.db_sg.id
  source_security_group_id = aws_security_group.appserver_sg.id
}