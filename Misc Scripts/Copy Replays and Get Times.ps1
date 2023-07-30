# Copy replays to desktop and rename the files
#############################################

if (test-path C:\Users\$env:username\desktop\Replays) { 

    Write-Host "Replay folder on desktop already exists... stopping script" -f Red
    pause
    exit

}

$path = "C:\Users\$env:username\desktop\Replays"
copy-item -path "C:\Users\$env:username\Documents\TrackMania\Tracks\Replays\Autosaves" -Recurse -Destination $path 
$items = get-childitem $path | Sort-Object name

foreach ($item in $items) {

    $inputString = $item.name    
    $pattern = "(?<=_)(.*?)(?=-)"
    $newName = $inputString | Select-String -Pattern $pattern | ForEach-Object { $_.Matches.Value }
    $newName += ".gbx"
    Rename-item $item.FullName -NewName $newname

}

##########################################

$files = Get-ChildItem "C:\Users\$env:username\Desktop\Replays" -ErrorAction SilentlyContinue
if (test-path C:\Users\$env:username\Desktop\Replays\times.txt) { remove-item C:\Users\$env:username\Desktop\Replays\times.txt }


foreach ($file in $files) {
    
    $flag = $false
    $content = get-content $file.FullName
    $pattern = 'times best="(\d+)"'
    $match = [regex]::Matches($content, $pattern)
    $number = $match[0].Value  | Select-String -Pattern '\d+' -AllMatches | ForEach-Object { $_.Matches } | ForEach-Object { $_.Value }
    
    $numberAsString = $number.ToString()
    $numberWithoutLastDigit = [int]($numberAsString.Substring(0, $numberAsString.Length - 1))

    if ($numberWithoutLastDigit.ToString().Length -eq 4) {

        $firstTwoNumbers = $numberWithoutLastDigit.ToString().Substring(0, 2)
        $lastTwoNumbers = $numberWithoutLastDigit.ToString().Substring($numberWithoutLastDigit.ToString().Length - 2)

        if ($firstTwoNumbers -gt 59) { 
     
            $flag = $true

            $minutes = [math]::DivRem($firstTwoNumbers, 60, [ref]$null)
            $seconds = $firstTwoNumbers % 60
            $formattedMinutes = "0" + "$minutes" + ":"      

            if ($seconds.ToString().length -eq 1) { $formattedSeconds = "0" + "$seconds" + ":" }
            else { $formattedSeconds = "$seconds" + "." }

        }

        $formattedTime = $formattedMinutes + $formattedSeconds + $lastTwoNumbers        
    }

    if ($numberWithoutLastDigit.ToString().Length -eq 5) {

        $flag = $true

        $firstThreeNumbers = $numberWithoutLastDigit.ToString().Substring(0, 3)
        $lastTwoNumbers = $numberWithoutLastDigit.ToString().Substring($numberWithoutLastDigit.ToString().Length - 2)
     
        $minutes = [math]::DivRem($firstThreeNumbers, 60, [ref]$null)
        $seconds = $firstThreeNumbers % 60

        $formattedMinutes = "0" + "$minutes" + ":"     

        if ($seconds.ToString().length -eq 1) { $formattedSeconds = "0" + "$seconds" + ":" }
        else { $formattedSeconds = "$seconds" + "." }
        
        $formattedTime = $formattedMinutes + $formattedSeconds + $lastTwoNumbers
    }
    

    $track = $file.name -replace ".gbx", ""

    if ($flag) { "$track`t" + "$formattedTime" |  out-file "C:\Users\$env:username\Desktop\Replays\times.txt" -Append }

    else {
            
        $time = "{0:N2}" -f ($numberWithoutLastDigit / 100)

        if ($time.ToString().Length -eq 4) {       
  
            $string = $time.ToString()
            $time = $string.PadLeft(5, "0")   
        }
    
        if ($time.ToString().Length -eq 5) { $time = "00:" + $time }
    
        $track = $file.name -replace ".gbx", ""

        "$track`t" + "$time" |  out-file "C:\Users\$env:username\Desktop\Replays\times.txt" -Append
    }

}

