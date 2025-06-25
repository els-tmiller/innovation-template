locals {

  vpc_id = length(data.aws_vpcs.innovation.ids) > 0 ? data.aws_vpcs.innovation.ids[0] : null

  cidr_block = local.vpc_id != null ? data.aws_vpc.innovation[local.vpc_id].cidr_block : null

  subnets = {
    public  = local.vpc_id != null ? data.aws_subnets.public[local.vpc_id].ids : []
    private = local.vpc_id != null ? data.aws_subnets.private[local.vpc_id].ids : []
  }
}