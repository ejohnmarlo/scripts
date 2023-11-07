Write-Host "Changing admin password..."
net user admin ++adminzbook2023!!

Write-Host "Add administrator permission..."
net localgroup administrators admin /add

Write-Host "Creating user student..."
net user student studentpass /add

Write-Host "Add administrator permission..."
net localgroup administrators student /add

Write-Host "Changing student password..."
net user student studentpass

Write-Host "Disable popup on install..."
Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0

Write-Host "Disable sleep mode..."
powercfg -change -standby-timeout-ac 0

#Write-Host "Changing directory..."
#cd ~

Write-Host "Downloading WiFi Profile..."
Invoke-WebRequest -Uri https://raw.githubusercontent.com/ejohnmarlo/dump/main/scripts/wifi_profile.xml -OutFile ~\wifi_profile.xml -UseBasicParsing

Write-Host "Connecting to WiFi..."
netsh wlan delete profile name="Computing Laboratory"
netsh wlan add profile filename=C:\Users\admin\wifi_profile.xml
netsh wlan connect name="Computing Laboratory"

#Write-Host "Downloading PGina to C://..."

Write-Host "Installing Chocolatey..."
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

Write-Host "Enabling remembered argument for Upgrades on Chocolatey..."
choco feature enable -n='useRememberedArgumentsForUpgrades'

Write-Host "Allow Global confirmation when installing and updating packages..."
choco feature enable -n=allowGlobalConfirmation

#Write-Host "Installing OpenSSH..."
#winget install "openssh beta" --source=winget --scope=machine
#choco uninstall openssh
#choco install openssh --params "/ALLUSERS"

Write-Host "Installing OpenSSH-server"
Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH*'
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'

New-NetFirewallRule -DisplayName 'Allow SSH' -Direction Inbound -Action Allow -Protocol TCP -LocalPort 22
Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH*'
#Start-Process 'C:\pGinaSetup-3.9.9.12.exe' -Argument '/S /D=C:\Program Files\pGina.fork'
