Add-Type -AssemblyName System.Drawing
$files = @(
    'assets/images/Bg_homes/board_settings.png',
    'assets/images/Bg_homes/other_button.png',
    'assets/images/Bg_homes/resume.png',
    'assets/images/Bg_homes/volume.png',
    'assets/images/Buttons/setting.png'
)

foreach ($f in $files) {
    if (Test-Path $f) {
        $full = (Resolve-Path $f).Path
        $bmp = [System.Drawing.Bitmap]::FromFile($full)
        Write-Host "$f : $($bmp.Width) x $($bmp.Height)"
        $bmp.Dispose()
    } else {
        Write-Host "NOT FOUND: $f"
    }
}
