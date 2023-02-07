
variable "names" {
  type        = list(string)
  description = "Names of the function"
}

variable "runtimes" {
  type        = list(string)
  description = "runtime envs, e.g. [python3.9]"

}

variable "source_dirs" {
  type        = list(string)
  description = "directories of the code"
}
