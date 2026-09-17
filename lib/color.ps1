function Write-Color($Color, $msg, [switch]$n) {
    Write-Host $msg -ForegroundColor $Color -NoNewline:$n
}

function ok { Write-Color Green @args }
function error { Write-Color Red @args }
function warn { Write-Color Yellow @args }
function info { Write-Color Blue @args }
