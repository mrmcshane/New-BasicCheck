function New-BasicCheck{
param($URI)

$ports = @()
$ports += "21   "
$ports += "22   "
$ports += "80   "
$ports += "443  "
$ports += "3389 "

Write-Host ""

# ping

$ping = (New-Object System.Net.NetworkInformation.Ping).SendPingAsync("$URI")
$ErrorActionPreference = 'SilentlyContinue'

if($ping.Result.Status -eq "Success") 
{ 
Write-Host "Ping $URI : " -nonewline
Write-Host -ForeGroundColor Green $ping.Result.Status
}
else 
{
Write-Host "Port $URI : " -nonewline
Write-Host -ForeGroundColor Red $ping.Result.Status
}

Write-Host ""

# ip lookup

$ip = ""
$ip = [System.Net.Dns]::GetHostAddresses($URI)
if($ip) 
{ 
Write-Host "IP for $URI : " -nonewline
Write-Host -ForeGroundColor Green $ip.IPAddressToString
}
else 
{
Write-Host "IP for $URI : " -nonewline
Write-Host -ForeGroundColor Red "No IP Listed for $URI"
}

Write-Host ""


# telnet

function f_red{
Param($port)
Write-Host "Port $port : " -nonewline
Write-Host -ForeGroundColor Red "Closed" 
}

function f_green{
Param($port)
Write-Host "Port $port : " -nonewline
Write-Host -ForeGroundColor Green "Open"
}

foreach($port in $ports){

    $socket = New-Object Net.Sockets.TcpClient
    $ErrorActionPreference = 'SilentlyContinue'
    $socket.Connect($URI,$port)
    if ($socket.Connected) { f_green -port $port }
    else { f_red -port $port }
    }

}
