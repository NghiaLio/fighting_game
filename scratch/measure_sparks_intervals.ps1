Add-Type -AssemblyName System.Drawing

$sparks = [System.Drawing.Bitmap]::FromFile((Resolve-Path "assets/images/sfx/Gemini_Generated_Image_nilnalnilnalniln.png").Path)

# Background color indices in hit sparks:
# [0..9], [11..13] are grey checkerboard (R ≈ G ≈ B around 65..122)
# Any spark pixel has (diff > 15) or (R > 230 and G > 200)
$sparkPixelsX = @()
for ($x = 100; $x -lt 2700; $x += 2) {
    $hasSpark = $false
    for ($y = 480; $y -lt 1100; $y += 4) {
        $c = $sparks.GetPixel($x, $y)
        $diff = [Math]::Abs($c.R - $c.B)
        if (($diff -gt 15 -or ($c.R -gt 240 -and $c.G -gt 240 -and $c.B -gt 240)) -and ($x -lt 2400 -or $y -lt 1200)) {
            $hasSpark = $true
            break
        }
    }
    if ($hasSpark) {
        $sparkPixelsX += $x
    }
}

# Group continuous intervals
$intervals = @()
$start = $sparkPixelsX[0]
$prev = $start
foreach ($x in $sparkPixelsX[1..($sparkPixelsX.Length-1)]) {
    if ($x - $prev -gt 40) {
        $intervals += "$start..$prev"
        $start = $x
    }
    $prev = $x
}
$intervals += "$start..$prev"

Write-Host "5 Spark horizontal intervals:"
$intervals | ForEach-Object { Write-Host $_ }
$sparks.Dispose()
