Add-Type -AssemblyName System.Drawing

$srcPath = Resolve-Path "assets/images/Bg_homes/UI_tileset_2.png"
$outDir = "assets/images/Bg_homes/ui2"

if (-not (Test-Path $outDir)) {
    New-Item -ItemType Directory -Path $outDir -Force | Out-Null
}

$bmp = [System.Drawing.Bitmap]::FromFile($srcPath)

$slices = @{
    "roster_grid_board"   = @(3, 2, 266, 171)
    "hero_pillar_blue"    = @(271, 14, 49, 158)
    "hero_pillar_red"     = @(321, 11, 53, 163)
    "hero_pillar_purple"  = @(377, 11, 53, 162)
    "hero_pillar_green"   = @(432, 10, 55, 163)
    "top_info_panel"      = @(497, 13, 165, 84)
    "bottom_info_panel"   = @(497, 98, 165, 71)
    "valor_wings_crest"   = @(363, 175, 187, 72)
    "roster_bar_6"        = @(36, 182, 185, 32)
    "roster_bar_8"        = @(6, 222, 242, 38)
    "double_slot"         = @(252, 224, 92, 32)
    "stat_box_4rows"      = @(241, 263, 92, 78)
    "wide_sword_plaque"   = @(6, 264, 227, 67)
    "red_drapery"         = @(346, 259, 115, 31)
    "blue_drapery"        = @(347, 290, 114, 27)
    "red_gothic_banner"   = @(484, 265, 46, 98)
    "blue_gothic_banner"  = @(534, 265, 47, 99)
    "purple_gothic_banner"= @(585, 265, 46, 97)
    "long_pointed_button" = @(21, 330, 209, 37)
    "badge_skull"         = @(467, 230, 29, 30)
    "badge_crown"         = @(499, 230, 30, 30)
    "badge_shield"        = @(535, 230, 31, 31)
    "badge_swords"        = @(569, 230, 30, 30)
    "ruby_diamond"        = @(361, 226, 23, 30)
    "sapphire_diamond"    = @(385, 226, 21, 30)
    "emerald_diamond"     = @(407, 226, 23, 30)
    "arrow_left"          = @(3, 185, 15, 27)
    "arrow_right"         = @(326, 181, 18, 26)
}

foreach ($key in $slices.Keys) {
    $c = $slices[$key]
    $rect = New-Object System.Drawing.Rectangle($c[0], $c[1], $c[2], $c[3])
    $crop = $bmp.Clone($rect, $bmp.PixelFormat)
    $targetFile = Join-Path $outDir "$key.png"
    $crop.Save($targetFile, [System.Drawing.Imaging.ImageFormat]::Png)
    $crop.Dispose()
    Write-Output "Sliced: $key -> $targetFile"
}

$bmp.Dispose()
Write-Output "Done slicing all tiles!"
