data "nutanix_cluster" "cluster" {
  name = "labs-nutanix-aws-2"
}

data "nutanix_subnet" "subnet" {
  subnet_name = "PC-Net"
}

resource "nutanix_virtual_machine" "ubuntu_vm" {
  name                 = var.vm_name
  cluster_uuid         = data.nutanix_cluster.cluster.id
  num_vcpus_per_socket = 2
  num_sockets          = 1
  memory_size_mib      = 4096

  disk_list {
    data_source_reference = {
      kind = "image"
      uuid = "5d820796-5601-4194-a207-c965f8066509"
    }

    device_properties {
      disk_address = {
        device_index = 0
        adapter_type = "SCSI"
      }
      device_type = "DISK"
    }
  }

  nic_list {
    subnet_uuid = data.nutanix_subnet.subnet.id
  }


  guest_customization_cloud_init_user_data = base64encode(<<-EOF
    #cloud-config
    runcmd:
    - <%=instance.cloudConfig.agentInstall%>
    - <%=instance.cloudConfig.finalizeServer%>
    EOF
  )
}
