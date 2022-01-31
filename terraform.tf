provider "aws" {
  region = "us-east-2"
}
resource "aws_instance" "myec2" {
  depends_on = [aws_db_instance.default]
  ami           = "ami-0fb653ca2d3203ac1"
  instance_type = "t2.micro"
  subnet_id   = "subnet-0e7d0fc5926bcbb6d"
  key_name = "shivakey"
  user_data = templatefile("${path.module}/userdata.tftpl", {endpoint = aws_db_instance.default.endpoint,address = aws_db_instance.default.address})
  iam_instance_profile = "demorole"
  security_groups = ["sg-04638412bef8421f5"]
  tags = {
    Name = "cpms2"
  }
}
resource "aws_db_instance" "default" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "cpms"
  identifier           = "myrdbs"
  username             = "admin"
  password             = "shiva123"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  publicly_accessible  = true
  vpc_security_group_ids = ["sg-04638412bef8421f5"]
}
