terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.94"
    }
  }
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
  token                   = var.oauth_token
}

# Если enable_real = false — создаём только заглушку:
resource "null_resource" "sandbox" {
  count = var.enable_real ? 0 : 1
  triggers = {
    always = timestamp()
  }

  provisioner "local-exec" {
    command = "echo \"Sandbox mode: инфраструктура не создаётся\""
  }
}

# Реальные ресурсы создаются только при enable_real = true:
resource "yandex_iam_service_account" "ci_account" {
  count       = var.enable_real ? 1 : 0
  name        = "ci-service-account"
  description = "Service Account для Terraform CI/CD"
}

resource "yandex_vpc_network" "main" {
  count = var.enable_real ? 1 : 0
  name  = "test-network"
}

resource "yandex_vpc_subnet" "subnet" {
  count          = var.enable_real ? 1 : 0
  name           = "test-subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.main[0].id
  v4_cidr_blocks = ["10.0.0.0/24"]
}

data "yandex_compute_image" "ubuntu" {
  count  = var.enable_real ? 1 : 0
  family = "ubuntu-2204-lts"
}

resource "yandex_compute_disk" "disk" {
  count    = var.enable_real ? 1 : 0
  name     = "test-vm-disk"
  type     = "network-ssd"
  zone     = var.zone
  size     = 1024
  image_id = data.yandex_compute_image.ubuntu[0].image_id
}

resource "yandex_compute_instance" "vm" {
  count = var.enable_real ? 1 : 0
  name  = "test-vm"
  zone  = var.zone

  resources {
    cores  = 4
    memory = 16
  }

  boot_disk {
    disk_id = yandex_compute_disk.disk[0].id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet[0].id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("${path.module}/id_rsa.pub")}"
  }
}
