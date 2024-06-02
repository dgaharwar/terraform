<powershell>

# Initial checkpoint

if (!(Test-Path -Path "C:\Install\Checkpoint-0")) {
    Set-TimeZone -Id 'US Eastern Standard Time'
    Rename-Computer ${hostname}

    Get-NetAdapter -InterfaceIndex 5 | Rename-NetAdapter -NewName "${net_adapter_name}"

    Set-Content -Path "C:\Install\Checkpoint-0" -Value "1"
}

# Agent installation

if (!(Test-Path -Path "C:\Install\Checkpoint-1")) {
    Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\System -Name EnableSmartScreen -Value 0 -Force
    Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\System -Name ShellSmartScreenLevel -Value "Warn" -Force
    Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name EnableLUA -Value 0 -Force

    $dirPath="C:\Install"
    if(!(Test-Path -path $dirPath)) {New-Item -ItemType directory -Path $dirPath}
    Set-location "$dirPath"
    $outfile = $dirPath + ("\Install-OUT-" + (get-date -format "dd-MMM-yyy-hh.mm.ss")+".log" )
    $env:computername | Tee-Object -filepath $outfile -append | write-output

    Set-location "$dirPath"

    #Trellix Agent install
    "`nInstalling Trellix agent : Trellix Win Agent" | Tee-Object -filepath $outfile -append | write-output
    $trellix_installer = (Get-ChildItem $dirPath -Filter "Trellix*.exe").FullName
    Start-process -Verb runAs -NoNewWindow -FilePath $trellix_installer -ArgumentList  "/INSTALL=AGENT","/FORCEINSTALL","/keepguid","/SILENT" -Wait -PassThru

    #Tanium Agent install
    "`nInstalling Tanium agent : SetupClient.exe " | Tee-Object -filepath $outfile -append | write-output
    Start-Process -Verb runAs -NoNewWindow -FilePath ./SetupClient.exe -ArgumentList "/S" -Wait -PassThru
    Start-Sleep -s 30
    & 'C:\Program Files (x86)\Tanium\Tanium Client\TaniumClient.exe' config set ServerNameList USMAGWKFNG135.fsa.mrd

    #Encase Agent Install
    "`nInstalling Encase agent : EncaseSetup.exe" | Tee-Object -filepath $outfile -append | write-output
    Start-process -Verb runAs -NoNewWindow -FilePath ./EncaseSetup.exe -ArgumentList "-s","-c" -Wait -PassThru

    #ILMT BigFix Agent Install
    "`nInstalling ILMT agent : BigFix-BES-Client-11.0.1.104.exe" | Tee-Object -filepath $outfile -append | write-output
    C:\Temp\BigFixAgentInstallerWin\installBigFixWindows.bat -wait

    #Microsoft Edge Enterprise install
    "`nInstalling Microsoft Edge Enterprise" | Tee-Object -filepath $outfile -append | write-output
    Set-location "$dirPath"
    Start-process -Verb runAs -NoNewWindow -FilePath  ./MicrosoftEdgeEnterpriseX64.msi -ArgumentList "/quiet" -Wait -PassThru

    Set-Content -Path "C:\Install\Checkpoint-1" -Value "1"
}

if (!(Test-Path -Path "C:\Install\Checkpoint-2")) {
    Set-Content -Path "C:\Install\Checkpoint-2" -Value "1"

    #OBM - OMi Agent install
    "`nInstalling OBM agent" | Tee-Object -filepath $outfile -append | write-output
    Set-location "$dirPath\oa_media_Windows_X64"
    Start-Process -Verb runAs -NoNewWindow cscript.exe -ArgumentList "$dirPath\oa_media_Windows_X64\oainstall.vbs","-i","-a","-srv usmaglgfng044.fsa.mrd","-verbose" -Wait -PassThru
}

if (!(Test-Path -Path "C:\Install\Checkpoint-3")) {

    $drives_json = @"
    ${drive_configuration}
"@
    
    $drives = ConvertFrom-Json $drives_json

    for ($i = 0; $i -lt $drives.Count; $i++) {
        $disk_number = $i + 1
        $disk = Get-Disk | Where-Object -Property "Number" -eq $disk_number

        if ($disk.Number -ne "0") {
            Initialize-Disk -Number $disk_number -PartitionStyle GPT -Confirm
            New-Partition -DiskNumber $disk_number -UseMaximumSize -DriveLetter $drives[$i].drive_letter | Format-Volume -FileSystem NTFS -NewFileSystemLabel $drives[$i].drive_name
        }
    }
    Set-Content -Path "C:\Install\Checkpoint-3" -Value "1"
}

if (!(Test-Path -Path "C:\Install\Checkpoint-4")) {
    Set-Content -Path "C:\Install\Checkpoint-4" -Value "1"

    Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\System -Name ShellSmartScreenLevel -Value "Warn" -Force
    Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\System -Name EnableSmartScreen -Value 1 -Force
    Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name EnableLUA -Value 1 -Force
    
    Restart-Computer -Confirm -Force
}

if (!(Test-Path -Path "C:\Install\Checkpoint-5")) {

    Set-Content -Path "C:\Install\Checkpoint-5" -Value "1"

    $smsecret = Get-SECSecretValue -SecretId "${domain_credential_secret_id}"

    $user = ($smsecret.SecretString | ConvertFrom-Json).username
    $pass = ConvertTo-SecureString -String ($smsecret.SecretString | ConvertFrom-Json).password -AsPlainText -Force
    $cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $pass
    
    Add-Computer -OUPath "OU=${ad_environment},OU=${ad_availability_zone},OU=2022-Servers,OU=AWS,DC=fsa,DC=mrd" -ComputerName $env:COMPUTERNAME -DomainName "${ad_domain_name}" -DomainCredential $cred -Restart -Confirm
}

</powershell>
<persist>true</persist>