# Dev
This repo my creates dev environemnt.

`provision` contains the terraform part which is triggered by creating a PR and automatically applys when merged into master.

I am using Github Actions for the automation.

Sample PR: https://github.com/kavehmz/dev/pull/15#issuecomment-904024276

```hcl
aws_vpc.dev_vpc: Refreshing state... [id=vpc-0e434fc937ec7c46c]
aws_internet_gateway.gw: Refreshing state... [id=igw-0d13bdb32f42b8240]
aws_subnet.dev_us_east_1a: Refreshing state... [id=subnet-031948f8e811d6a18]

Terraform used the selected providers to generate the following execution
plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_instance.dev[0] will be created
  + resource "aws_instance" "dev" {
      + ami                                  = "ami-05ad4ed7f9c48178b"
      + arn                                  = (known after apply)
      + associate_public_ip_address          = true
      + availability_zone                    = (known after apply)


.....


      + root_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + tags                  = (known after apply)
          + throughput            = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  ~ dev_ip = [
      + (known after apply),
    ]

```

Rest of directories provide the skeleton of how my local env looks like.

# Build
Create a PR against this repo.
