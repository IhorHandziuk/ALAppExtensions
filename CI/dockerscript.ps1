#Download Nuget
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$sourceNugetExe = "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"
$targetNugetExe = ".\nuget.exe"
Remove-Item .\Tools -Force -Recurse -ErrorAction Ignore
Invoke-WebRequest $sourceNugetExe -OutFile $targetNugetExe
Set-Alias nuget $targetNugetExe -Scope Global -Verbose

#Unzip vsix file
cp .\Run\ALLanguage.vsix .\Run\ALLanguage.zip
Expand-Archive .\Run\ALLanguage.zip

$alcPath = 'C:\ALLanguage\Extension\bin\alc.exe'

$CodeCopPath = 'C:\ALLanguage\Extension\bin\Analyzers\Microsoft.Dynamics.Nav.CodeCop.dll'
$AppSourceCop = 'C:\ALLanguage\Extension\bin\Analyzers\Microsoft.Dynamics.Nav.AppSourceCop.dll'
$PTECop = 'C:\ALLanguage\Extension\bin\Analyzers\Microsoft.Dynamics.Nav.PerTenantExtensionCop.dll'
$UICop = 'C:\ALLanguage\Extension\bin\Analyzers\Microsoft.Dynamics.Nav.UICop.dll'

$NavManagementModule = 'C:\Program Files\Microsoft Dynamics NAV\170\Service\Microsoft.Dynamics.Nav.Management.psm1'
$NavAppsManagementModule = 'C:\Program Files\Microsoft Dynamics NAV\170\Service\microsoft.dynamics.nav.apps.management.psd1'
$NavAppToolsModule = 'C:\Program Files\Microsoft Dynamics NAV\170\Service\microsoft.dynamics.nav.apps.tools.psd1'

Import-Module $NavAppToolsModule
Import-Module $NavAppsManagementModule
Import-Module $NavManagementModule

nuget install NET_Framework_48_TargetingPack -O C:\Packages -NoCache -Framework net48 -ConfigFile config
nuget install System.Management.Automation -O C:\Packages -Framework net48 -NoCache

$params = '-assemblyprobingpaths:"C:\Packages;C:\Program Files\Microsoft Dynamics NAV\170\Service" '
$params += '-a:"C:\ALLanguage\Extension\bin\Analyzers\Microsoft.Dynamics.Nav.CodeCop.dll" '
#$params += '-a:"C:\ALLanguage\Extension\bin\Analyzers\Microsoft.Dynamics.Nav.AppSourceCop.dll" '
#$params += '-a:"C:\ALLanguage\Extension\bin\Analyzers\Microsoft.Dynamics.Nav.PerTenantExtensionCop.dll" '
$params += '-a:"C:\ALLanguage\Extension\bin\Analyzers\Microsoft.Dynamics.Nav.UICop.dll" '
$params += '-packageCachePath:"C:\Program Files\Microsoft Dynamics NAV\170\AL Development Environment" '
$params += '-project:"C:\ALAppExtensions\Modules\System"'

$proc = Start-Process -FilePath $alcPath  -ArgumentList $params -NoNewWindow -Wait -PassThru
if ($proc.ExitCode)
{
   throw "$alc $($params | % { $_ }) failed with exit code $($proc.ExitCode)"
}
