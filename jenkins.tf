

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





provider "aws" {
  access_key =  "${var.access_key}"
  region     = "${var.region}"
}

/********************************
*
* Variables
*
*********************************/
    # "Parameters": {
      #   "ChefTeamID": {
      #     "Description": "First three letters of six letter ACOM stack designation. ex: ABC",
      #     "Type": "String",
      #     "Default":"tpn"
      #   },
    variable "ChefTeamID" {
      description = "First three letters of six letter ACOM stack designation. ex: ABC"
      type = "string"
      default = "tpn"
    }
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
    # "ChefStackID": {
      #   "Description": "Last three letters of six  letter ACOM stack designation. ex: SVC",
      #   "Type": "String",
      #   "Default": "aut"
      # },    
      variable "ChefStackID" {
      description = "Last three letters of six  letter ACOM stack designation. ex: SVC"
      type = "string"
      default = "aut"
    }
    # "Environment": {
      #   "Description": "Specify Environment - PRD, PPE, ACC",
      #   "Type": "String",
      #   "Default": "ACC",
      #   "AllowedValues": [
      #     "ACC","PPE","PRD"
      #   ],
      #   "ConstraintDescription": "Must be a valid Environment"
      # },
    variable "Env" {
      description = "Specify Environment - PRD, PPE, DEV"
      type = "string"
      default = "dev"
      //  allowedvalues = ["DEV","PPE","PRD"] // Syntax to do this?
    }
    # "Owner": {
      #   "Description": "The technical owner's username",
      #   "Type": "String",
      #   "Default": "blowder"
      # },    
    variable "Owner" {
      description = "The technical owner's username"
      type = "string"
      default = "blowder"
    }
    variable "DBServerName" {
      description = "Database Server Name"
      type = "string"
      default = "vdb_commerceaccupdate_dev.ancestrydata.int"
    }
    # "DbUrl": {
      #   "Description": "Database Server Name",
      #   "Type": "String",
      #   "Default": "jdbc:mysql://vdb_commerceaccupdate_dev.ancestrydata.int:3306/CommerceAccUpdate?connectTimeout=30000&socketTimeout=30000&serverTimezone=UTC"
      # },
    variable "DBUrl" {
      description = "Database URL"
      type = "string"
      default = "jdbc:mysql://vdb_commerceaccupdate_dev.ancestrydata.int:3306/CommerceAccUpdate?connectTimeout=30000&socketTimeout=30000&serverTimezone=UTC"
    }
    variable "DBName" {
      description = "Database(Schema) name"
      type = "string"
      default = "CommerceAccUpdate"
    }
    # "DBUser" : {
      #   "Description" : "Database user name",
      #   "Type" : "String",
      #   "Default": "CommAccUpdAppDev"
      # },
    variable "DBUser" {
      description = "Database user name"
      type = "string"
      default = "adminUser"
    }
    #  "DBPassword": {
      #   "NoEcho": "true",
      #   "Description": "Database admin account password",
      #   "Type": "String",
      #   "MinLength": "1",
      #   "MaxLength": "41",
      #   "AllowedPattern": "[a-zA-Z0-9]*"
      # },   
    variable "DBPassword" {
      //  noecho = "true"
      description = "Database admin account password"
      type = "string"
      //  minlength = "1"
      //  maxlength = "41"
      default = "DBPassword"
    }
    # "AlarmEmail": {
      #   "Default": "PaymentServices@ancestry.com",
      #   "Description": "Email address to notify if operational problems arise",
      #   "Type": "String"
      # },
    variable "AlarmEmail" {
      description = "Email address to notify if operational problems arise"
      type = "string"
      default = "PaymentServices@ancestry.com"
    }
    # "ProcessMessageIterationsCount" : {
      #   "Description" : "Number of iterations the ProcessMessage Lambda will run.",
      #   "Type" : "String",
      #   "Default": "10"
      # },
    variable "ProcessMessageIterationsCount" {
      description = "Number of iterations the ProcessMessage Lambda will run."
      type = "string"
      default = "10"
    }
    # "ProcessMessageLambdaLimit" : {
      #   "Description" : "Max number of MessageProcess Lambdas that the managaer will launch.",
      #   "Type" : "String",
      #   "Default": "50"
      # },
    variable "ProcessMessageLambdaLimit" {
      description = ""
      type = "string"
      default = "50"
    }
    # "MaxBatchSize" : {
      #   "Description" : "Maximum size of batch to send to Cybersource.",
      #   "Type" : "String",
      #   "Default": "5000"
      # },    
    variable "MaxBatchSize" {
      description = ""
      type = "string"
      default = "5000"
    }
    #  TODO
      # "CybersourceEnvironment" : {
      #   "Description" : "Cybersource Environment (test or live).",
      #   "Type" : "String",
      #   "Default": "test"
      # },

    #  TODO
      # "ProcessBatchLambdaLimit" : {
      #   "Description" : "Max number of RetrieveResponse Lambdas that the managaer will launch.",
      #   "Type" : "String",
      #   "Default": "50"
      # }
    

