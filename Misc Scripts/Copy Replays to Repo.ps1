# Copy replays to desktop and rename the files
#############################################
Clear-Host
$repo = $PSScriptRoot
$repo = $repo -replace ("Misc Scripts", "replays")
write-host "$repo"

if (test-path C:\Users\$env:username\desktop\Replays) { 

    Write-Host "Replay folder on desktop already exists, delete this and run the script again" -f Red
    pause
    exit

}

$path = "C:\Users\$env:username\desktop\Replays"
copy-item -path "C:\Users\$env:username\Documents\TrackMania\Tracks\Replays\Autosaves" -Recurse -Destination $path 
$items = get-childitem $path | Sort-Object name

foreach ($item in $items) {
    
    $modifiedFileName = $item.name.Split("-")[0]
    $modifiedFileName += ".gbx"
    Rename-item $item.FullName -NewName $modifiedFileName

}

##########################################

$files = Get-ChildItem "C:\Users\$env:username\Desktop\Replays" -ErrorAction SilentlyContinue

foreach($file in $files){

    Copy-item $file.FullName -Destination $repo -Force -Verbose

}


