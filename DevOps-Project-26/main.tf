#root

module "vpc" {
    source = "./vpc"
}

module "ec2" {
    source = "./web"
    sn =  module.vpc.pb_sn
    sg =  module.vpc.sg 

}