provider "google" {
  credentials = file("C:/Users/Mark/Desktop/terraform-355617-6673cd92e28e.json")
  project = "terraform-355617"
  region  = "us-central1"
 
}

provider "google-beta" {
  credentials = file("C:/Users/Mark/Desktop/terraform-355617-6673cd92e28e.json")
  region = "us-central1"
  project = "terraform-355617"
}