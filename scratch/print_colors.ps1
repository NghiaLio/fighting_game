Add-Type -AssemblyName System.Drawing

Write-Host "--- Hit Sparks (27 colors) ---"
$img1 = [System.Drawing.Bitmap]::FromFile((Resolve-Path "assets/images/sfx/Gemini_Generated_Image_nilnalnilnalniln.png").Path)
for ($i=0; $i -lt $img1.Palette.Entries.Length; $i++) {
    $c = $img1.Palette.Entries[$i]
    Write-Host "[$i] R=$($c.R) G=$($c.G) B=$($c.B)"
}
$img1.Dispose()

Write-Host "`n--- Dust (13 colors) ---"
$img2 = [System.Drawing.Bitmap]::FromFile((Resolve-Path "assets/images/sfx/Gemini_Generated_Image_7wy6zr7wy6zr7wy6.png").Path)
for ($i=0; $i -lt $img2.Palette.Entries.Length; $i++) {
    $c = $img2.Palette.Entries[$i]
    Write-Host "[$i] R=$($c.R) G=$($c.G) B=$($c.B)"
}
$img2.Dispose()
