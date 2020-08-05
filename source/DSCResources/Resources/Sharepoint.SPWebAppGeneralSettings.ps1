# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

$rules = Select-Rule -Type SharePointSPWebAppGeneralSettingsRule -RuleList $stig.RuleList

# change this variable name to something better
$sb = New-Object -TypeName System.Text.StringBuilder
[void] $sb.AppendLine("SPWebAppGeneralSettings {0}`n{`n`tWebAppUrl = $WebAppUrl")

foreach ($rule in $rules)
{
    if ($vulnIDs)
    {
        $vulnIDs += ' ' + $rule.ID
    }
    else
    {
        $vulnIDs = $rule.ID
    }

    [void] $sb.AppendLine("$($rule.PropertyName) = $($rule.PropertyValue)")
}

$blockTitle = "[$($vulnIDs)]"
SPWebAppGeneralSettings $blockTitle
{
    WebAppUrl                           = "$WebAppUrl"
    AllowOnlineWebPartCatalog           = $AllowOnlineWebPartCatalog
    BrowserFileHandling                 = $BrowserFileHandling
    SecurityValidationTimeOutMinutes    = $SecurityValidationTimeOutMinutes
    SecurityValidation                  = $SecurityValidation    
    PsDscRunAsCredential                = $SetupAccount
}

[void] $sb.AppendLine('}')
$scriptblockString = $sb.ToString() -f $blockTitle
$scriptblock = [scriptblock]::Create($scriptblockString)
$scriptblock.Invoke()