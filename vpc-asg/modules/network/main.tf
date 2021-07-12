# ================================================= VPC =================================================
resource "aws_vpc" "vpc" {
  cidr_block                       = var.CIDR_VPC
  instance_tenancy                 = "default"
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name = "${var.TAG_NAME_PREFIX}VPC"
  }
}

# ================================================= IGW =================================================
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.TAG_NAME_PREFIX}igw"
  }
}

# ================================================= Private Subnet =================================================
resource "aws_subnet" "subnet_private" {
  vpc_id                          = aws_vpc.vpc.id
  cidr_block                      = cidrsubnet(var.CIDR_VPC, 8, 1)
  map_public_ip_on_launch         = false
  assign_ipv6_address_on_creation = false
  availability_zone               = var.AZs[0]

  tags = {
    Name = join("", ["${var.TAG_NAME_PREFIX}PRIVATE-subnet (", var.AZs[0], ")"])
  }
}

# ================================================= Public Subnets =================================================
resource "aws_subnet" "subnets_public" {
  count = var.ALLOW_PUBLIC_SUBNETS
  vpc_id                          = aws_vpc.vpc.id
  cidr_block                      = cidrsubnet(var.CIDR_VPC, 8, count.index+2)
  map_public_ip_on_launch         = true
  assign_ipv6_address_on_creation = false
  availability_zone               = var.AZs[count.index+1] #different AZs

  tags = {
    Name = join("", ["${var.TAG_NAME_PREFIX}PUBLIC-subnet (", var.AZs[count.index+1], ")"])
  }
}

# ================================================= Router Table (public) =================================================
resource "aws_route_table" "routerTable_public" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.TAG_NAME_PREFIX}RT-public"
  }
}

# ================================================= Router Table assiciations (public) =================================================
resource "aws_route_table_association" "rt_association_public" {
  count = var.ALLOW_PUBLIC_SUBNETS

  subnet_id      = element(aws_subnet.subnets_public.*.id, count.index)
  route_table_id = aws_route_table.routerTable_public.id
}

# ================================================= Router Table (private) =================================================
resource "aws_route_table" "routerTable_private" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "${var.TAG_NAME_PREFIX}RT-private"
  }
}

# ================================================= Router Table assiciations (private) =================================================
resource "aws_route_table_association" "rt_association_private" {

  subnet_id      = aws_subnet.subnet_private.id
  route_table_id = aws_route_table.routerTable_private.id
}

# ================================================= Security Group (load balancer) =================================================
resource "aws_security_group" "sg_load_balancer" {
  name        = "${var.TAG_NAME_PREFIX}SG-lb"
  description = "Allow HTTP, HTTPS"
  vpc_id      = aws_vpc.vpc.id

   egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.TAG_NAME_PREFIX}SG-lb"
  }
}

# ================================================= Security Group Rule (load balancer) =================================================
resource "aws_security_group_rule" "sg_loadBalancer__ingress_rules" {
  count = length(var.SG_INGRESS_RULES__LB)

  type  = "ingress"
  from_port         = var.SG_INGRESS_RULES__LB[count.index].from_port
  to_port           = var.SG_INGRESS_RULES__LB[count.index].to_port
  protocol          = var.SG_INGRESS_RULES__LB[count.index].protocol
  cidr_blocks       = [var.SG_INGRESS_RULES__LB[count.index].cidr_block]
  security_group_id = aws_security_group.sg_load_balancer.id
}

# ================================================= Security Group (Public) =================================================
resource "aws_security_group" "sg_public" {
  name        = "${var.TAG_NAME_PREFIX}SG-public"
  description = "Allow SSH, HTTP, HTTPS"
  vpc_id      = aws_vpc.vpc.id

   egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.TAG_NAME_PREFIX}SG-public"
  }
}

# ================================================= Security Group Rule (Public) =================================================
resource "aws_security_group_rule" "sg_public__ingress_rules" {
  count = length(var.SG_INGRESS_RULES__PUBLIC)

  type  = "ingress"
  security_group_id = aws_security_group.sg_public.id
  from_port         = var.SG_INGRESS_RULES__PUBLIC[count.index].from_port
  to_port           = var.SG_INGRESS_RULES__PUBLIC[count.index].to_port
  protocol          = var.SG_INGRESS_RULES__PUBLIC[count.index].protocol
  cidr_blocks       = (var.SG_INGRESS_RULES__PUBLIC[count.index].cidr_block == null) ? null:[var.SG_INGRESS_RULES__PUBLIC[count.index].cidr_block]
  source_security_group_id = (var.SG_INGRESS_RULES__PUBLIC[count.index].cidr_block == null) ? aws_security_group.sg_load_balancer.id : null
}

# ================================================= Security Group (Private) =================================================
resource "aws_security_group" "sg_private" {
  name        = "${var.TAG_NAME_PREFIX}SG-private"
  description = "Allow SSH"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "SSH from public security group"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups = [aws_security_group.sg_public.id]
  }

  ingress {
    description      = "MYSQL from public security group"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups = [aws_security_group.sg_public.id]
  }

   egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.TAG_NAME_PREFIX}SG-private"
  }
}

# ================================================= Nat Gateway =================================================
resource "aws_nat_gateway" "nat_gateway" {
  connectivity_type = "public"
  allocation_id = aws_eip.eip.id
  subnet_id         = aws_subnet.subnets_public[0].id

  depends_on = [
    aws_internet_gateway.igw
  ]

  tags = {
    Name = "${var.TAG_NAME_PREFIX}NAT-gateway"
  }
}

# ================================================= Elastic IP =================================================
resource "aws_eip" "eip" {
  vpc      = true
  tags = {
    Name = "${var.TAG_NAME_PREFIX}EIP"
  }
}