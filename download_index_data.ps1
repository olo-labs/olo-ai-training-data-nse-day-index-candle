param(
    [string]$OutputFolder = (Join-Path $PSScriptRoot "Day_Index\NSE"),
    [datetime]$StartDate = [datetime]::ParseExact("01-Jan-2013", "dd-MMM-yyyy", [cultureinfo]::InvariantCulture),
    [datetime]$EndDate = (Get-Date).Date
)
$ErrorActionPreference = "Stop"
$OutputFolder = [IO.Path]::GetFullPath($OutputFolder)
New-Item -ItemType Directory -Path $OutputFolder -Force | Out-Null
$headers = @{ "user-agent"="Mozilla/5.0"; "referer"="https://www.nseindia.com/all-reports"; "accept"="text/csv,*/*" }
$failed = 0; $downloaded = 0; $unavailable = 0
for ($day=$StartDate.Date; $day -le $EndDate.Date; $day=$day.AddDays(1)) {
    if ($day.DayOfWeek -in @([DayOfWeek]::Saturday,[DayOfWeek]::Sunday)) { continue }
    $stamp=$day.ToString("ddMMyyyy"); $name="ind_close_all_$stamp.csv"
    $target=Join-Path $OutputFolder $name
    if (Test-Path -LiteralPath $target) { continue }
    $temp="$target.download"; $url="https://nsearchives.nseindia.com/content/indices/$name"
    try {
        Invoke-WebRequest -Uri $url -Headers $headers -OutFile $temp -TimeoutSec 30 -UseBasicParsing
        $header=Get-Content -LiteralPath $temp -TotalCount 1
        if ($header -notmatch '(?i)index.?name' -or $header -notmatch '(?i)open.?index.?value' -or $header -notmatch '(?i)closing.?index.?value') { throw "Unexpected index snapshot schema" }
        Move-Item -LiteralPath $temp -Destination $target -Force; $downloaded++
        Write-Host "[OK] $name" -ForegroundColor Green
    } catch {
        Remove-Item -LiteralPath $temp -Force -ErrorAction SilentlyContinue
        if ($_.Exception.Response.StatusCode.value__ -eq 404) { $unavailable++ } else { $failed++; Write-Warning "$name : $($_.Exception.Message)" }
    }
    Start-Sleep -Milliseconds 100
}
Write-Host "Downloaded=$downloaded Unavailable=$unavailable Failed=$failed"
if ($failed) { exit 2 }
