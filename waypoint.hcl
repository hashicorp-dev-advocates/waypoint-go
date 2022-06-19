project = "hashicraft"

runner {
  enabled = true

  data_source "git" {
    url = "https://github.com/hashicorp-dev-advocates/waypoint-go.git"
    ref = "main"
  }

  poll {
    enabled = true
  }
}

app "example-deployment" {
  build {
    use "docker" {}

    registry {
      use "docker" {
        image = "10.5.0.100/hashicraft/paymentss"
        tag   = "latest"
      }
    }
  }

  deploy {
    use "noop" {
    }
  }

  release {
  }
}
