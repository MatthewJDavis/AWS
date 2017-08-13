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

New-EC2InternetGateway | Add-EC2InternetGateway -VpcId $vpcId


# nat gateway
#create eip
$eip = New-EC2Address 

#create nat gateway
New-EC2NatGateway -AllocationId $eip.AllocationId -SubnetId subnet-0a3cb271 

# route tables
New-EC2RouteTable

New-EC2Route