/********************************
*
* Resources
*
*********************************/

  /********************************
  *
  * Queues, Topics, Alarms
  *
  *********************************/
    resource "aws_sqs_queue"              "PseudoEmail" {
      // Create this pseudo email queue because Terraform does not support email SNS endpoints. Figure out slack.
      name                        = "AUPseudoEmail"
      delay_seconds               = 0
      max_message_size            = 262144
      message_retention_seconds   = 604800
      receive_wait_time_seconds   = 0
      visibility_timeout_seconds  = 150
    }

    # "RequestQueue" : {
      #   "Type" : "AWS::SQS::Queue",
      #   "Properties" : {
      #     "QueueName" : "AURequestQueue",
      #     "DelaySeconds": 0,
      #     "MaximumMessageSize": 262144,
      #     "MessageRetentionPeriod": 604800,
      #     "ReceiveMessageWaitTimeSeconds": 20,
      #     "VisibilityTimeout": 150
      #   }
      # },    
    resource "aws_sqs_queue"       "RequestQueue" {
      name                        = "AURequestQueue"
      delay_seconds               = 0
      max_message_size            = 262144
      message_retention_seconds   = 604800
      receive_wait_time_seconds   = 20
      visibility_timeout_seconds  = 150
    }
    # "SqsRequestQueueAlarmTopic": {
      #   "Type": "AWS::SNS::Topic",
      #   "Properties": {
      #     "Subscription": [{
      #       "Endpoint": { "Ref": "AlarmEmail" },
      #       "Protocol": "email"
      #     }]
      #   }
      # },
    resource "aws_sns_topic"               "SqsRequestQueueAlarmTopic" {
      depends_on = ["aws_sqs_queue.PseudoEmail"]
      name = "SqsRequestQueueAlarmTopic"
    }
    resource "aws_sns_topic_subscription" "SqsRequestQueueAlarmTopicSubscription" {
      topic_arn = "${aws_sns_topic.SqsRequestQueueAlarmTopic.arn}"
      protocol  = "sqs" // Email is unsupported by Terraform becaue Terraform only supports subscriptions with auto confirm
      endpoint  = "${aws_sqs_queue.PseudoEmail.arn}"
    }
    # "QueueDepthAlarm": {
      #   "DependsOn" : [ "RequestQueue", "SqsRequestQueueAlarmTopic" ],
      #   "Type": "AWS::CloudWatch::Alarm",
      #   "Properties": {
      #     "AlarmDescription": "Alarm if queue depth grows beyond 100,000 messages",
      #     "Namespace": "AWS/SQS",
      #     "MetricName": "ApproximateNumberOfMessagesVisible",
      #     "Dimensions": [{
      #       "Name": "QueueName",
      #       "Value" : { "Fn::GetAtt" : ["RequestQueue", "QueueName"] }
      #     }],
      #     "Statistic": "Sum",
      #     "Period": "300",
      #     "EvaluationPeriods": "1",
      #     "Threshold": "100000",
      #     "ComparisonOperator": "GreaterThanThreshold",
      #     "AlarmActions": [{
      #       "Ref": "SqsRequestQueueAlarmTopic"
      #     }]
      #   }
      # },   
    resource "aws_cloudwatch_metric_alarm" "QueueDepthAlarm" {
      // depends_on = ["aws_sqs_queue.RequestQueue", "SqsRequestQueueAlarmTopic" ]
      alarm_name                = "QueueDepthAlarm"
      comparison_operator       = "GreaterThanOrEqualToThreshold"
      evaluation_periods        = "1"
      metric_name               = "ApproximateNumberOfMessagesVisible"
      namespace                 = "AWS/SQS"
      period                    = "300"
      statistic                 = "Sum"
      threshold                 = "100000"
      alarm_description         = "Alarm if queue depth grows beyond 100,000 messages"
      dimensions {
        QueueName = "${aws_sqs_queue.RequestQueue.name}"
      }
      alarm_actions     = ["${aws_sns_topic.SqsRequestQueueAlarmTopic.arn}"]
    }

  /********************************
  *
  * Roles, Policies, KMS
  *
  *********************************/
    # "AuBasicLambdaExecutionRole": {
      #   "Type": "AWS::IAM::ManagedPolicy",
      #   "Properties": {
      #     "PolicyDocument": {
      #       "Version": "2012-10-17",
      #       "Statement": [
      #         {
      #           "Effect": "Allow",
      #           "Action": [
      #             "logs:CreateLogGroup",
      #             "logs:CreateLogStream",
      #             "logs:PutLogEvents"
      #           ],
      #           "Resource": "arn:aws:logs:*:*:*"
      #         }
      #       ]
      #     }
      #   }
      # },
    resource "aws_iam_policy" "AuBasicLambdaExecutionRole" {
        name = "AuBasicLambdaExecutionRole"
        path = "/"
        description = "AuBasicLambdaExecutionRole"
        // Beware of evil below. The opening bracket of the policy cannot be indented or it breaks the here doc and causes a parsing error.
        policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:logs:*:*:*"
    }
  ]
}
EOF
} 
    # "WriteToAURequestQueueRole" : {
      #   "DependsOn" : "RequestQueue",
      #   "Type": "AWS::IAM::Role",
      #   "Properties": {
      #     "RoleName" : "AuWriteToRequestQueueRole",
      #     "AssumeRolePolicyDocument": {
      #       "Version" : "2012-10-17",
      #       "Statement": [ {
      #         "Effect": "Allow",
      #         "Principal": {
      #           "Service": [ "ec2.amazonaws.com" ]
      #         },
      #         "Action": [ "sts:AssumeRole" ]
      #       } ]
      #     }
      #   }
      # },
    resource "aws_iam_role" "WriteToAURequestQueueRole" {
        name = "AuWriteToRequestQueueRole"
        depends_on = ["aws_sqs_queue.RequestQueue"]
        path = "/"
        // Beware of evil below. The opening bracket of the policy cannot be indented or it breaks the here doc and causes a parsing error.
        assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [ "sts:AssumeRole" ],
      "Effect": "Allow",
      "Principal": {
        "Service": [ "ec2.amazonaws.com" ]
      }
    }
  ]
}
EOF
} 
    # "ProcessQueueManagerRole" : {
      #   "DependsOn" : "AuBasicLambdaExecutionRole",
      #   "Type": "AWS::IAM::Role",
      #   "Properties": {
      #     "RoleName" : "AuProcessQueueManagerRole",
      #     "AssumeRolePolicyDocument": {
      #       "Version" : "2012-10-17",
      #       "Statement": [ {
      #         "Effect": "Allow",
      #         "Principal": {
      #           "Service": [ "lambda.amazonaws.com" ]
      #         },
      #         "Action": [ "sts:AssumeRole" ]
      #       } ]
      #     },
      #     "ManagedPolicyArns" : [
      #       "arn:aws:iam::aws:policy/AmazonSQSFullAccess",
      #       "arn:aws:iam::aws:policy/AWSLambdaFullAccess",
      #       "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole",
      #       { "Ref": "AuBasicLambdaExecutionRole" }
      #     ]
      #   }
      # },
    resource "aws_iam_role" "ProcessQueueManagerRole" {
        name = "AuProcessQueueManagerRole"
        depends_on = ["aws_iam_policy.AuBasicLambdaExecutionRole"]
        // path = "/"
        // description = "ProcessQueueManagerRole"
        // Beware of evil below. The opening bracket of the policy cannot be indented or it breaks the here doc and causes a parsing error.
        assume_role_policy = <<EOF
{
          "Version" : "2012-10-17",
          "Statement": [ {
            "Effect": "Allow",
            "Principal": {
              "Service": [ "lambda.amazonaws.com" ]
            },
            "Action": [ "sts:AssumeRole" ]
          } ]
}
EOF
}
        // These attachments are needed to augment the ProcessQueueManagerRole
        // Because Terraform does not support baking them inline
        resource "aws_iam_policy_attachment" "ProcessQueueManagerRoleAttach1" {
            name = "ProcessQueueManagerRoleAttach1"
            roles = ["${aws_iam_role.ProcessQueueManagerRole.name}"]
            policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
        } 
        resource "aws_iam_policy_attachment" "ProcessQueueManagerRoleAttach2" {
            name = "ProcessQueueManagerRoleAttach2"
            roles = ["${aws_iam_role.ProcessQueueManagerRole.name}"]
            policy_arn = "arn:aws:iam::aws:policy/AWSLambdaFullAccess"
        } 
        resource "aws_iam_policy_attachment" "ProcessQueueManagerRoleAttach3" {
            name = "ProcessQueueManagerRoleAttach3"
            roles = ["${aws_iam_role.ProcessQueueManagerRole.name}"]
            policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
        } 
        resource "aws_iam_policy_attachment" "ProcessQueueManagerRoleAttach4" {
            name = "ProcessQueueManagerRoleAttach4"
            roles = ["${aws_iam_role.ProcessQueueManagerRole.name}"]
            policy_arn = "${aws_iam_policy.AuBasicLambdaExecutionRole.arn}"
        } 

    # TODO
    # "RequestQueuePolicy" : {
      #   "DependsOn" : ["ProcessQueueManagerRole", "RequestQueue"],
      #   "Type" : "AWS::SQS::QueuePolicy",
      #   "Properties" : {
      #     "PolicyDocument" : {
      #       "Version": "2012-10-17",
      #       "Statement": [{
      #         "Effect": "Allow",
      #         "Principal": {"AWS" : { "Fn::GetAtt": [ "ProcessQueueManagerRole", "Arn" ] }},
      #         "Action": "SQS:*",
      #         "Resource": { "Fn::GetAtt": ["RequestQueue", "Arn"] }
      #       },
      #         {
      #           "Effect": "Allow",
      #           "Principal": {"AWS" : { "Fn::GetAtt": [ "WriteToAURequestQueueRole", "Arn" ] }},
      #           "Action": "SQS:SendMessage",
      #           "Resource": { "Fn::GetAtt": ["RequestQueue", "Arn"] }
      #         },
      #         {
      #           "Effect": "Allow",
      #           "Principal": {"AWS" : { "Fn::GetAtt": [ "WriteToAURequestQueueRole", "Arn" ] }},
      #           "Action": "SQS:ListQueues",
      #           "Resource": { "Fn::GetAtt": ["RequestQueue", "Arn"] }
      #         }
      #       ]
      #     },
      #     "Queues" : [
      #       { "Fn::GetAtt": ["RequestQueue", "QueueName"] }
      #     ]
      #   }
      # },
