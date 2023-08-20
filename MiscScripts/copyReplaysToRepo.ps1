﻿# Copy replays to desktop and rename the files
#############################################

if(test-path "C:\Users\$env:username\AppData\Roaming\Replays") { 

    remove-item "C:\Users\$env:username\AppData\Roaming\Replays" -Force -Recurse | Out-Null
    new-item "C:\Users\$env:username\AppData\Roaming\Replays" -ItemType directory | Out-Null

} else { new-item "C:\Users\$env:username\AppData\Roaming\Replays" -ItemType directory | Out-Null }

$repo = $psscriptroot
$newReplayPath = "C:\Users\$env:username\AppData\Roaming\Replays" 

switch ( $env:username )
{
    "Paul" { $repo = $repo -replace ("MiscScripts", "Replays\Paul")   }
    "Leo"{ $repo = $repo -replace ("MiscScripts", "Replays\Leo")   }
    "Aidan" { $repo = $repo -replace ("MiscScripts", "Replays\Aidan")   }
    "BAMBUUS CHONK" { $repo = $repo -replace ("MiscScripts", "Replays\Darren") }
    
}

write-host "Local repo: $repo" -f yellow
Write-Host "Copying replays to $newReplayPath and renaming" -f yellow

get-childitem -path "C:\Users\$env:username\Documents\TrackMania\Tracks\Replays\Autosaves" | Copy-Item -Destination $newReplayPath -Force


$items = get-childitem $newReplayPath | Sort-Object name

foreach ($item in $items) {
    
    $modifiedFileName = $item.name.Split("-")[0]
    $modifiedFileName += ".gbx"
    Rename-item $item.FullName -NewName $modifiedFileName

}

##########################################

$files = Get-ChildItem $newReplayPath -ErrorAction SilentlyContinue

Write-Host "Copying files to $repo" -f yellow

foreach($file in $files){
    
    Write-Host "Copying $($file.name)" -f Green
    Copy-item $file.FullName -Destination $repo -Force

}

pause
exit