data "aws_availability_zones" "available" {
}

data "aws_availability_zones" "available_replica" {
  provider = aws.replica_region
}

resource "aws_vpc" "main" {
  cidr_block = "10.10.0.0/16"
  tags = {
    Environment = var.env
    Name        = "${var.env}-vpc"
  }
}

resource "aws_vpc" "main_replica" {
  cidr_block = "10.10.0.0/16"
  provider   = aws.replica_region
  tags = {
    Environment = var.env
    Name        = "${var.env}-vpc"
  }
}

resource "aws_subnet" "private" {
  count             = var.az_count
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index) # create a /24 subnet within the /16 CIDR block in the VPC
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.main.id
  tags = {
    Environment = var.env
    Name        = "${var.env}-private-subnet-${data.aws_availability_zones.available.names[count.index]}"
  }
}

resource "aws_subnet" "private_replica" {
  provider          = aws.replica_region
  count             = var.az_count
  cidr_block        = cidrsubnet(aws_vpc.main_replica.cidr_block, 8, count.index) # create a /24 subnet within the /16 CIDR block in the VPC
  availability_zone = data.aws_availability_zones.available_replica.names[count.index]
  vpc_id            = aws_vpc.main_replica.id
  tags = {
    Environment = var.env
    Name        = "${var.env}-private-subnet-${data.aws_availability_zones.available_replica.names[count.index]}"
    Type        = "Replica"
  }
}

resource "aws_subnet" "public" {
  count                   = var.az_count
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, var.az_count + count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true
  tags = {
    Environment = var.env
    Name        = "${var.env}-public-subnet-${data.aws_availability_zones.available.names[count.index]}"
  }
}
resource "aws_subnet" "public_replica" {
  count                   = var.az_count
  provider                = aws.replica_region
  cidr_block              = cidrsubnet(aws_vpc.main_replica.cidr_block, 8, var.az_count + count.index)
  availability_zone       = data.aws_availability_zones.available_replica.names[count.index]
  vpc_id                  = aws_vpc.main_replica.id
  map_public_ip_on_launch = true
  tags = {
    Environment = var.env
    Name        = "${var.env}-public-subnet-${data.aws_availability_zones.available_replica.names[count.index]}"
    Type        = "Replica"
  }
}

resource "aws_internet_gateway" "aws_api_igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_internet_gateway" "aws_api_igw_replica" {
  vpc_id   = aws_vpc.main_replica.id
  provider = aws.replica_region
}

# Route the public subnet traffic through the Internet Gateway
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.main.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.aws_api_igw.id
}

# Route the public subnet traffic through the Internet Gateway
resource "aws_route" "internet_access_replica" {
  route_table_id         = aws_vpc.main_replica.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.aws_api_igw_replica.id
  provider               = aws.replica_region
}

# Route traffic in the private subnet through the NAT gateway
resource "aws_eip" "aws_api_eip" {
  count      = var.az_count
  vpc        = true
  depends_on = [aws_internet_gateway.aws_api_igw]
}
resource "aws_eip" "aws_api_eip_replica" {
  count      = var.az_count
  vpc        = true
  depends_on = [aws_internet_gateway.aws_api_igw_replica]
  provider   = aws.replica_region
}
resource "aws_nat_gateway" "aws_api_nat" {
  count         = var.az_count
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  allocation_id = element(aws_eip.aws_api_eip.*.id, count.index)
}
resource "aws_nat_gateway" "aws_api_nat_replica" {
  count         = var.az_count
  subnet_id     = element(aws_subnet.public_replica.*.id, count.index)
  allocation_id = element(aws_eip.aws_api_eip_replica.*.id, count.index)
  provider      = aws.replica_region
}
resource "aws_route_table" "private" {
  count  = var.az_count
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.aws_api_nat.*.id, count.index)
  }
}
resource "aws_route_table" "private_replica" {
  provider = aws.replica_region
  count    = var.az_count
  vpc_id   = aws_vpc.main_replica.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.aws_api_nat_replica.*.id, count.index)
  }
}

resource "aws_route_table_association" "private" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

resource "aws_route_table_association" "private_replica" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.private_replica.*.id, count.index)
  route_table_id = element(aws_route_table.private_replica.*.id, count.index)
  provider       = aws.replica_region
}
