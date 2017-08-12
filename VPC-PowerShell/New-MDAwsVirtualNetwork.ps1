# Create a VPC and resources for a full network

$addressSpace = "10.0.0.0/16"
$region = 'eu-west-2'
$vpcName = "LondonVPC"

#subnets
$subName1 = ''
$subName2 = ''

Set-DefaultAWSRegion -Region $region

#region Funtions
function New-MDEC2Tag ($key, $value) {
  $tag = New-Object -TypeName Amazon.EC2.Model.Tag
  $tag.Key = $key 
  $tag.Value = $value

  return $tag
}

function New-MDEC2Vpc ($CiderBlock, $tag) {
  $vpc = New-EC2Vpc -CidrBlock $addressSpace   
  New-EC2Tag -Resource $vpc.VpcId -Tag $vpcTag
  return $vpc
}

function New-MDEC2Subnet ($CidrBlock, $AvailabilityZone, $VpcId, $Tag) {
  $subnet = New-EC2Subnet -CidrBlock $CidrBlock -AvailabilityZone $AvailabilityZone -VpcId $VpcId
  New-EC2Tag -Resource $subnet.SubnetId -Tag $Tag
}

#endregion

#create the VPC
$vpcTag = New-MDEC2Tag -key 'Name' -value $vpcName
$vpc = New-MDEC2Vpc -CiderBlock $addressSpace -tag $vpcTag


# create subnets public and private in each availability zone



# create public subnets
$sub1Tag = New-MDEC2Tag -key "Name" -value "eu-west-2a-public"
New-MDEC2Subnet -CidrBlock 10.0.1.0/24 -AvailabilityZone eu-west-2a -VpcId $vpc.VpcId -Tag $sub1Tag

$sub2Tag = New-MDEC2Tag -key "Name" -value "eu-west-2b-public"
New-MDEC2Subnet -CidrBlock 10.0.2.0/24 -AvailabilityZone eu-west-2b -VpcId $vpc.VpcId -Tag $sub2Tag

# create private subnets

$sub3Tag = New-MDEC2Tag -key "Name" -value "eu-west-2a-private"
New-MDEC2Subnet -CidrBlock 10.0.3.0/24 -AvailabilityZone eu-west-2a -VpcId $vpc.VpcId -Tag $sub3Tag

$sub4Tag = New-MDEC2Tag -key "Name" -value "eu-west-2b-private"
New-MDEC2Subnet -CidrBlock 10.0.4.0/24 -AvailabilityZone eu-west-2b -VpcId $vpc.VpcId -Tag $sub4Tag

# create 









