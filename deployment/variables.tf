# variable "service_images" {
#   description = "list of images to create ecs services with"
#   type        = list(string)
#   default = []
# }


variable "service" {
  description = "ecs services to deploy"
  type        = object({
    service_name = string
    image= string
    port= number
  })
}