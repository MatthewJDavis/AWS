# Script to create a basic AWS vault, backup plan & target resources based on tags

# Create a backup vault
$VaultName = 'demo'
$ProjectTag = @{'Project' = 'Demo' }
New-BAKBackupVault -BackupVaultName $VaultName -BackupVaultTag $ProjectTag

# Create backup policies and rules
# Lifecycle https://docs.aws.amazon.com/sdkfornet/v3/apidocs/items/Backup/TLifecycle.html

$BackupLifeCycle = New-Object -TypeName Amazon.Backup.Model.Lifecycle
$BackupLifeCycle.DeleteAfterDays = 7
# $BackupLifeCycle.MoveToColdStorageAfterDays = 0 no cold storage

# Create the backup rule object: https://docs.aws.amazon.com/sdkfornet/v3/apidocs/index.html?page=Backup/TBackupBackupRuleInput.html&tocid=Amazon_Backup_Model_BackupRuleInput
$RecoveryTags = New-Object -TypeName 'system.collections.generic.dictionary[string,string]'
$RecoveryTags.Add('created:by:aws:backup:plan', '4-AM-7-Day-Retention')

$BackupRule = New-Object -TypeName Amazon.Backup.Model.BackupRuleInput

$BackupRule.Lifecycle = $BackupLifeCycle
$BackupRule.StartWindowMinutes = 60
$BackupRule.TargetBackupVaultName = $VaultName
$BackupRule.RecoveryPointTags = $RecoveryTags
$BackupRule.RuleName = '4-AM-7-Day-Retention'
$BackupRule.ScheduleExpression = 'cron(0 4 * * ? *)' # https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html

New-BAKBackupPlan -BackupPlan_BackupPlanName '4-AM-7-Day-Retention' -BackupPlan_Rule $BackupRule -BackupPlanTag $ProjectTag



# Resource selection https://docs.aws.amazon.com/sdkfornet/v3/apidocs/index.html?page=Backup/TBackupCondition.html&tocid=Amazon_Backup_Model_Condition

$BackupSelectionName = '4AM-7-Day-Retention-Tag'
$IAMRoleARN = (Get-IAMRole -RoleName AWSBackupDefaultServiceRole).arn # using the default created role here

$BackupCondition = New-Object -TypeName Amazon.Backup.Model.Condition 
$BackupCondition.ConditionKey = 'BackupPolicy'
$BackupCondition.ConditionValue = '4AM-7-Day-Retention'
$BackupCondition.ConditionType = 'STRINGEQUALS'

New-BAKBackupSelection -BackupPlanId $BackupPlan.BackupPlanId -BackupSelection_SelectionName $BackupSelectionName -BackupSelection_ListOfTag $BackupCondition -BackupSelection_IamRoleArn $IAMRoleARN
