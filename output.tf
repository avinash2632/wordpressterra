output "subnetid" {

value = data.aws_subnet.selected.id

}


output "EC2_IP" {
  value = aws_instance.rdswebinstance.public_ip
}


output "RDS-Endpoint" {
  value = aws_db_instance.wordpressdb.endpoint
}

