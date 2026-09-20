Add-Type -AssemblyName System.Drawing

# 1. Inspect Dust boxes
$dust = [System.Drawing.Bitmap]::FromFile((Resolve-Path "assets/images/sfx/Gemini_Generated_Image_7wy6zr7wy6zr7wy6.png").Path)

# The 4 boxes in dust: let's scan for black vertical lines (R < 10) around Y=700
Write-Host "--- Scanning Dust vertical box borders around Y=700 ---"
$borders = @()
for ($x = 50; $x -lt 2750; $x++) {
    $c = $dust.GetPixel($x, 700)
    if ($c.R -lt 10 -and $c.G -lt 10 -and $c.B -lt 10) {
        $borders += $x
    }
}
Write-Host "Black pixels at Y=700:" ($borders -join ", ")
$dust.Dispose()

# 2. Inspect Hit Sparks 5 peaks
$sparks = [System.Drawing.Bitmap]::FromFile((Resolve-Path "assets/images/sfx/Gemini_Generated_Image_nilnalnilnalniln.png").Path)
Write-Host "--- Scanning Sparks column densities ---"
$densities = @()
for ($x = 150; $x -lt 2650; $x += 20) {
    $count = 0
    for ($y = 500; $y -lt 1050; $y += 10) {
        $c = $sparks.GetPixel($x, $y)
        $diff = [Math]::Abs($c.R - $c.B)
        if ($diff -gt 25 -or ($c.R -gt 240 -and $c.G -gt 240 -and $c.B -gt 240)) {
            $count++
        }
    }
    if ($count -gt 0) {
        # Active column
    }
}
$sparks.Dispose()
