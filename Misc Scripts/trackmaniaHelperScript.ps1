
# ===========================================================
# constants
# ===========================================================

$source_path = "C:\Users\$env:username\Documents\TrackMania\Tracks\Replays\Autosaves"
$destination_path = "E:\_repos\private\trackmania_records"
$destination_deambulatory_scores = "E:\_repos_sharedWithMe\scores"

$tracknameToIndex = [ordered]@{

    "A01" = 0 
    "A02" = 1 
    "A03" = 2 
    "A04" = 3 
    "A05" = 4 
    "A06" = 5 
    "A07" = 6 
    "A08" = 7 
    "A09" = 8 
    "A10" = 9 
    "A11" = 10 
    "A12" = 11 
    "A13" = 12 
    "A14" = 13 
    "A15" = 14 
              
    "B01" = 15 
    "B02" = 16 
    "B03" = 17 
    "B04" = 18 
    "B05" = 19 
    "B06" = 20 
    "B07" = 21 
    "B08" = 22 
    "B09" = 23 
    "B10" = 24 
    "B11" = 25 
    "B12" = 26 
    "B13" = 27 
    "B14" = 28 
    "B15" = 29 
              
    "C01" = 30 
    "C02" = 31 
    "C03" = 32 
    "C04" = 33 
    "C05" = 34 
    "C06" = 35 
    "C07" = 36 
    "C08" = 37 
    "C09" = 38 
    "C10" = 39 
    "C11" = 40 
    "C12" = 41 
    "C13" = 42 
    "C14" = 43 
    "C15" = 44 
              
    "D01" = 45 
    "D02" = 46 
    "D03" = 47 
    "D04" = 48 
    "D05" = 49 
    "D06" = 50 
    "D07" = 51 
    "D08" = 52 
    "D09" = 53 
    "D10" = 54 
    "D11" = 55 
    "D12" = 56 
    "D13" = 57 
    "D14" = 58 
    "D15" = 59 
              
    "E01" = 60 
    "E02" = 61 
    "E03" = 62 
    "E04" = 63 
    "E05" = 64 
}

# ===========================================================
# variables
# ===========================================================

$notFinished = $true

# ===========================================================
# functions
# ===========================================================

