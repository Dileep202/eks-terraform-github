variable "cluster_name" {}
variable "cidr_block" {}
variable "vpc-name" {}
variable "env" {}
variable "igw-name" {}
variable "pub-subnet-count" {
    
}
variable "pub-cidr-block" {
    type = list(string)
}
variable "pub-availability-zone" {
    type = list(string)
}
variable "pub-sub-name" {}
variable "priv-subnet-count" {
}
variable "priv-cidr-block" {
    type = list(string)
}
variable "priv-availability-zone" {
    type = list(string)
}
variable "priv-sub-name" {}
variable "pub-rt-name" {}
variable "nat-gw-eip-name" {}
variable "ngw-name" {}
variable "priv-rt-name" {}
variable "eks-sg" {}
variable  "is_eks_role_enabled"  { 
 type = bool 
 } 
variable  "is_eks_nodegroup_role_enabled"  { 
 type = bool 
 } 

variable "cluster-version" {}
variable "endpoint-private-access" {}
variable "endpoint-public-access" {}
variable "addons" {
     type = list(object({ 
 name    = string 
 version = string 
 }))
}
variable "desired_capacity_on_demand" {}
variable "min_capacity_on_demand" {}
variable "max_capacity_on_demand" {}
variable "ondemand_instance_types" {}
variable "desired_capacity_spot" {}
variable "min_capacity_spot" {}
variable "max_capacity_spot" {}
variable "spot_instance_types" {}












  





  
