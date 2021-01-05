# use terraform get --update for trulioo's custom aws-acm-cert module

provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket  = "gg-ic-sdk-react-sample-app-terraform-state"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

resource "aws_ecs_cluster" "gg_ic_sdk_react_sample_app" {
  name = "gg-ic-sdk-react-sample-app"
}

resource "aws_ecs_task_definition" "gg_ic_sdk_react_sample_app" {
  family                   = "gg-ic-sdk-react-sample-app"
  container_definitions    = <<DEFINITION
    [
        {
            "name": "gg-ic-sdk-react-sample-app",
            "image": "${var.ARTIFACTORY_URL}/${var.SAMPLE_APP_IMAGE_NAME}:${var.BUILD_VERSION}",
            "essential": true,
            "repositoryCredentials": {
              "credentialsParameter": "${var.ARTIFACTORY_REG_CRED}"
            },
            "portMappings": [
                {
                    "containerPort": 3000,
                    "hostPort": 3000
                }
            ],
            "memory": 512,
            "cpu": 256
        }
    ]
    DEFINITION
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = 512
  cpu                      = 256
  execution_role_arn       = aws_iam_role.gg_ic_sdk_react_sample_app_ecs_role.arn
}

resource "aws_iam_role" "gg_ic_sdk_react_sample_app_ecs_role" {
  name               = "gg_ic_sdk_react_sample_app_ecs_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "secrets_policy_document" {
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
    ]
    resources = [var.ARTIFACTORY_REG_CRED]
  }
}

resource "aws_iam_policy" "secrets_policy" {
  name        = "gg_ic_sdk_react_sample_app_secrets_access"
  path        = "/"
  description = "Policy for allowing access to Secrets Manager for React Sample App"
  policy      = data.aws_iam_policy_document.secrets_policy_document.json
}

resource "aws_iam_role_policy_attachment" "gg_ic_sdk_react_sample_app_ecs_role_policy" {
  role       = aws_iam_role.gg_ic_sdk_react_sample_app_ecs_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "gg_ic_sdk_react_sample_app_sm_role_policy" {
  role       = aws_iam_role.gg_ic_sdk_react_sample_app_ecs_role.name
  policy_arn = aws_iam_policy.secrets_policy.arn
}

resource "aws_ecs_service" "gg_ic_sdk_react_sample_app" {
  name            = "gg-ic-sdk-react-sample-app"
  cluster         = aws_ecs_cluster.gg_ic_sdk_react_sample_app.id
  task_definition = aws_ecs_task_definition.gg_ic_sdk_react_sample_app.arn
  launch_type     = "FARGATE"
  desired_count   = 2

  load_balancer {
    target_group_arn = aws_lb_target_group.gg_ic_sdk_react_sample_app_target_group.arn
    container_name   = aws_ecs_task_definition.gg_ic_sdk_react_sample_app.family
    container_port   = 3000
  }

  network_configuration {
    subnets = [
      aws_default_subnet.gg_ic_sdk_react_sample_app_subnet_a.id,
      aws_default_subnet.gg_ic_sdk_react_sample_app_subnet_b.id,
      aws_default_subnet.gg_ic_sdk_react_sample_app_subnet_c.id,
    ]
    assign_public_ip = true
    security_groups  = [aws_security_group.gg_ic_sdk_react_sample_app_svc_security_group.id]
  }
}

resource "aws_default_vpc" "gg_ic_sdk_react_sample_app_vpc" {
}

resource "aws_default_subnet" "gg_ic_sdk_react_sample_app_subnet_a" {
  availability_zone = "${var.aws_region}a"
}

resource "aws_default_subnet" "gg_ic_sdk_react_sample_app_subnet_b" {
  availability_zone = "${var.aws_region}b"
}

resource "aws_default_subnet" "gg_ic_sdk_react_sample_app_subnet_c" {
  availability_zone = "${var.aws_region}c"
}

resource "aws_alb" "gg_ic_sdk_react_sample_app_alb" {
  name               = "gg-ic-sdk-react-sample-app"
  load_balancer_type = "application"
  subnets = [
    aws_default_subnet.gg_ic_sdk_react_sample_app_subnet_a.id,
    aws_default_subnet.gg_ic_sdk_react_sample_app_subnet_b.id,
    aws_default_subnet.gg_ic_sdk_react_sample_app_subnet_c.id,
  ]
  security_groups = [aws_security_group.gg_ic_sdk_react_sample_app_alb_security_group.id]
}

resource "aws_security_group" "gg_ic_sdk_react_sample_app_alb_security_group" {
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "gg_ic_sdk_react_sample_app_svc_security_group" {
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.gg_ic_sdk_react_sample_app_alb_security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "gg_ic_sdk_react_sample_app_target_group" {
  name        = "gg-ic-sdk-react-sample-app-t-grp"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_default_vpc.gg_ic_sdk_react_sample_app_vpc.id
  health_check {
    matcher = "200,301,302"
    path    = "/"
  }
  depends_on = [aws_alb.gg_ic_sdk_react_sample_app_alb]
}

resource "aws_lb_listener" "gg_ic_sdk_react_sample_app_http" {
  load_balancer_arn = aws_alb.gg_ic_sdk_react_sample_app_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "gg_ic_sdk_react_sample_app_https" {
  load_balancer_arn = aws_alb.gg_ic_sdk_react_sample_app_alb.arn
  port              = "443"
  protocol          = "HTTPS"

  ssl_policy      = var.aws_ssl_policy
  certificate_arn = module.aws-acm-cert.certificate.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.gg_ic_sdk_react_sample_app_target_group.arn
  }
}

resource "aws_route53_record" "www_domain" {
  zone_id = var.aws_zone_id
  name    = "gg-ic-sdk-react-sample-app"
  type    = "CNAME"
  ttl     = 300
  records = [aws_alb.gg_ic_sdk_react_sample_app_alb.dns_name]
}

module "aws-acm-cert" {
  source                 = "git@bitbucket.org:trulioo/terraform-module-aws-acm-certificate.git?ref=0.0.9"
  domain_name            = var.aws_domain_name
  route53_hosted_zone_id = var.aws_zone_id
}