resource "aws_s3_bucket" "website_files" {
  bucket = "${module.environment.aws_account_id}-${var.environment_name}-website-files"
}

resource "aws_s3_bucket_ownership_controls" "website_files" {
  bucket = aws_s3_bucket.website_files.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "website_files" {
  depends_on = [aws_s3_bucket_ownership_controls.website_files]

  bucket = aws_s3_bucket.website_files.id
  acl    = "private"
}

resource "aws_s3_object" "config" {
  for_each = fileset("${path.module}/website", "**")

  bucket = aws_s3_bucket.website_files.id
  key    = each.value
  content = templatefile("${path.module}/website/${each.value}", {
    aws_account_id = module.environment.aws_account_id
    aws_region     = module.environment.aws_region
    environment    = var.environment_name
  })
}