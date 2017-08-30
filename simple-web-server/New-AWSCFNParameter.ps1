function New-MDCFNParameter (
  # Helper function to create CloudFormation Parameters
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

# parameters needed for the deployment
$instanceType = New-MDCFNParameter -Key 'InstanceType' -Value 't2.micro'
$keyName = New-MDCFNParameter -Key 'KeyName' -Value ''
$subnet = New-MDCFNParameter -Key 'Subnet' -Value 'subnet-06817b5d'
$vpc = New-MDCFNParameter -Key 'VPC' -Value 'vpc-b79217d0'
$name = New-MDCFNParameter -Key 'Name' -Value 'simple-web-server'

# need to save the template content of the template to a variable (the New-CFNStack doesn't accept a file for the templatebody param)
$temp  = Get-Content .\simple-web-server.yml -Raw

# create a new cloudformation stack
New-CFNStack -StackName simple-web1 -TemplateBody $temp -Parameter @($instanceType, $keyName, $subnet, $vpc, $name)

