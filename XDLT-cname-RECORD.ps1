param
(
  [Parameter(Mandatory=$True)]
   [alias("hostrec")]
   [string]$DnsHostRec = $(read-host -Prompt "Enter the Record to Delete")
  
  
 )

$ZoneName = "GIANTTIGER.COM"
$xrecdata=@()
# Get list of Domain Controllers
(Get-ADDomainController -Filter *).Name | ForEach-Object {
$NodeDNS = $null
$NodeDNS = Get-DnsServerResourceRecord -ZoneName $ZoneName -ComputerName $_  -RRType cname -name $DnsHostRec -ErrorAction SilentlyContinue
if($NodeDNS -eq $null){
    Write-Host "No DNS record found"
} else {
    
    $xrecdata=$NodeDNS.recordData
    Remove-DnsServerResourceRecord -ZoneName $ZoneName -ComputerName $_ -RRType "cname" -recordData $xrecdata.HostNameAlias   -name $DnsHostRec -Force
    if($?)
{
    write-host "Record $DnsHostRec successfully deleted from server:$_"
    }
}


}

 Get-DnsServerResourceRecord -ZoneName gianttiger.com -RRType cname -Name honas01