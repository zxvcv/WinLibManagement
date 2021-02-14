###########################################################################################
#   Function to setup STM32 Qube on computer
#       STM32 Qube User manual:
#       https://www.st.com/content/ccc/resource/technical/document/user_manual/10/c5/1a/43/3a/70/43/7d/DM00104712.pdf/files/DM00104712.pdf/jcr:content/translations/en.DM00104712.pdf
#       require Java to be installed before
###########################################################################################
#   Example:
#       Setup-STM32Qube
###########################################################################################


function Setup-STM32Qube()
{
    param()

    BEGIN{}

    PROCESS
    {
        $url = "https://www.st.com/content/ccc/resource/technical/software/sw_development_suite/group0/0b/05/f0/25/c7/2b/42/9d/stm32cubemx_v6-1-1/files/stm32cubemx_v6-1-1.zip/jcr:content/translations/en.stm32cubemx_v6-1-1.zip"
        $outFile = "C:\Users\ppisk\Downloads\en.stm32cubemx_v6-1-1.zip"
        curl.exe -L -o $outFile $url

        $dest = "C:\Users\ppisk\Downloads\en.stm32cubemx_v6-1-1"
        Expand-Archive -LiteralPath $outFile -DestinationPath $dest

        $exeFile = $dest + "\SetupSTM32CubeMX-6.1.1.exe"
        $setupCmd = "java"
        $setupArgs = " –jar $exeFile .\auto-install.xml"
        Start-Process $setupCmd -ArgumentList $setupArgs -Wait

        # Clenup
        #Remove-Item $outFile
        #Remove-Item $dest -Recurse
    }

    END{}
}
