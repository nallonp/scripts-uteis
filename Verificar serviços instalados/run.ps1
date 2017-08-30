##################################################
# AUTOR: NALLON PAULUZZI
# CONTATO: nallonpauluzzi@hotmail.com
# 
# SCRIPT PARA VERIFICAR SE CERTOS SERVIÇOS ESTÃO
# SENDO EXECUTADOS EM UM PC REMOTO.
##################################################
# CONFIGURÁVEL
##################################################
$ipListPath = "C:\temp\computadores.txt" # caminho da lista de ips
$servicesListPath = "C:\temp\servicos.txt" # serviços a serem verificados
$exportaRelatorio = $true # exportar relatório. Caso verdadeiro, necessário informar o caminho na variável $reportPath
$reportPath = "C:\temp\relatorio.csv" # caminho para salvar o relatório
##################################################
# NÃO MODIFICAR DAQUI PRA BAIXO
##################################################
[System.Collections.ArrayList]$ips = Get-Content $ipListPath
[System.Collections.ArrayList]$offline = @()
$servicos = Get-Content $servicesListPath
foreach($ip in $ips) {
    if (!(Test-Connection -ComputerName $ip -Count 1 -Quiet)) {
        if(!($offline.Contains($ip))){
            [void]$offline.Add($ip)
        }
    }
}
if($offline.Count) {
    Write-Host "Quantidade de máquinas desligadas: "$offline.Count
    Write-Host $offline
    foreach($o in $offline) {
        while($ips.Contains($o)){
            $ips.Remove($o)
        }
    }
}
$relatorio = Get-Service -ComputerName $ips -Include $servicos 
$relatorio | Format-Table -Property MachineName, Name, DisplayName, Status  -auto 
if($exportaRelatorio){
    $relatorio | Select-Object MachineName, Name, DisplayName, Status | Export-Csv $reportPath -Encoding UTF8
}
$ips.Clear()
$offline.Clear()