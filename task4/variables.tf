variable "enable_real" {
  description = "Флаг — создавать реальные ресурсы или нет"
  type        = bool
  default     = false
}

variable "oauth_token" {
  description = "OAuth-токен Yandex Cloud"
  type        = string
  default     = ""
}

variable "cloud_id" {
  description = "ID облака"
  type        = string
  default     = ""
}

variable "folder_id" {
  description = "ID папки"
  type        = string
  default     = ""
}

variable "zone" {
  description = "Зона развёртывания"
  type        = string
  default     = "ru-central1-a"
}
