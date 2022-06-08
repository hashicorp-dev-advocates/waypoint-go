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

app "example" {
  build {
    use "docker" {}

    registry {
      use "docker" {
        image = "10.5.0.100/hashicraft/payments"
        tag   = "latest"
      }
    }
  }

  deploy {
    use "nomad" {
      datacenter = "dc1"
    }
  }

  release {
  }
}
