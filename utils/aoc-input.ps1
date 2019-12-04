Param(
    $year,
    $day
)

$path = Split-Path -parent $PSCommandPath

if (-Not (Test-Path "$path/cache/$year-$day.txt")) {
    $session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
    $cookie = New-Object System.Net.Cookie

    $cookie_txt = Get-Content -Path "$path/cookies.secret"

    $cookie.Name = "session"
    $cookie.Value = $cookie_txt.Split("=", 2) | Select -Index 1
    $cookie.Domain = "adventofcode.com"

    $session.Cookies.Add($cookie)

    Invoke-WebRequest "https://adventofcode.com/$year/day/$day/input" -WebSession $session -OutFile "$path/cache/$year-$day.txt"
}

Get-Content -Path "$path/cache/$year-$day.txt"
