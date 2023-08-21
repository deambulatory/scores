# Copy replays to desktop and rename the files
#############################################

if(test-path "C:\Users\$env:username\AppData\Roaming\Replays") { 

    remove-item "C:\Users\$env:username\AppData\Roaming\Replays" -Force -Recurse | Out-Null
    new-item "C:\Users\$env:username\AppData\Roaming\Replays" -ItemType directory | Out-Null

} else { new-item "C:\Users\$env:username\AppData\Roaming\Replays" -ItemType directory | Out-Null }


$path = "C:\Users\$env:username\AppData\Roaming\Replays"

get-childitem -path "C:\Users\$env:username\Documents\TrackMania\Tracks\Replays\autosaves" -Recurse | Copy-Item -Destination $path -Force

$items = get-childitem $path | Sort-Object name

foreach ($item in $items) {
    
    $modifiedFileName = $item.name.Split("-")[0]
    $modifiedFileName += ".gbx"
    Rename-item $item.FullName -NewName $modifiedFileName

}

##########################################

$files = Get-ChildItem $path -ErrorAction SilentlyContinue


foreach ($file in $files) {
    
    $flag = $false
    $content = get-content $file.FullName
    $pattern = 'times best="(\d+)"'
    $match = [regex]::Matches($content, $pattern)
    $number = $match[0].Value  | Select-String -Pattern '\d+' -AllMatches | ForEach-Object { $_.Matches } | ForEach-Object { $_.Value }
    
    $numberAsString = $number.ToString()
    $numberWithoutLastDigit = [int]($numberAsString.Substring(0, $numberAsString.Length - 1))

    if ($numberWithoutLastDigit.ToString().Length -eq 6) {
        # eg 3979550 (1:06:19.55) 

        $flag = $true

        $firstFourNumbers = $numberWithoutLastDigit.ToString().Substring(0, 4)
        $lastTwoNumbers = $numberWithoutLastDigit.ToString().Substring($numberWithoutLastDigit.ToString().Length - 2)
                
        $hour = [math]::DivRem($firstFourNumbers, 3600, [ref]$null)
        $minutes = [math]::DivRem($firstFourNumbers - 3600, 60, [ref]$null)
        $formattedMinutes = "0" + "$minutes" + ":" 
        $seconds = $firstFourNumbers % 60
        
        if ($seconds.ToString().length -eq 1) { $formattedSeconds = "0" + "$seconds" + ":" }
        else { $formattedSeconds = "$seconds" + "." }

        $formattedHour = "$hour" + ":"

        $formattedTime = $formattedHour + $formattedMinutes + $formattedSeconds + $lastTwoNumbers   

    }


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

    if ($flag) { "$track`t" + "$formattedTime" |  out-file "C:\Users\$env:username\AppData\Roaming\Replays\times.txt" -Append }

    else {
            
        $time = "{0:N2}" -f ($numberWithoutLastDigit / 100)

        if ($time.ToString().Length -eq 4) {       
  
            $string = $time.ToString()
            $time = $string.PadLeft(5, "0")   
        }
    
        if ($time.ToString().Length -eq 5) { $time = "00:" + $time }
    
        $track = $file.name -replace ".gbx", ""

        "$track`t" + "$time" |  out-file "C:\Users\$env:username\AppData\Roaming\Replays\times.txt" -Append
    }

}

# remove blank line at the end of txt file

$content = [System.IO.File]::ReadAllText("C:\Users\$env:username\AppData\Roaming\Replays\times.txt")
$content = $content.Trim()
[System.IO.File]::WriteAllText("C:\Users\$env:username\AppData\Roaming\Replays\times.txt", $content)


Start-Process 'C:\WINDOWS\system32\notepad.exe' "C:\Users\$env:username\AppData\Roaming\Replays\times.txt"


