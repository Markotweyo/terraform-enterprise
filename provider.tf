provider "google" {
  credentials = file("C:/Users/Mark/Desktop/terraform-355617-bb4e0d0bb13a.json")
  project = "terraform-355617"
  region  = "us-east4"
 
}

provider "google-beta" {
  credentials = file("C:/Users/Mark/Desktop/terraform-355617-bb4e0d0bb13a.json")
  region = "us-east4"
  project = "terraform-355617"
}