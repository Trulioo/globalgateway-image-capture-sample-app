variable "BUILD_VERSION" {
  type        = string
  description = "The current build number from Bitbucket"
}

variable "ARTIFACTORY_URL" {
  type        = string
  description = "The remote repository where we store our docker images"
}

variable "ARTIFACTORY_REG_CRED" {
  type        = string
  description = "Private registry key for Artifactory authentication"
}

variable "SAMPLE_APP_IMAGE_NAME" {
  type        = string
  description = "The name of the sample app docker image"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
}


variable "aws_ssl_policy" {
  type        = string
  description = "SSL Policy for AWS load balancer listeners"
}

variable "aws_zone_id" {
  type        = string
  description = "Zone ID for AWS Route 53"
}

variable "aws_domain_name" {
  type        = string
  description = "Domain name for AWS Route 53"
}