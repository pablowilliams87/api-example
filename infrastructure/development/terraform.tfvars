region                = "us-east-1"
environment           = "development"
vpc_subnet            = "10.10.0.0/16"
url_measurements      = "https://gist.githubusercontent.com/jvillarf/040c91397d779d4da02fff54708ca935/raw/f1dbbcbfbc4e3daace7d907a3cc5b716ef808014/environment_airq_measurand.csv"
public_subnets        = { us-east-1a = "10.10.10.0/24", us-east-1b = "10.10.11.0/24" }
private_subnets       = { us-east-1a = "10.10.15.0/24", us-east-1b = "10.10.16.0/24" }
ecs_ami_id            = "ami-0669eafef622afea1"
ecs_cluster           = "dev-ecs-measurement-app"
ecs_instance_type     = "t3.medium"
ecs_public_key        = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCfW21z0xc7gC4/xQBkB1KKBQa3Ox4HWK8Pheu5x+LOQxC6F5frBv8eSd81L5s8k3jRllZWswwEx+ZmfrCkVE5fy86l8II9+FV0wjaohpL3zpOJybUDbH8d+YjrrRcLWfUNVBmhCzF+gDxvBHT9TFW3OCIHqHtfM4UHD89kOx22+o37H/KWdXq4gSan2Z6cju16RH0bqOlXehMTPpPaDr+4c2TfTNBtCBsCO/niktQgq62lKIrJQ05Kh1v9STBqZidzwPmIpJLe+If4uGxk4UM5QnzrcS5+jKcSSWvGZZfeat29aGCyNpfd7wBH7+iiSzmcU4/rKCiv7ByzCBTc+qrp pablow@DESKTOP-K7SL4L"
asg_capacity          = [1, 1, 2]
rds_db                = "environment_airq_measurand"
rds_user              = "postgres"
rds_instancetype      = "db.t3.micro"
image_tag             = "pablowilliams87/measurement-app:1.2"
container_name        = "development-measurement-app"
container_count       = 1
container_cpu         = 256
container_memory      = 256
container_status_path = "/status"
flask_env             = "development"
init_db               = "0"