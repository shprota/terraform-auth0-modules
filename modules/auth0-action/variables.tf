variable "name" {
  type    = string
  default = "Action"
}

variable "runtime" {
  type    = string
  default = "node16"
}

variable "code" {
  type = string
}

variable "deploy" {
  type    = bool
  default = false
}

variable "supported_triggers" {
  type = object({
    id      = string
    version = string
  })
  default = ({
    id      = "post-login"
    version = "v3"
  })
}

variable "secrets" {
  description = "Some actions may require secrets to run. Secrets can be passed in a key,value format."
  type        = map(string)
  default     = {}
}

variable "dependencies" {
  type = list(object({
    name    = string
    version = string
  }))
  default = []
}