Function readMePlease() { 

    Write-Host "
********************************************************************************************************************************
*                                                                                                                              *
*                                                     ~~~ Read Me ~~~                                                          *
*                                                                                                                              *
********************************************************************************************************************************
 
 | Pre-requisites
 | ==============
 |
 | 1. It is recommended to use to Visual Studio Code to view the csv files. Who is it recommended by? ME. Excel is bloated
 |    and not plain text and also can have issues displaying the values in the correct format. Set your default .csv viewer
 |    to Visual studio Code and csv files will open by default in that application when opened in this script.
 |
 | 2. Before using this script it is recommended to do a pull request on the deambulatory\scores repository. This is to ensure
 |    the local repository has the latest updates, before changes are made to the data.csv file.
 |
 | Post Script Operations
 | ======================
 |
 | 1. Make sure to commit and push your changes after updating the data.csv file, so that the website will be updated with the
 |    latest times.
 |
 | Code that Runs when Script is Run
 | =================================
 |
 | When the script is started, it checks if three directories are present. These are required for the script to operate.
 |
 | > source_path                     | Where the Trackmania application saves track times
 | > destination_path                | Where the script saves new track records to [preferably a git repository]
 | > destination_deambulatory_scores | The git repository where the scores are updated for the online website
 |
 | If one or more of these directories is not found, the script quits.
 |
 | Main Menu
 | =========
 |
 | > 2. source > open
 |   ~~~~~~~~~~~~~~~~
 |
 |   The directory where Trackmania stores the players track times. It only stores the fastest record for each track though.
 |   When a new record is set, the old record gets overwritten.
 |
 |   File format: <playerName>_<trackname>-<tracktype>.replay.gbx
 |
 |   E.g.: BAMBUUSCHONK_B01-Race.Replay.gbx
 |
 |
 | > 3. destination > update
 |   ~~~~~~~~~~~~~~~~~~~~~~~
 |
 |   All new track times are stored in this directory. Including each new record set for each track. E.g.:
 |
 |   > C04_00-39-91.gbx
 |   > C04_00-40-46.gbx
 |   > C04_00-40-90.gbx
 |
 |   This directory is intended to be a git repository for storing the players track times. It also stores this script, and
 |   the times.csv file. Read on to learn more.
 |
 |   File format: <trackname>_<MM>-<SS>-<MS>.gbx [MM: minutes | SS: seconds | MS: milliseconds]
 |
 |   By storing the files in this file format, the files can be sorted by windows explorer in track and time order.
 |
 | > 4. destination > open
 |   ~~~~~~~~~~~~~~~~~~~~~
 |
 |   Opens the destination folder.
 |
 | > 5. destination > times.csv > update
 |   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 |
 |   A csv file with the fastes track time for each track.
 |
 |   E.g.:
 |
 |   trackname,tracktime
 |   A01,00:24.52
 |   A02,00:17.13
 |   A03,00:18.79
 |   ...
 |
 |   This file is used by the function '8. deambulatory > data.csv > update' to update the track times in the data.csv folder.
 |
 | > 6. destination > times.csv > open
 |   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 |
 |   Opens the times.csv folder.
 |
 | > 7. deambulatory > open
 |   ~~~~~~~~~~~~~~~~~~~~~~
 |
 |   Opens the deambulatory repository.
 |
 | > 8. deambulatory > data.csv > update
 |   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 |
 |   Updates the data.csv file. This file stores all the times for each player that are shown on the website. It uses the 
 |   times.csv file to get the fastest times.
 |
 | > 9. deambulatory > data.csv > open
 |   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 |
 |   Opens the data.csv file.
 
********************************************************************************************************************************
*                                                                                                                              *
*                                                     ~~~ Read Me ~~~                                                          *
*                                                                                                                              *
********************************************************************************************************************************

"
}

Function destination_update() {

    Write-Output "`nNew Records:`n"

    $source_replayFiles = if (Test-path $source_path) { Get-ChildItem -LiteralPath $source_path }

    foreach ($replayFile in $source_replayFiles) {

        $filenameSplit = $replayFile.Name.Split("_")
    
        $trackname = $filenameSplit[$filenameSplit.Count - 1].Substring(0, 3)
        $tracktime = (getTrackTime($replayFile.FullName))

        $destination_filename = $trackname + "_" + ($tracktime.Replace(":", "-").Replace(".", "-")) + ".gbx"

        if (Test-Path "$destination_path\$destination_filename") { Continue }

        Copy-Item -LiteralPath $replayFile.FullName -Destination "$destination_path\$destination_filename"

        Write-Output "> $destination_filename"
    }
}

