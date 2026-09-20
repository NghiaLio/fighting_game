Add-Type -AssemblyName System.Drawing

# --- 1. BUILD HIT SPARK SPRITESHEET (5 frames, each 128x128 -> 640x128) ---
$sparksOrig = [System.Drawing.Bitmap]::FromFile((Resolve-Path "assets/images/sfx/Gemini_Generated_Image_nilnalnilnalniln.png").Path)

$sparkCentersX = @(280, 825, 1381, 1938, 2470)
$sparkCenterY = 760
$sparkSourceHalfSize = 270 # 540x540 box in source

$outSparkW = 128
$outSparkH = 128
$sparkSheet = New-Object System.Drawing.Bitmap (5 * $outSparkW), $outSparkH, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)

# Spark palette indices: [10], [14..26]
# Background indices: [0..9], [11..13]
for ($f = 0; $f -lt 5; $f++) {
    $cx = $sparkCentersX[$f]
    $cy = $sparkCenterY
    $srcLeft = $cx - $sparkSourceHalfSize
    $srcTop = $cy - $sparkSourceHalfSize
    $srcSize = $sparkSourceHalfSize * 2

    for ($outY = 0; $outY -lt $outSparkH; $outY++) {
        $srcY = [int]($srcTop + ($outY / $outSparkH) * $srcSize)
        if ($srcY -lt 0 -or $srcY -ge $sparksOrig.Height) { continue }

        for ($outX = 0; $outX -lt $outSparkW; $outX++) {
            $srcX = [int]($srcLeft + ($outX / $outSparkW) * $srcSize)
            if ($srcX -lt 0 -or $srcX -ge $sparksOrig.Width) { continue }

            # Exclude watermark in bottom-right corner of original image
            if ($srcX -gt 2400 -and $srcY -gt 1200) { continue }

            $c = $sparksOrig.GetPixel($srcX, $srcY)
            $diff = [Math]::Abs($c.R - $c.B)
            
            # Non-background is yellow/orange or white core
            if ($diff -gt 16 -or ($c.R -gt 240 -and $c.G -gt 240 -and $c.B -gt 240)) {
                $targetX = ($f * $outSparkW) + $outX
                $sparkSheet.SetPixel($targetX, $outY, [System.Drawing.Color]::FromArgb(255, $c.R, $c.G, $c.B))
            }
        }
    }
}

$sparksOrig.Dispose()
$outSparkPath = (Resolve-Path "assets/images/sfx").Path + "\hit_spark.png"
$sparkSheet.Save($outSparkPath, [System.Drawing.Imaging.ImageFormat]::Png)
$sparkSheet.Dispose()
Write-Host "Saved clean hit_spark.png at $outSparkPath"

# --- 2. BUILD DUST PUFF SPRITESHEET (4 frames, each 128x128 -> 512x128) ---
$dustOrig = [System.Drawing.Bitmap]::FromFile((Resolve-Path "assets/images/sfx/Gemini_Generated_Image_7wy6zr7wy6zr7wy6.png").Path)

$dustCentersX = @(375, 1056, 1758, 2440)
$dustCenterY = 763
$dustSourceHalfSize = 290 # 580x580 box in source

$outDustW = 128
$outDustH = 128
$dustSheet = New-Object System.Drawing.Bitmap (4 * $outDustW), $outDustH, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)

# In dust palette: 6 (244,246,250), 7 (205,208,215), 10 (165,167,176), 12 (189,190,194)
for ($f = 0; $f -lt 4; $f++) {
    $cx = $dustCentersX[$f]
    $cy = $dustCenterY
    $srcLeft = $cx - $dustSourceHalfSize
    $srcTop = $cy - $dustSourceHalfSize
    $srcSize = $dustSourceHalfSize * 2

    for ($outY = 0; $outY -lt $outDustH; $outY++) {
        $srcY = [int]($srcTop + ($outY / $outDustH) * $srcSize)
        if ($srcY -lt 0 -or $srcY -ge $dustOrig.Height) { continue }

        for ($outX = 0; $outX -lt $outDustW; $outX++) {
            $srcX = [int]($srcLeft + ($outX / $outDustW) * $srcSize)
            if ($srcX -lt 0 -or $srcX -ge $dustOrig.Width) { continue }

            # Exclude watermark
            if ($srcX -gt 2400 -and $srcY -gt 1200) { continue }

            $c = $dustOrig.GetPixel($srcX, $srcY)

            # Check if this pixel is dust:
            # Dust colors in palette:
            # R=244 G=246 B=250 (idx 6)
            # R=205 G=208 B=215 (idx 7)
            # R=189 G=190 B=194 (idx 12)
            # R=165 G=167 B=176 (idx 10)
            # All other colors are background squares (R,G,B in 84..141) or black border (R=3)
            $isDust = ($c.R -gt 155 -and $c.B -gt 165)
            if ($isDust) {
                $targetX = ($f * $outDustW) + $outX
                # For frame 4 (dissipating smoke), give soft opacity if desired, or solid 255
                $alpha = 255
                $dustSheet.SetPixel($targetX, $outY, [System.Drawing.Color]::FromArgb($alpha, $c.R, $c.G, $c.B))
            }
        }
    }
}

$dustOrig.Dispose()
$outDustPath = (Resolve-Path "assets/images/sfx").Path + "\dust_puff.png"
$dustSheet.Save($outDustPath, [System.Drawing.Imaging.ImageFormat]::Png)
$dustSheet.Dispose()
Write-Host "Saved clean dust_puff.png at $outDustPath"
