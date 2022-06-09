provider "aws" {

region = "us-east-1"

}

resource "aws_instance" "rdswebinstance" {
  ami           = "ami-04505e74c0741db8d"
  instance_type = "t3.medium"
  count = 1
  vpc_security_group_ids = [
    "sg-0f8886ca33d837065"
  ]
  key_name = "onekey"
  subnet_id = data.aws_subnet.selected.id
  associate_public_ip_address = true
  user_data       = data.template_file.user_data.rendered


 tags = {
    Name = "webrdsinstance"
  }

}

data "aws_subnet" "selected" {
  id = "${var.subnet_id}"
}


resource "aws_db_instance" "wordpressdb" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  db_name              =  var.database_name
  username             =  var.database_user
  password             =  var.database_password

  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true



  tags = {
    Name = "ExampleRDSServerInstance"
  }


}


data "template_file" "user_data" {
  template = var.IsUbuntu ? file("./userdata_ubuntu.tpl") : file("./user_data.tpl")
  vars = {
    db_username      = var.database_user
    db_user_password = var.database_password
    db_name          = var.database_name
    db_RDS           = aws_db_instance.wordpressdb.endpoint
  }
}






