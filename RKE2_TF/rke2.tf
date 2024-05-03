resource "rancher2_cluster_v2" "foo" {
  name                  = var.rke2ClusterName
  kubernetes_version    = var.kubernetesVersion
  enable_network_policy = false
  agent_env_vars {
    name  = "HTTP_PROXY"
    value = var.proxy
  }
  agent_env_vars {
    name  = "HTTPS_PROXY"
    value = var.proxy
  }
  agent_env_vars {
    name  = "NO_PROXY"
    value = var.no_proxy
  }

  local_auth_endpoint {
    enabled = true
  }


  rke_config {
    machine_global_config = <<EOF
      cni: "canal"
      disable:
              - rke2-ingress-nginx
      disable-rke2_ingress_nginx: true
    EOF

    machine_selector_config {
      config = yamlencode({
        system-default-registry = "${var.containerRegistry}"
      })
    }

    registries {
      mirrors {
        hostname = "docker.io"
        endpoints = [
          "https://${var.containerRegistry}"
        ]
        rewrites = {
          ".*?([^/]+)/([^/]+$)" : "docker/$1/$2"
        }
      }
      mirrors {
        hostname = "ghcr.io"
        endpoints = [
          "https://${var.containerRegistry}"
        ]
        rewrites = {
          ".*?([^/]+)/([^/]+$)" : "ghcr/$1/$2"
        }
      }
      mirrors {
        hostname = "index.docker.io"
        endpoints = [
          "https://${var.containerRegistry}"
        ]
        rewrites = {
          ".*?([^/]+)/([^/]+$)" : "docker/$1/$2"
        }
      }
      mirrors {
        hostname = "registry.k8s.io"
        endpoints = [
          "https://${var.containerRegistry}"
        ]
        rewrites = {
          ".*?([^/]+)/([^/]+$)" : "k8s/$1/$2"
        }
      }
      mirrors {
        hostname = "ssvc01-artifacts.maoam.hessen.de"
        endpoints = [
          "https://${var.containerRegistry}"
        ]
        rewrites = {
          ".*?([^/]+)/([^/]+$)" : "docker/$1/$2"
        }
      }
      mirrors {
        hostname = "registryref.xad.hessen.de"
        endpoints = [
          "https://${var.containerRegistry}"
        ]
        rewrites = {
          ".*?([^/]+)/([^/]+$)" : "docker/$1/$2"
        }
      }
      mirrors {
        hostname = "quay.io"
        endpoints = [
          "https://${var.containerRegistry}"
        ]
        rewrites = {
          ".*?([^/]+)/([^/]+$)" : "quay.io/$1/$2"
        }
      }
      mirrors {
        hostname = "registry.gitlab.com"
        endpoints = [
          "https://${var.containerRegistry}"
        ]
        rewrites = {
          ".*?([^/]+)/([^/]+$)" : "gitlab/$1/$2"
        }
      }
    }
  }
}
