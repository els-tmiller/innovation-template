locals {

  vpc_id = length(data.aws_vpcs.innovation.ids) > 0 ? data.aws_vpcs.innovation.ids[0] : null

  cidr_block = local.vpc_id != null ? data.aws_vpc.innovation[local.vpc_id].cidr_block : null

  subnets = {
    public  = local.vpc_id != null ? data.aws_subnets.public[local.vpc_id].ids : []
    private = local.vpc_id != null ? data.aws_subnets.private[local.vpc_id].ids : []
  }

  account_alias = data.aws_iam_account_alias.current.id
  dev_account = strcontains(local.account_alias, "dev") ? true : false
  short_account_name = local.dev_account ?  split("-", local.account_alias)[2] : split(split("-", local.account_alias[1]), "dce")[1]
  domain_name        = "${local.short_account_name}${local.dev_account ? ".nonprod" : ""}.dce.tio-cloud.com"
}