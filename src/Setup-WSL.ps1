###########################################################################################
#   Function to setup WSL on computer
#       script is made for x64 systems
#       to run it on ARM64 see:
#       https://docs.microsoft.com/en-us/windows/wsl/install-win10#manual-installation-steps
###########################################################################################
#   Example:
#       Setup-WSL
###########################################################################################


function Setup-WSL()
{
    param(
        [parameter(Mandatory=$false, Position=0)][string] $startPoint = "begin",
        [parameter(Mandatory=$false, Position=1)][string] $restoreScript
    )

    BEGIN
    {
        $thisScriptPath = $script:MyInvocation.MyCommand.Path

        if($restoreScript -eq "")
        {
            Write-Host "TAK!!!"
            $restoreScript = $thisScriptPath
        }
    }

    PROCESS
    {
        
        if($startPoint -eq "begin")
        {
            dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

            $ComputerInfo =  Get-ComputerInfo
            $WindowsVersion = $ComputerInfo.WindowsVersion
            $WindowsBuild = $ComputerInfo.WindowsBuildLabEx

            if($WindowsVersion -lt 1903 -or $WindowsBuild -lt 18362)
            {
                Write-Warning "Windows will be rebooted after update."
                Write-Warning "Installation will be resume automatically..."

                Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
                Install-Module PSWindowsUpdate -Force
                Get-WindowsUpdate
                Install-WindowsUpdate -AcceptAll -Install | Out-File "c:\logs\$(get-date -f yyyy-MM-dd--HH-mm)-WindowsUpdate.log" -force

                $runOnceReg = "HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
                $restoreCmd = "Powershell $restoreScript 'afterWinUpdate_WSL'"
                New-ItemProperty $runOnceReg SetupWSLContinue -propertytype String -value $restoreCmd

                Restart-Computer
            }
            $startPoint = "afterWinUpdate_WSL"
        }
        
        if($startPoint -eq "afterWinUpdate_WSL")
        {
            Write-Warning "Windows will be rebooted now."
            Write-Warning "Installation will be resume automatically..."

            dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

            $runOnceReg = "HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
            $restoreCmd = "Powershell $restoreScript 'afterVMEN_WSL'"
            New-ItemProperty $runOnceReg SetupWSLContinue -propertytype String -value $restoreCmd

            Restart-Computer
        }

        if($startPoint -eq "afterVMEN_WSL")
        {
            $url = "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi"
            $outFile = "C:\Users\ppisk\Downloads\wsl_update_x64.msi"
            curl.exe -L -o $outFile $url

            Start-Process $outFile -ArgumentList '/quiet' -Wait

            wsl --set-default-version 2
            
            $url = "https://aka.ms/wslubuntu2004"
            $outFile = "C:\Users\ppisk\Downloads\ubuntu-2004.appx"
            curl.exe -L -o $outFile $url

            Add-AppxPackage $outFile
        }
    }

    END{}
}
