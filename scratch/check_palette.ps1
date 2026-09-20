Add-Type -AssemblyName System.Drawing

$img1 = [System.Drawing.Bitmap]::FromFile((Resolve-Path "assets/images/sfx/Gemini_Generated_Image_nilnalnilnalniln.png").Path)
Write-Host "Hit sparks palette count:" $img1.Palette.Entries.Length
$colors = $img1.Palette.Entries | Select-Object -Unique | ForEach-Object { "$($_.R),$($_.G),$($_.B)" }
Write-Host "Unique colors in hit sparks:" $colors.Count
$img1.Dispose()

$img2 = [System.Drawing.Bitmap]::FromFile((Resolve-Path "assets/images/sfx/Gemini_Generated_Image_7wy6zr7wy6zr7wy6.png").Path)
Write-Host "Dust palette count:" $img2.Palette.Entries.Length
$colors2 = $img2.Palette.Entries | Select-Object -Unique | ForEach-Object { "$($_.R),$($_.G),$($_.B)" }
Write-Host "Unique colors in dust:" $colors2.Count
$img2.Dispose()
