
# ================================================= Bucket =================================================
resource "aws_s3_bucket" "bucket" {
  bucket = "${var.TAG_NAME_PREFIX}project"
  # acl    = var.BUCKET.ACL
  force_destroy = var.BUCKET.FORCE_DESTROY

  # cors_rule {
  #   allowed_headers = ["*"]
  #   allowed_methods = ["GET"]
  #   allowed_origins = ["*"]
  # }

  tags = {
    Name = "${var.TAG_NAME_PREFIX}s3"
  }
}

# ================================================= Bucket Public Access BLock =================================================
resource "aws_s3_bucket_public_access_block" "bucket_access_block" {
  bucket = aws_s3_bucket.bucket.id
  block_public_acls   = false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_object" "object" {
  bucket = "${var.TAG_NAME_PREFIX}project"
  key    = var.BUCKET.OBJECT.KEY
  source = join("", [var.BUCKET.OBJECT.SRC, var.BUCKET.OBJECT.KEY])
  acl = var.BUCKET.OBJECT.ACL
  storage_class = var.BUCKET.OBJECT.STORAGE_CLASS
  depends_on = [
    aws_s3_bucket.bucket
  ]
}