resource "google_storage_bucket" "tf_bucket" {
  name     = "tf-bucket-663730"
  location = "US"

  force_destroy               = true
  uniform_bucket_level_access = true
}
