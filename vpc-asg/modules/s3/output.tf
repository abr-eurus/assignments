

output "object_URL" {
  value = "https://${aws_s3_bucket.bucket.bucket_domain_name}/${var.BUCKET.OBJECT.KEY}"
}

output "bucket_obj" {
  value = aws_s3_bucket_object.object
}