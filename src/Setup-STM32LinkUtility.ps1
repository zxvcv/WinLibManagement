###########################################################################################
#   Function to setup STM32 Link Utility on computer
#       
###########################################################################################
#   Example:
#       Setup-STM32LinkUtility
###########################################################################################


function Setup-STM32LinkUtility()
{
    param()

    BEGIN
    {
        $thisScriptPath = $script:MyInvocation.MyCommand.Path
    }

    PROCESS
    {
        $url = "https://www.st.com/content/ccc/resource/technical/software/utility/51/c4/6a/b0/e2/0f/47/e5/stsw-link004.zip/files/stsw-link004.zip/jcr:content/translations/en.stsw-link004.zip"
        $outFile = "C:\Users\ppisk\Downloads\en.stsw-link004.zip"
        curl.exe -L -o $outFile $url

        $dest = "C:\Users\ppisk\Downloads\en.stsw-link004"
        Expand-Archive -LiteralPath $outFile -DestinationPath $dest

        $exeFile = $dest + "\STM32 ST-LINK Utility v4.6.0\setup.exe"
        Start-Process $exeFile -ArgumentList '/S' -Wait

        # Clenup
        #Remove-Item $outFile
        #Remove-Item $dest -Recurse
    }

    END{}
}
