
variable "service_name" {
  type        = string
  description = "name of the service"
}

# variable "names" {
#   type        = list(string)
#   description = "Names of the function"
# }

# variable "runtime" {
#   type        = string
#   description = "runtime env, e.g. python3.9"

# }

# variable "paths_to_lambda_functions" {
#   type        = list(string)
#   description = "directories of the code"
# }

# variable "path_to_layer_zip" {
#   type        = string
#   description = "path to package zip for layer"
# }


variable "configs" {
  type = list(map(string))
  default = {
    name    = "config",
    runtime = "python3.9"
    # path_to_lambda_function = ""
    # path_to_layer_zip = ""
  }
}
