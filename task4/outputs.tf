output "mode" {
  description = "Режим работы (sandbox или real)"
  value       = var.enable_real ? "real" : "sandbox"
}

output "service_account_id" {
  description = "ID сервисного аккаунта"
  value       = var.enable_real ? yandex_iam_service_account.ci_account[0].id : "not created"
}

output "vm_id" {
  description = "ID виртуальной машины"
  value       = var.enable_real ? yandex_compute_instance.vm[0].id : "not created"
}

output "vm_public_ip" {
  description = "Публичный IP виртуальной машины"
  value       = var.enable_real ? yandex_compute_instance.vm[0].network_interface[0].nat_ip_address : "not created"
}
