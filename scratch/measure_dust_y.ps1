Add-Type -AssemblyName System.Drawing

$dust = [System.Drawing.Bitmap]::FromFile((Resolve-Path "assets/images/sfx/Gemini_Generated_Image_7wy6zr7wy6zr7wy6.png").Path)
Write-Host "Scanning horizontal black lines for Box 1 (X=300):"
for ($y = 400; $y -lt 1200; $y++) {
    $c = $dust.GetPixel(300, $y)
    if ($c.R -lt 10 -and $c.G -lt 10 -and $c.B -lt 10) {
        Write-Host "Y=$y is black"
    }
}
$dust.Dispose()
