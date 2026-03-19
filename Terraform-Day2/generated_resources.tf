# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform
resource "aws_instance" "example" {
  ami                                  = "ami-0312bcacbe51d03c8"
  associate_public_ip_address          = true
  availability_zone                    = "ap-southeast-2c"
  disable_api_stop                     = false
  disable_api_termination              = false
  ebs_optimized                        = false
  force_destroy                        = false
  get_password_data                    = false
  hibernation                          = false
  instance_initiated_shutdown_behavior = "stop"
  instance_type                        = "t3.small"
  # ipv6_address_count                   = 0
  ipv6_addresses             = []
  key_name                   = "terraform-key"
  monitoring                 = false
  placement_partition_number = 0
  private_ip                 = "172.31.18.23"
  region                     = "ap-southeast-2"
  secondary_private_ips      = []
  security_groups            = ["ssh"]
  source_dest_check          = true
  subnet_id                  = "subnet-0667d74b5f97df1f6"
  tags = {
    Name = "Terraform-instance"
  }
  tags_all = {
    Name = "Terraform-instance"
  }
  tenancy                     = "default"
  user_data                   = null
  user_data_replace_on_change = null
  volume_tags                 = null
  vpc_security_group_ids      = ["sg-06d0462a7873118db"]
  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }
  cpu_options {
    core_count       = 1
    threads_per_core = 2
  }
  credit_specification {
    cpu_credits = "unlimited"
  }
  enclave_options {
    enabled = false
  }
  maintenance_options {
    auto_recovery = "default"
  }
  metadata_options {
    http_endpoint               = "enabled"
    http_protocol_ipv6          = "disabled"
    http_put_response_hop_limit = 2
    http_tokens                 = "required"
    instance_metadata_tags      = "disabled"
  }
  # primary_network_interface {
  #   network_interface_id = "eni-0797b26766cfd49dc"
  # }
  private_dns_name_options {
    enable_resource_name_dns_a_record    = false
    enable_resource_name_dns_aaaa_record = false
    hostname_type                        = "ip-name"
  }
  root_block_device {
    delete_on_termination = true
    encrypted             = false
    iops                  = 3000
    tags                  = {}
    tags_all              = {}
    throughput            = 125
    volume_size           = 8
    volume_type           = "gp3"
  }
}
