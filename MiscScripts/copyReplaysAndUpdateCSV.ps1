Write-Host "Getting latest repo"
git pull

# Copy replays to %appdata%, rename, and then copy to the local repo replay folder depending on the username
# This script replies on people running it directly from their local repo misc scripts folder
#############################################################################################################

if(test-path "C:\Users\$env:username\AppData\Roaming\Replays") { 

    remove-item "C:\Users\$env:username\AppData\Roaming\Replays" -Force -Recurse | Out-Null
    new-item "C:\Users\$env:username\AppData\Roaming\Replays" -ItemType directory | Out-Null

} else { new-item "C:\Users\$env:username\AppData\Roaming\Replays" -ItemType directory | Out-Null }

$repo = $psscriptroot
$newReplayPath = "C:\Users\$env:username\AppData\Roaming\Replays" 

switch ($env:username)
{
    "Paul" { $repo = $repo -replace ("MiscScripts", "Replays\Paul")   }
    "Leo"{ $repo = $repo -replace ("MiscScripts", "Replays\Leo")   }
    "Aidan" { $repo = $repo -replace ("MiscScripts", "Replays\Aidan")   }
    "BAMBUUS CHONK" { $repo = $repo -replace ("MiscScripts", "Replays\Darren") }
    "Dom" { $repo = $repo -replace ("MiscScripts", "Replays\Dom") }
}


get-childitem -path "C:\Users\$env:username\Documents\TrackMania\Tracks\Replays\Autosaves" | Copy-Item -Destination $newReplayPath -Force


$items = get-childitem $newReplayPath | Sort-Object name

foreach ($item in $items) {
    
    $modifiedFileName = $item.name.Split("-")[0]
    $modifiedFileName += ".gbx"
    $modifiedFileName = $modifiedFileName -replace ("BAMBUUSCHONK", "Darren")
    Rename-item $item.FullName -NewName $modifiedFileName

}

##########################################

$files = Get-ChildItem $newReplayPath -ErrorAction SilentlyContinue


foreach($file in $files){
    

    Copy-item $file.FullName -Destination $repo -Force

}


#####################################################
# Updated get-time code
# Copy replays to %appdata% and rename the files
#############################################


if (test-path "C:\Users\$env:username\AppData\Roaming\Replays") { 

    remove-item "C:\Users\$env:username\AppData\Roaming\Replays" -Force -Recurse | Out-Null
    new-item "C:\Users\$env:username\AppData\Roaming\Replays" -ItemType directory | Out-Null

}
else { new-item "C:\Users\$env:username\AppData\Roaming\Replays" -ItemType directory | Out-Null }

$path = "C:\Users\$env:username\AppData\Roaming\Replays"

get-childitem -path "C:\Users\$env:username\Documents\TrackMania\Tracks\Replays\autosaves" -Recurse | Copy-Item -Destination $path -Force

$items = Get-ChildItem $path | Sort-Object Name

foreach ($item in $items) {
    $pattern = ".*_([A-E]\d+)-.*"
    if ($item.Name -match $pattern) {
        $modifiedFileName = $matches[1] + ".gbx"
        Rename-Item $item.FullName -NewName $modifiedFileName
    }
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
        
        if ($seconds.ToString().length -eq 1) { $formattedSeconds = "0" + "$seconds" + "." }
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

            if ($seconds.ToString().length -eq 1) { $formattedSeconds = "0" + "$seconds" + "." }
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

        if ($seconds.ToString().length -eq 1) { $formattedSeconds = "0" + "$seconds" + "." }
        else { $formattedSeconds = "$seconds" + "." }
        
        $formattedTime = $formattedMinutes + $formattedSeconds + $lastTwoNumbers
        
    }

    $track = $file.name -replace ".gbx", ""

    if ($flag) { "$track," + "$formattedTime" |  out-file "C:\Users\$env:username\AppData\Roaming\Replays\times.txt" -Append }

    else {
            
        $time = "{0:N2}" -f ($numberWithoutLastDigit / 100)

        if ($time.ToString().Length -eq 4) {       
  
            $string = $time.ToString()
            $time = $string.PadLeft(5, "0")   
        }
    
        if ($time.ToString().Length -eq 5) { $time = "00:" + $time }
    
        $track = $file.name -replace ".gbx", ""

        "$track," + "$time" |  out-file "C:\Users\$env:username\AppData\Roaming\Replays\times.txt" -Append
    }
}

# remove blank line at the end of txt file

$content = [System.IO.File]::ReadAllText("C:\Users\$env:username\AppData\Roaming\Replays\times.txt")
$content = $content.Trim()
[System.IO.File]::WriteAllText("C:\Users\$env:username\AppData\Roaming\Replays\times.txt", $content)

#########################

$count = 0
$repo = $psscriptroot
$pathCSV = $repo -replace "MiscScripts", "data.csv"
$csv = import-csv $pathCSV
$times = import-csv "C:\Users\$env:username\AppData\Roaming\Replays\times.txt" -Header 'Track', 'Time'
$user = ""
$export = "C:\Users\$env:username\AppData\Roaming\export.csv"

    switch ($env:username)
    {
        "Paul" { $user = "Paul"  }
        "Leo"{  $user = "Leo"  }
        "Aidan" { $user = "Aidan"   }
        "BAMBUUS CHONK" { $user = "Darren" }
        "Dom" { $user = "Dom"}
    }
    

foreach($line in $csv){

   
    foreach($time in $times){
    
        if($line.Track -eq $time.Track){

            
            if($line.$user -eq $time.Time) {  }
            else {                 

                Write-Host "Updating $($line.Track) from $($line.$user) to $($time.Time) " -f green
                $count ++
                $line.$user = $time.Time
                            
             }

        }       

    }

     $line | export-csv "C:\Users\$env:username\AppData\Roaming\export.csv" -append -nti

}

$content = [System.IO.File]::ReadAllText("C:\Users\$env:username\AppData\Roaming\export.csv")
$content = $content.Trim() 
$content = $content -replace "`"", ""
[System.IO.File]::WriteAllText("C:\Users\$env:username\AppData\Roaming\export.csv", $content)

Remove-Item $pathCSV -Force
Copy-Item $export -Destination $pathCSV -Force
Remove-Item $export -Force

Write-host "$count time(s) updated in the CSV file" -f Green


git add --all
Write-Host "Committing any changes to repo" -f green
git commit -m "copyReplaysAndUpdateCSV.ps1" -a 
Write-Host "Pushing any changes to repo" -f green
git push --quiet 

pause











