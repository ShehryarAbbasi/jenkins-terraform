resource "aws_iam_instance_profile" "jenkins_instance_profile" {
  name  = "jenkins-instance-profile"
  role = "${aws_iam_role.jenkins_role.name}"
}

resource "aws_iam_role" "jenkins_role" {
  name = "jenkins-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com",
          "ssm.amazonaws.com"
        ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "CloudWatchAccess" {
  name        = "CloudWatchAccess-jenkins"
  description = "CloudWatch Access"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
               "s3:GetObject",
               "s3:PutObject",
               "s3:ListObjects",
               "cloudwatch:DeleteAlarms",
               "cloudwatch:DescribeAlarmHistory",
               "cloudwatch:DescribeAlarms",
               "cloudwatch:DescribeAlarmsForMetric",
               "cloudwatch:DisableAlarmActions",
               "cloudwatch:EnableAlarmActions",
               "cloudwatch:GetMetricData",
               "cloudwatch:GetMetricStatistics",
               "cloudwatch:ListMetrics",
               "cloudwatch:PutMetricAlarm",
               "cloudwatch:PutMetricData",
               "cloudwatch:SetAlarmState",
               "logs:CreateLogGroup",
               "logs:CreateLogStream",
               "logs:GetLogEvents",
               "logs:PutLogEvents",
               "logs:DescribeLogGroups",
               "logs:DescribeLogStreams",
               "logs:PutRetentionPolicy",
               "ssm:*",
               "ec2messages:AcknowledgeMessage",
               "ec2messages:DeleteMessage",
               "ec2messages:FailMessage",
               "ec2messages:GetEndpoint",
               "ec2messages:GetMessages",
               "ec2messages:SendReply",
               "lambda:*"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "attach_cloudwatch" {
  name       = "jenkins-iam-attachment"
  policy_arn = "${aws_iam_policy.CloudWatchAccess.arn}"
  roles      = ["${aws_iam_role.jenkins_role.name}"]
}

