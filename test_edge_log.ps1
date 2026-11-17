$edgePath = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
$tempHtml = "C:\temp\test_portfolio.html"
New-Item -ItemType Directory -Path "C:\temp" -Force | Out-Null
Copy-Item "index.html" $tempHtml -Force

$logPath = "C:\temp\edge_console.log"
$tempUserDir = "C:\temp\edge_profile"
Remove-Item $logPath -ErrorAction SilentlyContinue

$argsList = @(
    "--headless=new",
    "--user-data-dir=$tempUserDir",
    "--enable-logging=stderr",
    "--v=1",
    $tempHtml
)

$p = Start-Process -FilePath $edgePath -ArgumentList $argsList -NoNewWindow -PassThru -RedirectStandardError $logPath
Start-Sleep -Seconds 5
if (!$p.HasExited) { Stop-Process -Id $p.Id -Force }

if (Test-Path $logPath) {
    Get-Content $logPath
}