Function destination_times_update() {

    if (Test-Path "$destination_path\times.csv") { Clear-Content "$destination_path\times.csv" }
    else { New-Item "$destination_path\times.csv" }

    $times = [ordered]@{

        A01 = ''
        A02 = ''
        A03 = ''
        A04 = ''
        A05 = ''
        A06 = ''
        A07 = ''
        A08 = ''
        A09 = ''
        A10 = ''
        A11 = ''
        A12 = ''
        A13 = ''
        A14 = ''
        A15 = ''

        B01 = ''
        B02 = ''
        B03 = ''
        B04 = ''
        B05 = ''
        B06 = ''
        B07 = ''
        B08 = ''
        B09 = ''
        B10 = ''
        B11 = ''
        B12 = ''
        B13 = ''
        B14 = ''
        B15 = ''

        C01 = ''
        C02 = ''
        C03 = ''
        C04 = ''
        C05 = ''
        C06 = ''
        C07 = ''
        C08 = ''
        C09 = ''
        C10 = ''
        C11 = ''
        C12 = ''
        C13 = ''
        C14 = ''
        C15 = ''

        D01 = ''
        D02 = ''
        D03 = ''
        D04 = ''
        D05 = ''
        D06 = ''
        D07 = ''
        D08 = ''
        D09 = ''
        D10 = ''
        D11 = ''
        D12 = ''
        D13 = ''
        D14 = ''
        D15 = ''

        E01 = ''
        E02 = ''
        E03 = ''
        E04 = ''
        E05 = ''
    }

    $destination_replayFiles = if (Test-path $destination_path) { Get-ChildItem -Path "$destination_path\*.gbx" }

    foreach ($replayFile in $destination_replayFiles) {
        
        $filenameSplit = $replayFile.Name.Split("_")

        $trackname = $filenameSplit[0]
        $tracktime = $filenameSplit[1].Substring(0, 8)

        if ($times[$trackname] -eq '') { $times[$trackname] = $tracktime }
        elseif ($tracktime -lt $times[$trackname]) { $times[$trackname] = $tracktime }
    }

    "trackname,tracktime" | Out-File -FilePath "$destination_path\times.csv" -Append

    foreach ($trackname in $times.Keys) { 
        $tracktime = $times[$trackname]
        if ($tracktime -ne '') { $tracktime = $tracktime.Substring(0, 2) + ':' + $tracktime.Substring(3, 2) + '.' + $tracktime.Substring(6, 2) }
        
        $trackname + ',' + $tracktime | Out-File -FilePath "$destination_path\times.csv" -Append
    }
}

Function deambulatory_data_update() { 

    # open deambulatory_data

    $dataFile = Get-Content -LiteralPath "$destination_deambulatory_scores\data.csv"
    
    # select player

    $selectedPlayer = $null
    $numberOfColumns = $dataFile[0].Split(',').Count
    $columnNumberForPlayer = $null
    $selectingPlayer = $true
    while ($selectingPlayer) {
        Write-Host "data.csv header: $($dataFile[0])"
        $input = Read-Host "`nEnter player name"
        $count = 0
        foreach ($columnHeader in $dataFile[0].Split(',')) {
            if ($columnHeader -eq 'Track type' -or $columnHeader -eq 'Track') { }
            elseif ($input -eq $columnHeader) {
                $selectedPlayer = $columnHeader
                $selectingPlayer = $false
                $columnNumberForPlayer = $count
            }
            $count++
        }
        if ($selectingPlayer) { Write-Host "Invalid Input" }
    }

    Write-Host "`n"
    Write-Host "~~~~~~~~~~~~~~~~~~~~~~~~~`n"
    Write-Host "Selected Player         : $selectedPlayer"
    Write-Host "Number of Columns       : $numberOfColumns"
    Write-Host "Column Number For Player: $columnNumberForPlayer`n"

    # open destination_times

    $timesFile = Get-Content -LiteralPath "$destination_path\times.csv"

    # update deambulatory_data

    foreach ($line in $timesFile) {
        $lineSplit = $line.Split(',')
        $trackname = $lineSplit[0]
        $tracktime = $lineSplit[1]
        $tracknameIndex = $tracknameToIndex[$trackname]

        $dataLine = $dataFile[$tracknameIndex + 1]
        $dataLineSplit = $dataLine.Split(',')
        if ($dataLineSplit[1] -eq $trackname) {
            if ($dataLineSplit[$columnnumberForPlayer] -ne $tracktime) {
                Write-Host "> update data.csv - line $($tracknameIndex+1) from: $dataLine"
                $dataLineSplit[$columnnumberForPlayer] = $tracktime
                $previewOutString = ''
                foreach ($s in $dataLineSplit) { $previewOutString += $s + ',' }
                $previewOutString = $previewOutString.Substring(0, $previewOutString.Length - 1)
                $dataFile[$tracknameIndex + 1] = $previewOutString
                Write-host "                              to: $previewOutString`n"
            }
        }
    }

    $dataFile | Set-Content -Literalpath "$destination_deambulatory_scores\data.csv"
}

