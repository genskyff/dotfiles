function ok($msg, [switch]$n) {
    if ($n) {
        Write-Host $msg -ForegroundColor Green -NoNewline
    } else {
        Write-Host $msg -ForegroundColor Green
    }
}

function error($msg, [switch]$n) {
    if ($n) {
        Write-Host $msg -ForegroundColor Red -NoNewline
    } else {
        Write-Host $msg -ForegroundColor Red
    }
}

function warn($msg, [switch]$n) {
    if ($n) {
        Write-Host $msg -ForegroundColor Yellow -NoNewline
    } else {
        Write-Host $msg -ForegroundColor Yellow
    }
}

function info($msg, [switch]$n) {
    if ($n) {
        Write-Host $msg -ForegroundColor Cyan -NoNewline
    } else {
        Write-Host $msg -ForegroundColor Cyan
    }
}

function bold($msg, [switch]$n) {
    if ($n) {
        Write-Host $msg -ForegroundColor Magenta -NoNewline
    } else {
        Write-Host $msg -ForegroundColor Magenta
    }
}
