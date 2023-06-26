
function Read-SecureHost(
    [Parameter(Mandatory = $false)] [string] $Prompt = 'Enter_password',
    [Parameter(Mandatory = $false)] [switch] $NewWindow
) {
    if ($NewWindow) {
        Import-Module -Scope Local -Force "$PSScriptRoot\pwsh__StartProcessWaitRedirectToStream\StartProcessWaitRedirectToStream.psm1"
        Import-Module -Scope Local -Force "$PSScriptRoot\pwsh__Process\Process.psm1"
        Import-Module -Scope Local -Force "$PSScriptRoot\pwsh__String\String.psm1"
        $IsWindowsPowershell = $PSVersionTable.PSEdition -ieq 'Desktop'
        $exe = if ($IsWindowsPowershell) { 'powershell' } else { 'pwsh' }
        $arglist = @(
            '-NoProfile',
            '-Command',
            'Import-Module',
            $PSCommandPath,
            ';',
            'Read-SecureHost',
            '-Prompt',
            ($Prompt | ConvertTo-EscapedCommandLine -ForPowershell | Get-QuotedString)
        )
        $output = Invoke-StartProcessWaitRedirectToStream -FilePath $exe -ArgumentList $arglist `
            -RedirectStandardOutputToStream 1 `
            -RedirectStandardErrorToStream 2
    } else {
        try {
            # use -maskinput if available
            $output = Read-Host -MaskInput -Prompt $Prompt
        } catch {
            $securePwd = Read-Host -AsSecureString -Prompt $Prompt
            $output = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePwd))
        }
    }

    return $output
}



Export-ModuleMember -Function *-*