# ===========================================================
# functions - helper functions
# ===========================================================

Function getTrackTime($filePath) {

    # nice work bro, this is real nice!

    $flag = $false
    $content = get-content $filePath
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
    

    $track = $filePath -replace ".gbx", ""

    if ($flag) { return $formattedTime }

    else {
            
        $time = "{0:N2}" -f ($numberWithoutLastDigit / 100)

        if ($time.ToString().Length -eq 4) {       
  
            $string = $time.ToString()
            $time = $string.PadLeft(5, "0")   
        }
    
        if ($time.ToString().Length -eq 5) { $time = "00:" + $time }
    
        $track = $filePath -replace ".gbx", ""

        return $time
    }
}

# ===========================================================
# logic
# ===========================================================

# test working directories

$notAllDirectoriesFound = $false

Write-Host "`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
Write-Host "Checking Working Directories:`n"

if (Test-Path $source_path) { Write-Host ">                     source_path -     found: $source_path" }
else { 
    Write-Host ">                     source_path - NOT found: $source_path"
    $notAllDirectoriesFound = $true
}

if (Test-Path $destination_path) { Write-Host ">                destination_path -     found: $destination_path" }
else {
    Write-Host ">                destination_path - NOT found: $destination_path"
    $notAllDirectoriesFound = $true
}

if (Test-Path $destination_deambulatory_scores) { Write-Host "> destination_deambulatory_scores -     found: $destination_deambulatory_scores" }
else {
    Write-Host "> destination_deambulatory_scores - NOT found: $destination_deambulatory_scores"
    $notAllDirectoriesFound = $true
}

if ($notAllDirectoriesFound) {
    Write-Host "`nNot all directories found, quitting"
    readMePlease
    Read-Host "`n Press any key to quit"
    exit
}

Write-Host "`n~~~~~"
Write-Host "NOTE:`n"

Write-Host "> Pull latest changes to deamblatory_scores first!"

# control loop

while ($notFinished) {

    Write-Host "`n"
    Write-Host "Select option:"
    Write-Host ">-------------"
    Write-Host ""
    Write-Host "-<|  0. exit"
    Write-Host "  |  1. read me please"
    Write-Host "  |"
    Write-Host "  |  2. source > open"
    Write-Host "  |"
    Write-Host "  |  3. destination > update"
    Write-Host "  |  4. destination > open"
    Write-Host "  |  5. destination > times.csv > update"
    Write-Host "  |  6. destination > times.csv > open"
    Write-Host "  |"
    Write-Host "  |  7. deambulatory > open"
    Write-Host "  |  8. deambulatory > data.csv > update"
    Write-Host "  |  9. deambulatory > data.csv > open"
    Write-Host "  |"
    Write-Host "  | 10. deambulatory > open online repository"
    Write-Host "  | 11. deambulatory > open website"

    $option = Read-Host "`noption"

    switch ($option) {
    
        "0" <# Exit #> { exit }
         
        "1" <# Read me please #> { readMePlease }
         
        "2" <# source > open #> { Invoke-Item $source_path }
         
        "3" <# destination > update #> { destination_update }
         
        "4" <# destination > open #> { Invoke-Item $destination_path }
         
        "5" <# destination > times.csv > update #> { destination_times_update }
         
        "6" <# destination > times.csv > open #> { Invoke-Item "$destination_path\times.csv" }
         
        "7" <# deambulatory > open #> { Invoke-Item $destination_deambulatory_scores }
         
        "8" <# deambulatory > data.csv > update #> { deambulatory_data_update }
         
        "9" <# deambulatory > data.csv > open #> { Invoke-Item "$destination_deambulatory_scores\data.csv" }

        "10" <# deambulatory > open online repository #> { Start-Process "https://github.com/deambulatory/scores/" }

        "11" <# deambulatory > open website #> { Start-Process "https://deambulatory.github.io/scores/" }

        default { Write-Host "`nInput invalid, what the FUCK is WRONG with you" }
    }
}

