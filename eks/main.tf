 locals { 
 org = "medium" 
  
 }
module "eks" {
    source = "../module"
    env = var.env
    cluster_name = var.cluster_name
    cluster_name = "${local.env}-${local.org}-${var.cluster_name}"
    vpc-name     = "${local.env}-${local.org}-${var.vpc-name}"
    cidr_block   = var.cidr_block
    igw-name    = "${local.env}-${local.org}-${var.igw-name}"
    pub-subnet-count = var.pub-subnet-count
    pub-cidr-block = var.pub-cidr-block
    pub-availability-zone = var.pub-availability-zone
    pub-sub-name = var.pub-sub-name
    priv-subnet-count = var.priv-subnet-count
    priv-cidr-block = var.priv-cidr-block
    priv-availability-zone = var.priv-availability-zone
    priv-sub-name = var.priv-sub-name
    pub-rt-name = var.pub-rt-name
    nat-gw-eip-name = var.nat-gw-eip-name
    ngw-name = var.ngw-name
    priv-rt-name = var.priv-rt-name
    eks-sg = var.eks-sg
    is_eks_role_enabled = var.is_eks_role_enabled
    is_eks_nodegroup_role_enabled = var.is_eks_nodegroup_role_enabled
    cluster-version = var.cluster-version
    endpoint-private-access = var.endpoint-private-access
    endpoint-public-access = var.endpoint-public-access
    addons = var.addons
    desired_capacity_on_demand = var.desired_capacity_on_demand
    min_capacity_on_demand = var.min_capacity_on_demand
    max_capacity_on_demand = var.max_capacity_on_demand
    ondemand_instance_types = var.ondemand_instance_types
    desired_capacity_spot = var.desired_capacity_spot
    min_capacity_spot = var.min_capacity_spot
    max_capacity_spot = var.max_capacity_spot
    spot_instance_types = var.spot_instance_types
  
}
