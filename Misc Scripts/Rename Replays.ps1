$path = "" # this should not be the autosave directory, it should be a copy of files
$items = get-childitem $path | sort name

foreach($item in $items){

    $inputString = $item.name    

    $pattern = "(?<=_)(.*?)(?=-)"

    $newName = $inputString | Select-String -Pattern $pattern | ForEach-Object { $_.Matches.Value }

    $newName += ".gbx"

    Rename-item $item.FullName -NewName $newname

}

