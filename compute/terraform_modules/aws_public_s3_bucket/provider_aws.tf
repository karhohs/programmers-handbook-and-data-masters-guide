provider "aws" {
  version = "~> 1.2"

  region  = "${var.region}"

}

provider "null" {
  version = "~> 1.0"

}

provider "terraform" {
  version = "~> 1.0"

}