#       resource "aws_sqs_queue_policy" "RequestQueuePolicy" {
#         depends_on = ["aws_iam_role.ProcessQueueManagerRole", ]
#         queue_url = "${aws_sqs_queue.RequestQueue.id}"
#         policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Id": "RequestQueuePolicy",
#   "Statement": [{
#     "Effect": "Allow",
#     "Principal": "arn:aws:iam:::role/ProcessQueueManagerRole",
#     "Action": "SQS:*",
#     "Resource": { "Fn::GetAtt": ["RequestQueue", "Arn"] }
#     },
#     {
#       "Effect": "Allow",
#       "Principal": "arn:aws:iam:::role/AuBasicLambdaExecutionRole",
#       "Action": "SQS:SendMessage",
#       "Resource": { "Fn::GetAtt": ["RequestQueue", "Arn"] }
#     },
#     {
#       "Effect": "Allow",
#       "Principal": "arn:aws:iam:::role/AuBasicLambdaExecutionRole",
#       "Action": "SQS:ListQueues",
#       "Resource": { "Fn::GetAtt": ["RequestQueue", "Arn"] }
#     }
#   ]

# }
# POLICY
# }


  /********************************
  *
  *     KMS
  *
  *********************************/
     # "AuLambdaKMS" : {
      #   "Type" : "AWS::KMS::Key",
      #   "Properties" : {
      #     "Description" : "AU Lambda KMS",
      #     "KeyPolicy" : {
      #       "Id": "key-consolepolicy-3",
      #       "Version": "2012-10-17",
      #       "Statement": [
      #         {
      #           "Sid": "Enable IAM User Permissions",
      #           "Effect": "Allow",
      #           "Principal": {
      #             "AWS": [
      #               "arn:aws:iam::087958225878:root"
      #             ]
      #           },
      #           "Action": "kms:*",
      #           "Resource": "*"
      #         },
      #         {
      #           "Sid": "Allow access for Key Administrators",
      #           "Effect": "Allow",
      #           "Principal": {
      #             "AWS": [
      #               { "Fn::GetAtt": [ "ProcessQueueManagerRole", "Arn" ] }
      #             ]
      #           },
      #           "Action": [
      #             "kms:Create*",
      #             "kms:Describe*",
      #             "kms:Enable*",
      #             "kms:List*",
      #             "kms:Put*",
      #             "kms:Update*",
      #             "kms:Revoke*",
      #             "kms:Disable*",
      #             "kms:Get*",
      #             "kms:Delete*",
      #             "kms:TagResource",
      #             "kms:UntagResource",
      #             "kms:ScheduleKeyDeletion",
      #             "kms:CancelKeyDeletion"
      #           ],
      #           "Resource": "*"
      #         },
      #         {
      #           "Sid": "Allow use of the key",
      #           "Effect": "Allow",
      #           "Principal": {
      #             "AWS": [
      #               { "Fn::GetAtt": [ "ProcessQueueManagerRole", "Arn" ] }
      #             ]
      #           },
      #           "Action": [
      #             "kms:Encrypt",
      #             "kms:Decrypt",
      #             "kms:ReEncrypt*",
      #             "kms:GenerateDataKey*",
      #             "kms:DescribeKey"
      #           ],
      #           "Resource": "*"
      #         },
      #         {
      #           "Sid": "Allow attachment of persistent resources",
      #           "Effect": "Allow",
      #           "Principal": {
      #             "AWS": [
      #               { "Fn::GetAtt": [ "ProcessQueueManagerRole", "Arn" ] }
      #             ]
      #           },
      #           "Action": [
      #             "kms:CreateGrant",
      #             "kms:ListGrants",
      #             "kms:RevokeGrant"
      #           ],
      #           "Resource": "*",
      #           "Condition": {
      #             "Bool": {
      #               "kms:GrantIsForAWSResource": true
      #             }
      #           }
      #         }
      #       ]
      #     }
      #   }
      # },
    resource "aws_kms_key" "AuLambdaKMS" {
      description             = "AuLambdaKMS"
      deletion_window_in_days = 10
      policy  = <<EOF
{
          "Id": "key-consolepolicy-3",
          "Version": "2012-10-17",
          "Statement": [
            {
              "Sid": "Enable IAM User Permissions",
              "Effect": "Allow",
              "Principal": {
                "AWS": [
                  "arn:aws:iam::087958225878:root"
                ]
              },
              "Action": "kms:*",
              "Resource": "*"
            },
            {
              "Sid": "Allow access for Key Administrators",
              "Effect": "Allow",bbbb
              "Principal": {
                "AWS": "${aws_iam_role.ProcessQueueManagerRole.arn}"
              },
              "Action": [
                "kms:Create*",
                "kms:Describe*",
                "kms:Enable*",
                "kms:List*",
                "kms:Put*",
                "kms:Update*",
                "kms:Revoke*",
                "kms:Disable*",
                "kms:Get*",
                "kms:Delete*",
                "kms:TagResource",
                "kms:ScheduleKeyDeletion",
                "kms:CancelKeyDeletion"
              ],
              "Resource": "*"
            },
            {
              "Sid": "Allow use of the key",
              "Effect": "Allow",
              "Principal": {
                "AWS": "${aws_iam_role.ProcessQueueManagerRole.arn}" 
              },
              "Action": [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:DescribeKey"
              ],
              "Resource": "*"
            },
            {
              "Sid": "Allow attachment of persistent resources",
              "Effect": "Allow",
              "Principal": {
                "AWS": "${aws_iam_role.ProcessQueueManagerRole.arn}" 
              },
              "Action": [
                "kms:CreateGrant",
                "kms:ListGrants",
                "kms:RevokeGrant"
              ],
              "Resource": "*",
              "Condition": {
                "Bool": {
                  "kms:GrantIsForAWSResource": true
                }
              }
            }
          ]
}
EOF
} 
      # "AuLambdaKMSAlias" : {
        #   "DependsOn" : "AuLambdaKMS",
        #   "Type" : "AWS::KMS::Alias",
        #   "Properties" : {
        #     "AliasName" : "alias/AU-Lambda-KMS",
        #     "TargetKeyId" : {"Ref":"AuLambdaKMS"}
        #   }
        # },
      resource "aws_kms_alias" "AuLambdaKMSAlias" {
        name          = "alias/AU-Lambda-KMS"
        target_key_id = "${aws_kms_key.AuLambdaKMS.key_id}"
      }

  /********************************
  *
  *     Lambdas
  *
  *********************************/
      #  "ProcessQueueManager" : {
        #   "DependsOn" : ["ProcessQueueManagerRole", "RequestQueue", "AuLambdaKMS"],
        #   "Type" : "AWS::Lambda::Function",
        #   "Properties" : {
        #     "FunctionName" : "AUProcessSqsManager",
        #     "Code" : {
        #       "S3Bucket" : "commerce-sox-tpn-aut",
        #       "S3Key" : "tuppence-account-updater-process-sqs-manager.jar",
        #     },
        #     "Description" : "Determines how many AUProcessSqsMessage Lambda functions to spawn",
        #     "Environment" : {
        #       "Variables" : {
        #         "AU_PROCESS_REQUEST_QUEUE_URL": { "Ref": "RequestQueue" },
        #         "AU_PROCESS_MESSAGE_LAMBDA_LIMIT": { "Ref": "ProcessMessageLambdaLimit" },
        #         "AU_PROCESS_MESSAGE_ITERATIONS_COUNT": { "Ref": "ProcessMessageIterationsCount" }
        #       }
        #     },
        #     "KmsKeyArn" : { "Fn::GetAtt": [ "AuLambdaKMS", "Arn" ] },
        #     "Handler" : "com.ancestry.tuppence.account_updater.ProcessSQSManager::handleRequest",
        #     "MemorySize" : 256,
        #     "Role" : { "Fn::GetAtt": [ "ProcessQueueManagerRole", "Arn" ] },
        #     "Runtime" : "java8",
        #     "Timeout" : 60
        #   }
        # }, 
      resource "aws_lambda_function" "ProcessQueueManager" {
       //  s3_bucket        = "commerce-sox-tpn-aut"
       //  s3_key           = "tuppence-account-updater-process-sqs-manager.jar"
        filename         = "tuppence-account-updater-process-sqs-manager.jar"
        function_name    = "AUProcessSqsManager"
        role             = "${aws_iam_role.ProcessQueueManagerRole.arn}" 
        handler          = "com.ancestry.tuppence.account_updater.ProcessSQSMessage::handleRequest"
        runtime          = "java8"
        memory_size      = "256"
        timeout          = "60"
        environment {
          variables = {
            AU_PROCESS_REQUEST_URL = "${aws_sqs_queue.RequestQueue.arn}"
            AU_PROCESS_MESSAGE_LAMBDA_LIMIT =  "${var.ProcessMessageLambdaLimit}"
            AU_PROCESS_MESSAGE_ITERATIONS_COUNT = "${var.ProcessMessageIterationsCount}"
          }
        }
       kms_key_arn = "${aws_kms_key.AuLambdaKMS.arn}"
      }
      # TODO
      # "ProcessQueueMessage" : {
        #   "DependsOn" : [ "ProcessQueueManagerRole", "RequestQueue", "AuLambdaKMS" ],
        #   "Type" : "AWS::Lambda::Function",
        #   "Properties" : {
        #     "FunctionName" : "AUProcessSqsMessage",
        #     "Code" : {
        #       "S3Bucket" : "commerce-sox-tpn-aut",
        #       "S3Key" : "tuppence-account-updater-process-sqs-message.jar"
        #     },
        #     "Description" : "Retrieves messages from queue to write into db.",
        #     "Environment" : {
        #       "Variables" : {
        #         "AU_PROCESS_REQUEST_QUEUE_URL": { "Ref": "RequestQueue" },
        #         "AU_DB_URL": {"Ref" : "DbUrl"},
        #         "AU_DB_USER": {"Ref" : "DBUser"},
        #         "AU_DB_PASSWORD": {"Ref" : "DBPassword"},
        #         "AU_PROCESS_MESSAGE_ITERATIONS_COUNT": { "Ref": "ProcessMessageIterationsCount" }
        #       }
        #     },
        #     "KmsKeyArn" : { "Fn::GetAtt": [ "AuLambdaKMS", "Arn" ] },
        #     "Handler" : "com.ancestry.tuppence.account_updater.ProcessSQSMessage::handleRequest",
        #     "MemorySize" : 256,
        #     "Role" : { "Fn::GetAtt": [ "ProcessQueueManagerRole", "Arn" ] },
        #     "Runtime" : "java8",
        #     "Timeout" : 120,
        #     "VpcConfig" : {
        #         "SecurityGroupIds" : [ "sg-b79cdacb" ],
        #         "SubnetIds" : [ "subnet-88e982d3","subnet-8601b9ba", "subnet-b09bb8f9", "subnet-0bbec326" ]
        #     }
        #   }
        # },
      resource "aws_lambda_function" "ProcessQueueMessage" {
        filename         = "tuppence-account-updater-process-sqs-message.jar"
        function_name    = "AUProcessSqsMessage"
        role             = "${aws_iam_role.ProcessQueueManagerRole.arn}" // TODO:  Not the right role. Should have a ProcessQueueMessageRole.
        handler          = "com.ancestry.tuppence.account_updater.ProcessSQSMessage::handleRequest"
        runtime          = "java8"
        memory_size      = "256"
        timeout          = "120"
        environment {
          variables = {
            AU_PROCESS_REQUEST_URL =  "${aws_sqs_queue.RequestQueue.arn}"
            AU_DB_SERVER_NAME_KEY  = "${var.DBServerName}"
            AU_DB_NAME             =  "${var.DBName}"
            AU_DB_USER             =  "${var.DBUser}"
            AU_DB_PASSWORD         =  "${var.DBPassword}"
            AU_PROCESS_MESSAGE_ITERATIONS_COUNT =  "${var.ProcessMessageIterationsCount}"
          }
        }
        kms_key_arn = "${aws_kms_key.AuLambdaKMS.arn}"
        // vpc_config =  // TODO add subnets
      }

      # "PermissionForEventsToInvokeLambda": {
      #   "Type": "AWS::Lambda::Permission",
      #   "Properties": {
      #     "FunctionName" : { "Fn::GetAtt" : ["ProcessQueueManager", "Arn"] },
      #     "Action": "lambda:InvokeFunction",
      #     "Principal": "events.amazonaws.com",
      #     "SourceArn": { "Fn::GetAtt": ["ProcessQueueManagerSchedule", "Arn"] }
      #   }
      # },

  /********************************
  *
  *     CloudWatch
  *
  *********************************/
      # "ProcessQueueManagerSchedule": {
        #   "Type": "AWS::Events::Rule",
        #   "Properties": {
        #     "Description" : "Schedule to launch the ProcessQueueManager",
        #     "ScheduleExpression": "rate(2 minutes)",
        #     "State": "ENABLED",
        #     "Targets": [{
        #       "Arn": { "Fn::GetAtt": ["ProcessQueueManager", "Arn"] },
        #       "Id": "ProcessQueueManager"
        #     }]
        #   }
        # },
      resource "aws_cloudwatch_event_rule" "ProcessQueueManagerSchedule" {
        name = "ProcessQueueManagerSchedule"
        description = "Schedule to launch the ProcessQueueManager"
        is_enabled = true
        event_pattern = <<PATTERN
{
        "ScheduleExpression": ["rate(2 minutes)"]
}
PATTERN
}
        // Terraform does not support inliningin the target with the schedule
        resource "aws_cloudwatch_event_target" "ProcessQueueManagerScheduleTarget" {
          rule = "${aws_cloudwatch_event_rule.ProcessQueueManagerSchedule.name}"
          target_id = "StartQueueManager"
          arn = "${aws_lambda_function.ProcessQueueManager.arn}"
        }

  /********************************
  *
  *     Aurora
  *
  *********************************/

