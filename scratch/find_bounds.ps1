Add-Type -AssemblyName System.Drawing

$img1 = [System.Drawing.Bitmap]::FromFile((Resolve-Path "assets/images/sfx/Gemini_Generated_Image_nilnalnilnalniln.png").Path)

# Background color indices in hit sparks:
# [0..9], [11..13] are pure grey background squares (R == G == B)
# Non-background is anything with (R != G) or (R > 130 and B < 220) or R == 255
$minX = 99999; $maxX = 0; $minY = 99999; $maxY = 0

for ($y = 0; $y -lt $img1.Height; $y += 4) {
    for ($x = 0; $x -lt $img1.Width; $x += 4) {
        $c = $img1.GetPixel($x, $y)
        $diff = [Math]::Abs($c.R - $c.B)
        if ($diff -gt 15 -or ($c.R -gt 240 -and $c.G -gt 240 -and $c.B -gt 240)) {
            # Spark pixel!
            # Ignore the watermark in bottom right corner (x > 2300 and y > 1200)
            if ($x -lt 2400 -or $y -lt 1200) {
                if ($x -lt $minX) { $minX = $x }
                if ($x -gt $maxX) { $maxX = $x }
                if ($y -lt $minY) { $minY = $y }
                if ($y -gt $maxY) { $maxY = $y }
            }
        }
    }
}
Write-Host "Hit Sparks Content Bounds: X: $minX .. $maxX (W=$($maxX - $minX)), Y: $minY .. $maxY (H=$($maxY - $minY))"
$img1.Dispose()

$img2 = [System.Drawing.Bitmap]::FromFile((Resolve-Path "assets/images/sfx/Gemini_Generated_Image_7wy6zr7wy6zr7wy6.png").Path)
# For dust, the 4 boxes have black borders R=3, G=3, B=4
$minX2 = 99999; $maxX2 = 0; $minY2 = 99999; $maxY2 = 0
for ($y = 0; $y -lt $img2.Height; $y += 4) {
    for ($x = 0; $x -lt $img2.Width; $x += 4) {
        $c = $img2.GetPixel($x, $y)
        # Black border or dust
        if ($c.R -lt 20 -or $c.R -gt 150) {
            if ($x -lt 2700 -and $y -lt 1200) {
                if ($x -lt $minX2) { $minX2 = $x }
                if ($x -gt $maxX2) { $maxX2 = $x }
                if ($y -lt $minY2) { $minY2 = $y }
                if ($y -gt $maxY2) { $maxY2 = $y }
            }
        }
    }
}
Write-Host "Dust Content Bounds: X: $minX2 .. $maxX2 (W=$($maxX2 - $minX2)), Y: $minY2 .. $maxY2 (H=$($maxY2 - $minY2))"
$img2.Dispose()
