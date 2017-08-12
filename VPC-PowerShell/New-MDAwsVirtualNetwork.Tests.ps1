$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"
Describe "VPC created with PowerShell" {
  Mock New-EC2Vpc -MockWith { return @{vpcId = 'myvpcId'}}
  Mock New-EC2Subnet -MockWith { return @{subNetid = 'mySubnetId'}}
  Context "Tag"{
    $tag =  New-MDEC2Tag -key "Name" -value "London"
    It "Tage has correct key" {
      $tag.key | should be  "Name" 
    } 
    It "Tag has correct value" {
      $tag.Value | should be "London"
    }
  }
  Context "Subnets" {

  }
  Context "Internet Gateway" {

  }
  Context "Security Groups" {

  }
}