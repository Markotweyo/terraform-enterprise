terraform {
 backend "gcs" {
   bucket  = "bucket-tfstate-name"
   prefix  = "terraform/state"
 }
}