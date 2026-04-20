terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  folder_id = var.folder_id
  # zone = "ru-central1-d"
}

variable "folder_id" {
  type        = string
  description = "folder id"
  default     = "b1gj8t6a23qthe0mdeck" # yc config list
}

variable "subnet_id" {
  type        = string
  description = "subnet id"
  default     = "fl8t5451pgpcgjp5fhvl" # yc vpc subnet list
}

variable "security_group_id" {
  type        = string
  description = "security group id"
  default     = "enp54dle7md02jnbulv3" # yc vpc security-group list
}

variable "instance_name" {
  type    = string
  default = "tripplanner-vm"
}

variable "ssh_public_key" {
  type        = string
  description = "public ssh key"
  default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJRy2xTx1XiYIsphsrJyZtQ3qguTFxwIfHOY+v7/j7yB (none)"
}

data "yandex_vpc_subnet" "main" {
  subnet_id = var.subnet_id
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2404-lts"
}

resource "yandex_compute_instance" "vm" {
  name        = var.instance_name
  platform_id = "standard-v3"
  zone        = data.yandex_vpc_subnet.main.zone

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 10
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id          = var.subnet_id
    nat                = true
    security_group_ids = [var.security_group_id]
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}"
  }

  allow_stopping_for_update = true
}

output "instance_id" {
  value = yandex_compute_instance.vm.id
}

output "instance_name" {
  value = yandex_compute_instance.vm.name
}

output "instance_ip" {
  description = "external ip"
  value       = yandex_compute_instance.vm.network_interface[0].nat_ip_address
}

output "instance_internal_ip" {
  value = yandex_compute_instance.vm.network_interface[0].ip_address
}
