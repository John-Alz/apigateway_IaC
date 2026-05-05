variable "capacity" {
  description = "Nombre del proyecto"
  type        = string
}

variable "env" {
  description = "Ambiente (dev, qa, sbx, stg, pdn)"
  type        = string
}

variable "country" {
  description = "País de despliegue (co, pa, gt, ts)"
  type        = string
}

variable "confidentiality" {
  description = "Clasificación de confidencialidad"
  type        = string
}

variable "integrity" {
  description = "Clasificación de integridad"
  type        = string
}

variable "api_description" {
  description = "Descripción de la API"
  type        = string
  default     = "Api para reto apigateway"
}

variable "healtcheck_path_tg" {
  description = "Ruta del healthcheck"
  type        = string
  default     = "/health"
}

variable "microservice_type" {
  description = "Tipo de microservicio"
  type        = string
}

variable "tags" {
  description = "Tags por defecto"
  type        = map(string)
  nullable    = true
}

variable "endpoint_types" {
  description = "Tipos de endpoint"
  type        = string
}

variable "handler" {
  description = "Función manejadora"
  type        = string
}

variable "runtime" {
  description = "Entorno de ejecución"
  type        = string
}
