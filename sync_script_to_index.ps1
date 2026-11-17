$PSScriptRoot = (Get-Item -Path ".").FullName
$htmlPath = Join-Path $PSScriptRoot "index.html"
$mainJsPath = Join-Path $PSScriptRoot "main.js"

$html = [System.IO.File]::ReadAllText($htmlPath, [System.Text.Encoding]::UTF8)
$mainJs = [System.IO.File]::ReadAllText($mainJsPath, [System.Text.Encoding]::UTF8)

# Wrap mainJs cleanly inside IIFE
$embeddedScript = @"
  <script id="portfolio-main-script">
(function() {
  'use strict';

$mainJs

})();
  </script>
"@

$startTag = '<script id="portfolio-main-script">'
$endTag = '</script>'

$startPos = $html.IndexOf($startTag)
if ($startPos -ge 0) {
    $endPos = $html.IndexOf($endTag, $startPos)
    if ($endPos -ge 0) {
        $endPos += $endTag.Length
        $before = $html.Substring(0, $startPos)
        $after = $html.Substring($endPos)
        
        $newHtml = $before + $embeddedScript + $after
        
        $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
        [System.IO.File]::WriteAllText($htmlPath, $newHtml, $utf8NoBom)
        Write-Host "SUCCESS: Updated index.html embedded script from main.js!"
    } else {
        Write-Error "Could not find </script> tag after start tag"
    }
} else {
    Write-Error "Could not find <script id=""portfolio-main-script"">"
}
