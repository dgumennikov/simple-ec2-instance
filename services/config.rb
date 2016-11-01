## This file was auto-generated by CloudCoreo CLI
## This file was automatically generated using the CloudCoreo CLI
##
## This config.rb file exists to create and maintain services not related to compute.
## for example, a VPC might be maintained using:
##
## coreo_aws_vpc_vpc "my-vpc" do
##   action :sustain
##   cidr "12.0.0.0/16"
##   internet_gateway true
## end
##

## This file was automatically generated using the CloudCoreo CLI
##
## This config.rb file exists to create and maintain services not related to compute.
## for example, a VPC might be maintained using:
##
## coreo_aws_vpc_vpc "my-vpc" do
##   action :sustain
##   cidr "12.0.0.0/16"
##   internet_gateway true
## end
##

coreo_aws_ec2_securityGroups "${SERVER_NAME}${SUFFIX}" do
  action :sustain
  description "Server security group"
  vpc "${VPC_NAME}"
  allows [ 
          { 
            :direction => :ingress,
            :protocol => :tcp,
            :ports => ${SERVER_INGRESS_PORTS},
            :cidrs => ${SERVER_INGRESS_CIDRS}
          },{ 
            :direction => :egress,
            :protocol => :tcp,
            :ports => ["0..65535"],
            :cidrs => ["0.0.0.0/0"]
          }
    ]
end

coreo_aws_ec2_instance "${SERVER_NAME}${SUFFIX}" do
  action :define
  image_id "${SERVER_AMI}"
  size "${SERVER_SIZE}"
  security_groups ["${SERVER_NAME}"]
#  role "${SERVER_NAME}"
  ssh_key "${SERVER_KEYPAIR}"
  disks [
         {
           :device_name => "/dev/xvda",
           :volume_size => 16
         }
        ]
end

coreo_aws_ec2_autoscaling "${SERVER_NAME}${SUFFIX}" do
  action :sustain 
  minimum 1
  maximum 1
  server_definition "${SERVER_NAME}"
  subnet "${PUBLIC_SUBNET_NAME}"
end
