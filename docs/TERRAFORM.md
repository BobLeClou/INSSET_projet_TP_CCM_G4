# Documentation Terraform

Ce fichier est généré automatiquement par terraform-docs.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 7.14.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloud_sql"></a> [cloud\_sql](#module\_cloud\_sql) | ./modules/cloud-sql | n/a |
| <a name="module_compute_backend"></a> [compute\_backend](#module\_compute\_backend) | ./modules/compute-backend | n/a |
| <a name="module_dns"></a> [dns](#module\_dns) | ./modules/dns | n/a |
| <a name="module_firewall"></a> [firewall](#module\_firewall) | ./modules/pare-feu | n/a |
| <a name="module_instances_groups"></a> [instances\_groups](#module\_instances\_groups) | ./modules/instances | n/a |
| <a name="module_load_balancer"></a> [load\_balancer](#module\_load\_balancer) | ./modules/load-balancer | n/a |
| <a name="module_network"></a> [network](#module\_network) | ./modules/network | n/a |
| <a name="module_peering_back_cloudsql"></a> [peering\_back\_cloudsql](#module\_peering\_back\_cloudsql) | ./modules/vpc-peering | n/a |
| <a name="module_peering_bastion_front"></a> [peering\_bastion\_front](#module\_peering\_bastion\_front) | ./modules/vpc-peering | n/a |
| <a name="module_peering_front_back"></a> [peering\_front\_back](#module\_peering\_front\_back) | ./modules/vpc-peering | n/a |
| <a name="module_secret_manager"></a> [secret\_manager](#module\_secret\_manager) | ./modules/secret-manager | n/a |
| <a name="module_service_accounts"></a> [service\_accounts](#module\_service\_accounts) | ./modules/SA-IAM | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_proxy_target_tags"></a> [allow\_proxy\_target\_tags](#input\_allow\_proxy\_target\_tags) | description | `list(any)` | `[]` | no |
| <a name="input_dns_managed_zone_name"></a> [dns\_managed\_zone\_name](#input\_dns\_managed\_zone\_name) | Le nom de la zone DNS | `string` | n/a | yes |
| <a name="input_firewall_direction"></a> [firewall\_direction](#input\_firewall\_direction) | Direction of the firewall rule (INGRESS(entry) or EGRESS(sortie)) | `string` | `"INGRESS"` | no |
| <a name="input_firewall_name"></a> [firewall\_name](#input\_firewall\_name) | Name of the firewall rule | `string` | `null` | no |
| <a name="input_firewall_network_name"></a> [firewall\_network\_name](#input\_firewall\_network\_name) | Name of the VPC network | `string` | `null` | no |
| <a name="input_firewall_ports"></a> [firewall\_ports](#input\_firewall\_ports) | List of ports for the firewall rule | `list(number)` | `[]` | no |
| <a name="input_firewall_priority"></a> [firewall\_priority](#input\_firewall\_priority) | Priority of the firewall rule (lower numbers = higher priority) | `number` | `1000` | no |
| <a name="input_firewall_protocol"></a> [firewall\_protocol](#input\_firewall\_protocol) | Protocol for the firewall rule (tcp, udp, icmp, etc.) | `string` | `null` | no |
| <a name="input_firewall_proxy_prority"></a> [firewall\_proxy\_prority](#input\_firewall\_proxy\_prority) | La priorité des règles liés au proxy | `number` | n/a | yes |
| <a name="input_firewall_rules"></a> [firewall\_rules](#input\_firewall\_rules) | Map des règles de pare-feu à créer | <pre>map(object({<br/>    firewall_name          = string<br/>    firewall_network_name  = string<br/>    firewall_priority      = optional(number, 1000)<br/>    firewall_protocol      = string<br/>    firewall_ports         = optional(list(number), [])<br/>    firewall_source_ranges = list(string)<br/>    firewall_target_tags   = optional(list(string), [])<br/>  }))</pre> | `{}` | no |
| <a name="input_firewall_source_ranges"></a> [firewall\_source\_ranges](#input\_firewall\_source\_ranges) | List of source CIDR ranges | `list(string)` | `[]` | no |
| <a name="input_firewall_target_tags"></a> [firewall\_target\_tags](#input\_firewall\_target\_tags) | List of target tags for the firewall rule | `list(string)` | `[]` | no |
| <a name="input_instance_groups"></a> [instance\_groups](#input\_instance\_groups) | Configuration des groupes d'instances à créer | <pre>map(object({<br/>    instance_group_name    = optional(string)<br/>    base_instance_name     = optional(string)<br/>    zone                   = optional(string)<br/>    target_size            = optional(number)<br/>    machine_type           = optional(string)<br/>    source_image           = optional(string)<br/>    vpc_id                 = optional(string)<br/>    subnetwork_id          = optional(string)<br/>    metadata               = optional(map(string))<br/>    service_account_email  = optional(list(string))<br/>    service_account_scopes = optional(list(string))<br/>    health_check_id        = optional(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_named_ports"></a> [named\_ports](#input\_named\_ports) | Liste des ports nommés à configurer pour les groupes d'instances | <pre>list(object({<br/>    name  = string<br/>    ports = number<br/>  }))</pre> | `[]` | no |
| <a name="input_network_tags"></a> [network\_tags](#input\_network\_tags) | Liste des tags réseau à appliquer aux instances | `list(string)` | `[]` | no |
| <a name="input_networks"></a> [networks](#input\_networks) | Configuration des VPC et sous-réseaux (bastion/frontend/backend) | <pre>map(object({<br/>    vpc_name                    = string<br/>    vpc_description             = string<br/>    vpc_auto_create_subnetworks = bool<br/>    subnetwork_name             = string<br/>    subnetwork_ip_cidr_range    = string<br/>  }))</pre> | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | ID du projet GCP | `string` | `"g4-insset-projet-2025"` | no |
| <a name="input_proxy_subnet_ip_cidr_range"></a> [proxy\_subnet\_ip\_cidr\_range](#input\_proxy\_subnet\_ip\_cidr\_range) | La plage d'adresse du sous-réseau des proxies | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Région GCP pour les ressources | `string` | `"europe-west1"` | no |
| <a name="input_service_accounts"></a> [service\_accounts](#input\_service\_accounts) | Map des Service Accounts à créer et rôles à appliquer | <pre>map(object({<br/>    account_id   = optional(string)<br/>    display_name = optional(string)<br/>    description  = optional(string)<br/>    roles        = optional(list(string), [])<br/>  }))</pre> | `{}` | no |
| <a name="input_tier"></a> [tier](#input\_tier) | The machine tier for Cloud SQL instance | `string` | n/a | yes |
| <a name="input_zone"></a> [zone](#input\_zone) | Zone GCP pour les ressources | `string` | `"europe-west1-b"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_group_names"></a> [instance\_group\_names](#output\_instance\_group\_names) | Noms des groupes d'instances créés (par clé: frontend, backend, bastion, ...) |
| <a name="output_service_accounts_emails"></a> [service\_accounts\_emails](#output\_service\_accounts\_emails) | Emails des service accounts par clé |
<!-- END_TF_DOCS -->