Param(
    [Parameter(Mandatory = $false)] [string] $Prompt = "Enter password",
    [Parameter(Mandatory = $false)] [switch] $newWindow
)


###################################


if ($newWindow -and !$inNewWindow) {
    Import-Module -Force "$PSScriptRoot\StartProcessWaitRedirectToStream\StartProcessWaitRedirectToStream.psm1"
    $output = Invoke-StartProcessWaitRedirectToStream -FilePath powershell -ArgumentList @("-File", $MyInvocation.MyCommand.path, "-Prompt", $Prompt) -RedirectStandardOutputToStream 1
}
else {
    try {
        # use -maskinput if available
        $output = Read-Host -MaskInput -Prompt $Prompt
    }
    catch {
        $securePwd = Read-Host -AsSecureString -Prompt $Prompt
        $output = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePwd))
    }
}

$output
