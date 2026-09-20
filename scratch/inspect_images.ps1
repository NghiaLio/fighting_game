Add-Type -AssemblyName System.Drawing

function Check-Alpha($path) {
    if (-not (Test-Path $path)) {
        Write-Host "File not found: $path"
        return
    }
    $full = (Resolve-Path $path).Path
    $bmp = [System.Drawing.Bitmap]::FromFile($full)
    $hasTransparent = $false
    $nonZeroAlpha = $false
    $corners = @(
        $bmp.GetPixel(0, 0),
        $bmp.GetPixel($bmp.Width - 1, 0),
        $bmp.GetPixel(0, $bmp.Height - 1),
        $bmp.GetPixel($bmp.Width - 1, $bmp.Height - 1)
    )
    Write-Host "=== $path ($($bmp.Width)x$($bmp.Height)) ==="
    Write-Host "PixelFormat: $($bmp.PixelFormat)"
    Write-Host "Top-Left ARGB: A=$($corners[0].A), R=$($corners[0].R), G=$($corners[0].G), B=$($corners[0].B)"
    $bmp.Dispose()
}

Check-Alpha "assets/images/Bg_homes/board_settings.png"
Check-Alpha "assets/images/Bg_homes/other_button.png"
Check-Alpha "assets/images/Bg_homes/resume.png"
Check-Alpha "assets/images/Bg_homes/volume.png"
Check-Alpha "assets/images/Buttons/setting.png"
