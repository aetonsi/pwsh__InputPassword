Param(
    [Parameter(Mandatory = $false)] [string] $Prompt = "Enter password",
    [Parameter(Mandatory = $false)] [switch] $newWindow
)


###################################


if ($newWindow) {
    Import-Module -Force "$PSScriptRoot\StartProcessWaitRedirectToStream\StartProcessWaitRedirectToStream.psm1"
    $__FILE__ = $MyInvocation.MyCommand.path
    $escaped__FILE__ = "`"$__FILE__`""
    $escapedPrompt = "`"$Prompt`""
    $output = Invoke-StartProcessWaitRedirectToStream -FilePath powershell -ArgumentList @("-File", $escaped__FILE__ , "-Prompt", $escapedPrompt) -RedirectStandardOutputToStream 1
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
