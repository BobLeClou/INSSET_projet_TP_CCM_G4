module "network" {
    source = "./modules/network"
    for_each = var.networks

    #Paramètres du réseau
    vpc_name = lookup(each.value, "vpc_name", null)
    vpc_description = lookup(each.value, "vpc_description", null)
    vpc_auto_create_subnetworks = lookup(each.value, "vpc_auto_create_subnetworks", false)

    #Paramètre du sous-réseau correspondant
    subnetwork_name = lookup(each.value, "subnetwork_name", null)
    subnetwork_ip_cidr_range = lookup(each.value, "subnetwork_ip_cidr_range", null)
}
