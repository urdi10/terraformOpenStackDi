## 1. Generate the token to connect to OpenStack
## curl -X POST http://192.168.64.12:5000/v2.0/tokens -d '{"auth":{"passwordCredentials":{"username":"jjcanada", "password":"PASSWORD"}, "tenantId":"7cbf04cede6d4919991b8bb3b3afa0c0"}}' -H 'Content-type: application/json' > token.json
variable "user_name" {default = "jjcanada"}

## 2. Abrir el archivo token.json generado en la operación curl y copiar el token de acceso

variable "my_token" {
  default = "PASTE_THE_TOKEN_HERE"  
}

variable "project_name" {
  default = "jjcanada"     ## Nombre del proyecto en OpenStack / provider tenant_name
}
variable "project_network" {
  default = "jcanada-net"  ## Nombre de la rede en Opentstack / network name
}



# Configure the OpenStack Provider
provider "openstack" {
  user_name   = "${var.user_name}"
  tenant_name = "${var.project_name}"
  token 	  = "${var.my_token}"
  auth_url    = "http://192.168.64.12:5000/v3/"
  region      = "RegionOne"
}


# Crear la Virtual Machine 

resource "openstack_compute_instance_v2" "mi_tf_instance" {
  name      = "ub18vm-cnsa"
  availability_zone = "nova"
  image_id  = "9eabea01-c377-4911-9ee0-7276ae4ca820"    ## Ubuntu 18
  flavor_name = "medium"
  key_pair  = "${var.user_name}"
  security_groups = ["default"]
  
  network {
    name = "${var.project_network}"
  }

}

# Crear una IP de mi pool ext-net

resource "openstack_networking_floatingip_v2" "myip" {
  pool = "ext-net"
}

# Asociar la IP
resource "openstack_compute_floatingip_associate_v2" "myip" {
  floating_ip = "${openstack_networking_floatingip_v2.myip.address}"
  instance_id = "${openstack_compute_instance_v2.mi_tf_instance.id}"
}