#       resource "aws_rds_cluster" "account-updater-aurora-db" {
#         cluster_identifier            = "${var.Env}-aurora-cluster"
#         database_name                 = "${var.Env}${var.DBName}"
#         master_username               = "${var.DBUser}"
#         master_password               = "${var.DBPassword}"
#         backup_retention_period       = 7
#         preferred_backup_window       = "02:00-03:00"
#         preferred_maintenance_window  = "wed:03:00-wed:04:00"
#  //       db_subnet_group_name          = "${aws_db_subnet_group.aurora_subnet_group.name}"
#         final_snapshot_identifier     = "${var.Env}-${var.DBName}-aurora-cluster"
#         # vpc_security_group_ids        = [
#         #     "${var.vpc_rds_security_group_id}"
#         # ]

#         tags {
#             Name         = "${var.Env}_aurora_cluster"
#         //    VPC          = "${var.vpc_name}"
#             ManagedBy    = "terraform"
#             Environment  = "${var.Env}"
#         }

#         lifecycle {
#             create_before_destroy = true
#         }

#       }

#       resource "aws_rds_cluster_instance" "aurora-cluster-instance" {

#           //count                 = "${length(split(",", var.vpc_rds_subnet_ids))}"
#           count                 = "1"

#           identifier            = "${var.Env}-aurora-instance-1"
#          // cluster_identifier    = "${var.Env}-aurora-cluster"
#           cluster_identifier    = "${aws_rds_cluster.account-updater-aurora-db.cluster_identifier}"
#           instance_class        = "db.t2.small"
#          // db_subnet_group_name  = "${aws_db_subnet_group.aurora_subnet_group.name}"
#           publicly_accessible   = true

#           tags {
#               Name         = "${var.Env}-aurora-cluster"
#              // VPC          = "${var.vpc_name}"
#               ManagedBy    = "terraform"
#               Environment  = "${var.Env}"
#           }

#           lifecycle {
#               create_before_destroy = true
#           }

#       }









/********************************
*
* Outputs
*
*********************************/

      output "QueueURL" {
        value         = "${aws_sqs_queue.RequestQueue.url}"
        description   = "URL of newly created SQS Queue"
      }

      output "QueueName" {
        value         = "${aws_sqs_queue.RequestQueue.name}"
        description   = "Name of newly created SQS Queue"
      }

      output "QueueARN" {
        value         = "${aws_sqs_queue.RequestQueue.arn}"
        description   = "ARN of newly created SQS Queue"
      }

      output "ProcessQueueManager" {
        value         = "${aws_lambda_function.ProcessQueueManager.arn}"
        description   = "ARN of newly created ProcessQueueManager Lambda function"
      }

      # output "CreateUpdateRequestManager" {
      #   value         = "${aws_rds_cluster_instance.aurora_cluster_instance.public_dns}"
      #   description   = "ARN of newly created CreateUpdateRequestManager Lambda function"
      # }
