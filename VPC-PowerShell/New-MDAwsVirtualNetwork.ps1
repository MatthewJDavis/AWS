# Create a VPC and resources for a full network

$addressSpace = "10.0.0.0/16"
$region = 'eu-west-2'
$vpcName = "LondonVPC"

#subnets
$subName1 = ''
$subName2 = ''

Set-DefaultAWSRegion -Region $region

# create name tag for VPC

function New-MDEC2Tag ($key, $value) {
  $tag = New-Object -TypeName Amazon.EC2.Model.Tag
  $tag.Key = $key 
  $tag.Value = $value

  return $tag
}

$vpc = New-EC2Vpc -CidrBlock $addressSpace 

$vpcTag = New-MDEC2Tag -key 'Name' -value $vpcName

New-EC2Tag -Resource $vpc.VpcId -Tag $vpcTag

# create subnets public and private in each availability zone

$sub1 = New-EC2Subnet -CidrBlock 10.0.1.0/24 -AvailabilityZone eu-west-2a -VpcId $vpc.VpcId

$sub1Tag = New-MDEC2Tag -key "Name" -value "eu-west-2a-public"

New-EC2Tag -Resource $sub1.SubnetId -Tag $sub1Tag

$sub1 = New-EC2Subnet -CidrBlock 10.0.3.0/24 -AvailabilityZone eu-west-2b -VpcId $vpc.VpcId

$sub1Tag = New-MDEC2Tag -key "Name" -value "eu-west-2b-private"

New-EC2Tag -Resource $sub1.SubnetId -Tag $sub1Tag



$sub2 = New-EC2Subnet -CidrBlock 10.0.2.0/24 -AvailabilityZone eu-west-2b -VpcId $vpc.VpcId

$sub2Tag = New-MDEC2Tag -key "Name" -value "eu-west-2b-public"

New-EC2Tag -Resource $sub2.SubnetId -Tag $sub2Tag

$sub2 = New-EC2Subnet -CidrBlock 10.0.4.0/24 -AvailabilityZone eu-west-2b -VpcId $vpc.VpcId

$sub2Tag = New-MDEC2Tag -key "Name" -value "eu-west-2b-private"

New-EC2Tag -Resource $sub2.SubnetId -Tag $sub2Tag





