# PC Setup Script - Rename, install software via Chocolatey, and add to a domain.
# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
    $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
    Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
    Exit
    }
}
# Pulls serial from BIOS info and uses as a variable to assign a new computer name.
# WARNING: This works best on brand names like HP, Dell, etc.
$s = (gwmi win32_bios).SerialNumber
$newname = ("DMA-" + $s + "v2")
Rename-Computer -NewName ($newname)
# Install chocolatey to allow easier app install in the future
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-WebRequest https://chocolatey.org/install.ps1 -UseBasicParsing | Invoke-Expression
# Programs to install via chocolatey. More can be added later. Find more packages at https://chocolatey.org/packages/
choco install googlechrome
choco install firefox
choco install 7zip
# Add computer to the domain and reboot it for the changes to take effect. 
# COMMENTED OUT BY DEFAULT. PLEASE UNCOMMENT IF YOU WISH TO USE THIS FEATURE.
# Change ad.constoso.com and domain\adminuser to appropriate ones for your user.
# add-computer –domainname ad.contoso.com -Credential domain\adminuser -restart –force
