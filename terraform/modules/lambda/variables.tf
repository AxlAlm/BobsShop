
variable "name" {
  type        = string
  description = "Name of the function"
}

variable "runtime" {
  type        = string
  description = "runtime env, e.g. python python3.9"

}

variable "source_dir" {
  type = string
}
