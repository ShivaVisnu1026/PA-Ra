# PowerShell script to create bear versions from bull versions

$files = @(
    "pa_breakout_volume_bull.xs",
    "pa_breakout_volume_5min_bull.xs",
    "pa_breakout_volume_15min_bull.xs",
    "pa_breakout_volume_60min_bull.xs",
    "pa_breakout_volume_weekly_bull.xs",
    "pa_breakout_volume_monthly_bull.xs"
)

foreach ($file in $files) {
    $bearFile = $file -replace "_bull\.xs$", "_bear.xs"
    $content = Get-Content $file -Raw
    
    # Replace bullish with bearish logic
    $content = $content -replace "// Breakout Alert - ", "// BEAR Breakout Alert - "
    $content = $content -replace "// 2\) 20 EMA > 56 EMA \(bullish trend\)", "// 2) 20 EMA < 56 EMA (bearish trend)"
    $content = $content -replace "// 4\) Current high breaks above max high of prior 5 bars", "// 4) Current low breaks below min low of prior 5 bars"
    $content = $content -replace "// 5\) Bullish close \(Close > Open\)", "// 5) Bearish close (Close < Open)"
    $content = $content -replace "Breakout Alert!", "BEAR Breakout Alert!"
    $content = $content -replace "Breakout Alert \(([^)]+)\)!", "BEAR Breakout Alert (`$1)!"
    $content = $content -replace "is_ema_bullish = \(ema20_val > ema56_val\)", "is_ema_bearish = (ema20_val < ema56_val)"
    $content = $content -replace "prior_high = Highest\(High\[1\], breakout_bars\)", "prior_low = Lowest(Low[1], breakout_bars)"
    $content = $content -replace "is_breakout = \(High > prior_high\)", "is_breakout = (Low < prior_low)"
    $content = $content -replace "is_bullish = \(Close > Open\)", "is_bearish = (Close < Open)"
    $content = $content -replace "is_ema_bullish", "is_ema_bearish"
    $content = $content -replace "is_bullish", "is_bearish"
    $content = $content -replace "prior_high", "prior_low"
    $content = $content -replace """ \| High: """, """ | Low: """
    $content = $content -replace "NumToStr\(High, 2\)", "NumToStr(Low, 2)"
    
    $content | Set-Content $bearFile -NoNewline
    Write-Host "Created $bearFile"
}

Write-Host "All bear versions created successfully!"

