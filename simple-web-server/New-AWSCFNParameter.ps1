function New-MDCFNParameter (
  # Parameter help description
  [Parameter(Mandatory = $true)]
  [String]
  $Key,
  [Parameter(Mandatory = $true)]
  [String]
  $Value
) {
  
  $param = New-Object -TypeName Amazon.CloudFormation.Model.Parameter
  $param.ParameterKey = $Key
  $param.ParameterValue = $Value
  
  return $param
}

$instanceType = New-MDCFNParameter -Key 'InstanceType' -Value 't2.micro'
$keyName = New-MDCFNParameter -Key 'KeyName' -Value ''
$subnet = New-MDCFNParameter -Key 'Subnet' -Value 'subnet-06817b5d'
$vpc = New-MDCFNParameter -Key 'VPC' -Value 'vpc-b79217d0'
$name = New-MDCFNParameter -Key 'Name' -Value 'simple-web-servers'

