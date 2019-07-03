## 1. Generate the token to connect to OpenStack
## curl -X POST http://192.168.64.12:5000/v2.0/tokens -d '{"auth":{"passwordCredentials":{"username":"aum865", "password":"06ALex1196"}, "tenantId":"bb6f28e13f7249409aab847252975d2f"}}' -H 'Content-type: application/json' > token.json
variable "user_name" {default = "aum865"}

## 2. Abrir el archivo token.json generado en la operación curl y copiar el token de acceso

variable "my_token" {
  default = "gAAAAABctJ_gbeHKri2cWOcZ727VY5Spe6bD1ATUB5D7XOpzv6s7cYVF08NiRzy5EJOMnk5ZMNA7pwCN3J1JlFDP07UEiptlUOFMp1ZoJLTpNRwUSg-RCqvhrZOi3sMyK7HRZMn1oRqoI4Y3xBM7WEbAHFuQJ1do_WnPZqRK5rdMiVMv8pcjXj0"  
}

variable "project_name" {
  default = "aum865"     ## Nombre del proyecto en OpenStack / provider tenant_name
}
variable "project_network" {
  default = "aum865-net"  ## Nombre de la rede en Opentstack / network name
}



# Configure the OpenStack Provider
provider "openstack" {
  user_name   = "${var.user_name}"
  tenant_name = "${var.project_name}"
  token 	  = "${var.my_token}"
  auth_url    = "http://192.168.64.12:5000/v3/"
  region      = "RegionOne"
}

########################################
# Crear la Virtual Machine: admin
########################################

resource "openstack_compute_instance_v2" "mi_tf_admin" {
  name      = "ub18vm-cnsa"
  availability_zone = "nova"
  image_id  = "9eabea01-c377-4911-9ee0-7276ae4ca820"    ## Ubuntu 18
  flavor_name = "medium"
  key_pair  = "ParSSH"
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
  instance_id = "${openstack_compute_instance_v2.mi_tf_admin.id}"
}

########################################
# Crear la Virtual Machine: node1
########################################

resource "openstack_compute_instance_v2" "mi_tf_node1" {
  name      = "ub18node1-cnsa"
  availability_zone = "nova"
  image_id  = "9eabea01-c377-4911-9ee0-7276ae4ca820"    ## Ubuntu 18
  flavor_name = "medium"
  key_pair  = "ParSSH"  ## comprobar el nombre el Key Pair en OpenStack y cambiar si es necesario
  security_groups = ["default"]
  
  network {
    name = "${var.project_network}"
  }

}

# Crear una IP de mi pool ext-net

resource "openstack_networking_floatingip_v2" "myipnode1" {
  pool = "ext-net"
}

# Asociar la IP
resource "openstack_compute_floatingip_associate_v2" "myipnode1" {
  floating_ip = "${openstack_networking_floatingip_v2.myipnode1.address}"
  instance_id = "${openstack_compute_instance_v2.mi_tf_node1.id}"
}

########################################
# Crear la Virtual Machine: node2
########################################

resource "openstack_compute_instance_v2" "mi_tf_node2" {
  name      = "ub18node2-cnsa"
  availability_zone = "nova"
  image_id  = "9eabea01-c377-4911-9ee0-7276ae4ca820"    ## Ubuntu 18
  flavor_name = "medium"
  key_pair  = "ParSSH"
  security_groups = ["default"]
  
  network {
    name = "${var.project_network}"
  }

}

# Crear una IP de mi pool ext-net

resource "openstack_networking_floatingip_v2" "myipnode2" {
  pool = "ext-net"
}

# Asociar la IP
resource "openstack_compute_floatingip_associate_v2" "myipnode2" {
  floating_ip = "${openstack_networking_floatingip_v2.myipnode2.address}"
  instance_id = "${openstack_compute_instance_v2.mi_tf_node2.id}"
}



