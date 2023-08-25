$ISE = "" + $psISE.CurrentFile.FullPath

if($ISE) { 

    $path = $ISE.Replace('\copyReplaysAndUpdateCSV.ps1', "") 
    cd $path

}

Write-Host "Getting latest repo"
git pull

if($LASTEXITCODE){

    Write-Host "git pull failed; there are probably conflicts that need resolving... exiting script" -f Red
    pause
    exit 1
}

# Add your computer username and player name here
$usernamePlayerNameMap = @{
    "Paul" = "Paul";
    "Leo" = "Leo";
    "Aidan" = "Aidan";
    "dom" = "Dom";
    "BAMABUSS CHONK" = "Darren";
    "Nordom" = "Rob";
}

if(-not $usernamePlayerNameMap[$env:username]){
    Write-Host "Your username is missing from the `$usernamePlayerNameMap dictionary in this script. Add it before continuing."
    pause
    exit 1
}

# Copy replays to %appdata%, rename, and then copy to the local repo replay folder depending on the username
# This script replies on people running it directly from their local repo misc scripts folder
#############################################################################################################

$replayTempPath = "$env:appdata\TrackmaniaTempReplays"
$tempCsvFilePath = "$env:appdata\TrackmaniaTempReplays\times.csv"
$repoPath = $PSScriptRoot.Replace("\MiscScripts", "")
$currentPlayerName = $usernamePlayerNameMap[$env:username]
$targetReplayFolder = "$repoPath\Replays\$currentPlayerName"

if(test-path $replayTempPath) { 

    remove-item $replayTempPath -Force -Recurse | Out-Null
    new-item $replayTempPath -ItemType directory | Out-Null

} else { new-item $replayTempPath -ItemType directory | Out-Null }


get-childitem -path "C:\Users\$env:username\Documents\TrackMania\Tracks\Replays\Autosaves" | Copy-Item -Destination $replayTempPath -Force

$items = get-childitem $replayTempPath | Sort-Object name

foreach ($item in $items) {
    
    $trackName = $item.name.Split("-")[0].Split("_")[1]
    $modifiedFileName = $currentPlayerName + "_$trackName.gbx"
    Rename-item $item.FullName -NewName $modifiedFileName

}

##########################################

$files = Get-ChildItem $replayTempPath -ErrorAction SilentlyContinue
new-item $targetReplayFolder -ItemType directory -Force | Out-Null

foreach($file in $files){
    $file.FullName
    
    Copy-item $file.FullName -Destination "$targetReplayFolder\$($file.Name)" -Force

}
exit 0

#####################################################
# Updated get-time code
# Copy replays to %appdata% and rename the files
#############################################


if (test-path $replayTempPath) { 

    remove-item $replayTempPath -Force -Recurse | Out-Null
    new-item $replayTempPath -ItemType directory | Out-Null

}
else { new-item $replayTempPath -ItemType directory | Out-Null }

get-childitem -path "C:\Users\$env:username\Documents\TrackMania\Tracks\Replays\autosaves" -Recurse | Copy-Item -Destination $replayTempPath -Force

$items = Get-ChildItem $replayTempPath | Sort-Object Name

foreach ($item in $items) {
    $pattern = ".*_([A-E]\d+)-.*"
    if ($item.Name -match $pattern) {
        $modifiedFileName = $matches[1] + ".gbx"
        Rename-Item $item.FullName -NewName $modifiedFileName
    }
}

##########################################

$files = Get-ChildItem $replayTempPath -ErrorAction SilentlyContinue

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

    $track = $file.name.Replace(".gbx", "").Replace("$($currentPlayerName)_", "")

    if ($flag) { "$track," + "$formattedTime" |  out-file $tempCsvFilePath -Append }

    else {
            
        $time = "{0:N2}" -f ($numberWithoutLastDigit / 100)

        if ($time.ToString().Length -eq 4) {       
  
            $string = $time.ToString()
            $time = $string.PadLeft(5, "0")   
        }
    
        if ($time.ToString().Length -eq 5) { $time = "00:" + $time }
    
        $track = $file.name -replace ".gbx", ""

        "$track," + "$time" |  out-file $tempCsvFilePath -Append
    }
}

# remove blank line at the end of txt file

$content = [System.IO.File]::ReadAllText($tempCsvFilePath)
$content = $content.Trim()
[System.IO.File]::WriteAllText($tempCsvFilePath, $content)

#########################

$count = 0
$pathCSV = "$repoPath\data.csv"
$csv = import-csv $pathCSV
$times = import-csv $tempCsvFilePath -Header 'Track', 'Time'
$exportPath = "$env:appdata\export.csv"

foreach($line in $csv){
    foreach($time in $times){

        if($line.Track -eq $time.Track){
            if($line.$playerName -eq $time.Time) {  }
            else {                 

                Write-Host "Updating $($line.Track) from $($line.$playerName) to $($time.Time) " -f green
                $count ++
                $line.$playerName = $time.Time
             }
        }
    }

     $line | export-csv $exportPath -append -nti

}

$content = [System.IO.File]::ReadAllText($exportPath)
$content = $content.Trim() 
$content = $content -replace "`"", ""
[System.IO.File]::WriteAllText($exportPath, $content)

Remove-Item $pathCSV -Force
Copy-Item $exportPath -Destination $pathCSV -Force
Remove-Item $exportPath -Force

Write-host "$count time(s) updated in the CSV file" -f Green

# $currentDir = $PWD
# Set-Location $repoPath
# git reset
# git add Replays
# git add data.csv
# Write-Host "Committing any changes to repo" -f green
# #git commit -m "copyReplaysAndUpdateCSV.ps1" -a 
# Write-Host "Pushing any changes to repo" -f green
# #git push --quiet 
# cd $currentDir
# pause
