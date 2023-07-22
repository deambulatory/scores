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
