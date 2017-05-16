/********************************
*
* Code Notes
*
*********************************/
  # cd C:\ZDrive\workspace\tuppence-terraform
 
  # To build:                               mvn clean install –U
  # To see all dependencies and versions:   mvn dependency:tree
  # To build eclipse project mvn eclipse:   eclipse

  # See if you can improve performance on the inbound and figure this out:
  # - Update S3 to have Lambda pick up the new version of the code.

  # http://books.sonatype.com/mvnref-book/reference/
  # https://maven.apache.org/guides/getting-started/maven-in-five-minutes.html
  # http://books.sonatype.com/mvnref-book/pdf/mvnref-pdf.pdf


/********************************
*
* Variables
*
*********************************/
    variable "access_key" {
      description = "Just the access key, Not the secret key"
      type = "string"
      default = "AKIAIGNOK4NYJLXLKRAQ"
    }
    variable "region" {
      description = "Region"
      type = "string"
      default = "us-east-2"
    }
    variable "account" {
      description = "RegiAccount Numberon"
      type = "string"
      default = "999"
    }
    variable "Env" {
      description = "Specify Environment - PRD, PPE, DEV"
      type = "string"
      default = "dev"
      //  allowedvalues = ["DEV","PPE","PRD"] // Syntax to do this?
    }
    variable "Owner" {
      description = "The technical owner's username"
      type = "string"
      default = "blowder"
    }

/********************************
*
* Resources
*
*********************************/


    data "template_file" "user_data_script" {
        template = "${file("${path.module}\\user-data-script.sh")}"
    }

    resource "aws_security_group" "InvokeJenkins" {
        name        = "LogInAndInvokeJenkins"
        description = "Allow inbound traffic to Jenkins from known CIDRs"

        ingress {
            from_port   = 22
            to_port     = 8080
            protocol    = "TCP"
            cidr_blocks = ["64.134.175.0/24", "64.134.220.0/24"]
        }

        egress {
            from_port       = 0
            to_port         = 0
            protocol        = "-1"
            cidr_blocks     = ["0.0.0.0/0"]
        //    prefix_list_ids = ["pl-12c4e678"]
        }

        tags {
            Name = "allow_LogInAndInvokeJenkins"
        }
    }

    resource "aws_instance" "jenkins" {
        ami           = "ami-4191b524"  // TODO Remove Hardcoded
        instance_type = "m4.xlarge"  // TODO Remove Hardcoded
        iam_instance_profile = "${aws_iam_instance_profile.jenkins_instance_profile.name}"
        // vpc_security_group_ids = ["sg-888dabf1"] // TODO Remove Hardcoded
        vpc_security_group_ids = ["${aws_security_group.InvokeJenkins.id}"] // TODO Remove Hardcoded
        // subnet_id = "subnet-24f6877c"    // TODO Remove Hardcoded
        associate_public_ip_address = true
        key_name = "Mike-us-east-2-Test"
        ebs_block_device {
            device_name = "/dev/xvda"
            volume_size = "100"
//            volume_type = "gp2"
        }
        user_data = "${data.template_file.user_data_script.rendered}"
        tags {
            Name = "Jenkins"
        }
    }




/********************************
*
* Outputs
*
*********************************/

      output "InstanceIP" {
        value         = "${aws_instance.jenkins.public_ip}"
        description   = "URL of newly created SQS Queue"
      }

      output "JenkinsURL" {
        value         = "http://${aws_instance.jenkins.public_ip}:8080"
        description   = "URL of newly created SQS Queue"
      }

    #   output "QueueName" {
    #     value         = "${aws_sqs_queue.RequestQueue.name}"
    #     description   = "Name of newly created SQS Queue"
    #   }

    #   output "QueueARN" {
    #     value         = "${aws_sqs_queue.RequestQueue.arn}"
    #     description   = "ARN of newly created SQS Queue"
    #   }

    #   output "ProcessQueueManager" {
    #     value         = "${aws_lambda_function.ProcessQueueManager.arn}"
    #     description   = "ARN of newly created ProcessQueueManager Lambda function"
    #   }

      # output "CreateUpdateRequestManager" {
      #   value         = "${aws_rds_cluster_instance.aurora_cluster_instance.public_dns}"
      #   description   = "ARN of newly created CreateUpdateRequestManager Lambda function"
      # }
