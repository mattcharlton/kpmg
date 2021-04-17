resource "aws_db_instance" "dbserver" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "mydb"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}
resource "aws_network_interface_sg_attachment" "db_sg_attachment" {
  security_group_id    = aws_security_group.db_sg.id
  network_interface_id = aws_db_instance.dbserver.primary_network_interface_id
}
resource "aws_instance" "webserver" {
  ami           = "ami-06ce3edf0cff21f07"
  instance_type = "t2.micro"
  vpc_security_group_ids = aws_security_group.webserver_sg.id
}
resource "aws_network_interface_sg_attachment" "webserver_sg_attachment" {
  security_group_id    = aws_security_group.webserver_sg.id
  network_interface_id = aws_instance.webserver.primary_network_interface_id
}
resource "aws_instance" "appserver" {
  ami           = "ami-06ce3edf0cff21f07"
  instance_type = "t2.micro"
}
resource "aws_network_interface_sg_attachment" "appserver_sg_attachment" {
  security_group_id    = aws_security_group.appserver_sg.id
  network_interface_id = aws_instance.appserver.primary_network_interface_id
}