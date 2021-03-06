provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "${var.aws_region}"
}

resource "aws_emr_cluster" "emr-test-cluster" {
  name          = "emr-test-vishnu"
  release_label = "emr-5.7.0"
  applications  = ["Spark","Hadoop","Hive"]

  termination_protection = false
  keep_job_flow_alive_when_no_steps = true

  ec2_attributes {
    subnet_id                         = "subnet-cca70284"
    emr_managed_master_security_group = "sg-d26f6fad"
    emr_managed_slave_security_group  = "sg-d26f6fad"
    instance_profile                  = "arn:aws:iam::285704482825:instance-profile/EMR_EC2_DefaultRole"
    key_name = "C2i-Admin"
  }

  master_instance_type = "m3.xlarge"
  core_instance_type   = "m3.xlarge"
  core_instance_count  = 2
  

  tags {
    OWNER = "Vishnu.Ravi"
    CostCenter = "CTO"
  }

 bootstrap_action {
    path = "s3://elasticmapreduce/bootstrap-actions/run-if"
    name = "runif"
    args = ["instance.isMaster=true", "echo running on master node"]
  }

 configurations = "test-fixtures/hiveConfiguration.json"

log_uri = "s3://c2i-admin/logs"


  service_role = "arn:aws:iam::285704482825:role/EMR_DefaultRole"
}
