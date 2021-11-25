variable "company_name" {
  type    = string
  default = "company"
}

variable "AWS_REGION" {
  type    = string
  default = "us-east-1"

}

variable "source_bucket" {
  type    = string
  default = "andy-mediaconvert2"

}

variable "destination_bucket" {
  type    = string
  default = "andy-mediaconvert-dest2"

}

variable "MediaConvert_Default_Role_Name" {
  type    = string
  default = "MediaConvert_Default_Role2"
}

variable "VOD_Lambda_Role_Name" {
  type    = string
  default = "VODLambdaRole2"
}

variable "VOD_Lambda_Function_Name" {
  type    = string
  default = "VODLambdaConvert2"
}

## AWS Credential and Account Information
variable "AWS_PROFILE" {
  type    = string
  default = "default"
}