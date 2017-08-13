# Create security groups, internet gateway, nat gatway, routing.

$vpcId = 'vpc-b47ce2dd'
$sgNameRDP = 'London-RDP'

New-EC2SecurityGroup -GroupName $sgNameRDP -Description "my security group" -VpcId $vpcId

$sgRDP = Get-EC2SecurityGroup | Where-Object -FilterScript {$_.GroupName -eq $sgNameRDP}


$rdp = @{ IpProtocol="tcp"; FromPort="3389"; ToPort="3389"; IpRanges="0.0.0.0/0" }
Grant-EC2SecurityGroupIngress -GroupId $sgRDP.GroupId -IpPermission $rdp

$sgNamePrivate = "London-Private-sg"
$descriptionPrivate = "Private security group, allowing traffic only from other security groups"

New-EC2SecurityGroup -GroupName $sgNamePrivate -Description $descriptionPrivate -VpcId $vpcId

$ug = New-Object Amazon.EC2.Model.UserIdGroupPair
$ug.GroupId = $sgRDP.GroupId


$sg = Get-EC2SecurityGroup | Where-Object -FilterScript {$_.GroupName -eq $sgNamePrivate}

$rdpSg = @{ IpProtocol="tcp"; FromPort="3389"; ToPort="3389"; UserIdGroupPairs= $ug }
Grant-EC2SecurityGroupIngress -GroupId $sg.GroupId -IpPermission $rdpSg


# internet gateway
$igw = New-EC2InternetGateway | Add-EC2InternetGateway -VpcId $vpcId

# nat gateway
# 1. create eip
$eip = New-EC2Address 
# 2. create nat gateway
$ngw = New-EC2NatGateway -AllocationId $eip.AllocationId -SubnetId subnet-0a3cb271 

# route tables
# public
$publicRouteTable = New-EC2RouteTable -VpcId vpc-b47ce2dd
$publicRouteTag = New-MDEC2Tag -key 'Name' -value 'public-route'
New-EC2Tag -Resource rtb-cfb3dca6 -Tag $publicRouteTag

# private
$privateRouteTable= New-EC2RouteTable -VpcId vpc-b47ce2dd
$privRouteTag = New-MDEC2Tag -key 'Name' -value 'private-route'
New-EC2Tag -Resource $privateRouteTable.RouteTableId -Tag $privRouteTag

# public route to igw
New-EC2Route -RouteTableId 	$privateRouteTable.RouteTableId -GatewayId $igw.InternetGatewayId -DestinationCidrBlock 0.0.0.0/0

# privte route to nat
New-EC2Route -RouteTableId $publicRouteTable.RouteTableId -NatGatewayId $ngw.NatGatewayId -DestinationCidrBlock 0.0.0.0/0