variable "region"{
    default = "ap-south-2"
}

variable "bucket_name" {
    description = "Unique s3 bucket"
}

variable "environment" {
    default = "prod"
}