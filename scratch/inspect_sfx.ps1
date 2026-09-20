Add-Type -AssemblyName System.Drawing

$img1Path = "assets/images/sfx/Gemini_Generated_Image_nilnalnilnalniln.png"
$img1 = [System.Drawing.Bitmap]::FromFile((Resolve-Path $img1Path).Path)
Write-Host "Image 1 (Hit Sparks):" $img1.Width "x" $img1.Height "PixelFormat:" $img1.PixelFormat
# Sample top-left corner (0,0)
$c0 = $img1.GetPixel(0, 0)
Write-Host "Corner pixel (0,0): R=$($c0.R), G=$($c0.G), B=$($c0.B), A=$($c0.A)"
$c1 = $img1.GetPixel(30, 0)
Write-Host "Pixel (30,0): R=$($c1.R), G=$($c1.G), B=$($c1.B), A=$($c1.A)"
$img1.Dispose()

$img2Path = "assets/images/sfx/Gemini_Generated_Image_7wy6zr7wy6zr7wy6.png"
$img2 = [System.Drawing.Bitmap]::FromFile((Resolve-Path $img2Path).Path)
Write-Host "Image 2 (Dust):" $img2.Width "x" $img2.Height "PixelFormat:" $img2.PixelFormat
$c2 = $img2.GetPixel(0, 0)
Write-Host "Corner pixel (0,0): R=$($c2.R), G=$($c2.G), B=$($c2.B), A=$($c2.A)"
$img2.Dispose()
