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

app "release" {
  build {
    use "consul-release-controller" {
      releaser {
        plugin_name = consul
        config {
          consul_service = "api"
        }
      }
      runtime {
        plugin_name = "ecs"
        config {
          deployment = "api-deployment"
          namespace  = "default"
        }
      }
      strategy {
        plugin_name = "canary"
        config {
          initial_delay   = "30s"
          interval        = "30s"
          initial_traffic = 10
          traffic_step    = 40
          max_traffic     = 100
          error_threshold = 5
        }
      }
      monitor {
        plugin_name = "prometheus"
        config {
          address = "http://localhost:9090"
          queries = [
            {
              name   = "request-success"
              preset = "envoy-request-success"
              min    = 99
            },
            {
              name   = "request-duration"
              preset = "envoy-request-duration"
              min    = 20
              max    = 2000
            }
          ]
        }
      } 
    }
  }
  // added because waypoint wouldn't initialize without it
  deploy {
    use "nomad" {
      datacenter = "dc1"
    }
  }
}
 
