Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile((Resolve-Path "assets/images/Bg_homes/select_per.png"))
$w = $bmp.Width
$h = $bmp.Height
Write-Output "Size: ${w}x${h}"

# Find bounding box of all separated regions
# Sample grid with alpha > 10
$grid = New-Object 'bool[,]' $w, $h
for ($y = 0; $y -lt $h; $y++) {
    for ($x = 0; $x -lt $w; $x++) {
        $c = $bmp.GetPixel($x, $y)
        if ($c.A -gt 15) {
            $grid[$x, $y] = $true
        }
    }
}
$bmp.Dispose()
Write-Output "Alpha grid built!"

$visited = New-Object 'bool[,]' $w, $h
$components = [System.Collections.ArrayList]::new()

for ($y = 0; $y -lt $h; $y += 2) {
    for ($x = 0; $x -lt $w; $x += 2) {
        if ($grid[$x, $y] -and -not $visited[$x, $y]) {
            $minx = $x; $maxx = $x; $miny = $y; $maxy = $y
            $q = [System.Collections.Queue]::new()
            $q.Enqueue([System.Drawing.Point]::new($x, $y))
            $visited[$x, $y] = $true
            $count = 0
            while ($q.Count -gt 0) {
                $p = $q.Dequeue()
                $count++
                if ($p.X -lt $minx) { $minx = $p.X }
                if ($p.X -gt $maxx) { $maxx = $p.X }
                if ($p.Y -lt $miny) { $miny = $p.Y }
                if ($p.Y -gt $maxy) { $maxy = $p.Y }
                $dirs = @(@(-1,0), @(1,0), @(0,-1), @(0,1))
                foreach ($d in $dirs) {
                    $nx = $p.X + $d[0]
                    $ny = $p.Y + $d[1]
                    if ($nx -ge 0 -and $nx -lt $w -and $ny -ge 0 -and $ny -lt $h) {
                        if ($grid[$nx, $ny] -and -not $visited[$nx, $ny]) {
                            $visited[$nx, $ny] = $true
                            $q.Enqueue([System.Drawing.Point]::new($nx, $ny))
                        }
                    }
                }
            }
            if ($count -gt 100) {
                $null = $components.Add([PSCustomObject]@{
                    X = $minx
                    Y = $miny
                    W = ($maxx - $minx + 1)
                    H = ($maxy - $miny + 1)
                    Count = $count
                })
            }
        }
    }
}

$sorted = $components | Sort-Object { [Math]::Floor($_.Y / 100) }, { $_.X }
foreach ($c in $sorted) {
    Write-Output "Rect: L=$($c.X), T=$($c.Y), W=$($c.W), H=$($c.H) (pts: $($c.Count))"
}
