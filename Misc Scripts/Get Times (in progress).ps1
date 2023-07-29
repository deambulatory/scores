Clear-Host
$files = Get-ChildItem "C:\Users\$env:username\Desktop\Replays" -ErrorAction SilentlyContinue
if (test-path C:\Users\$env:username\Desktop\times.txt) { remove-item C:\Users\$env:username\Desktop\times.txt }

if ($files.Count -eq 0) { 

    Write-Host "No replays found... run Rename Replays.ps1 script first" -f Red
    pause
    exit

}

foreach ($file in $files) {

    $content = get-content $file.FullName

    $pattern = 'times best="(\d+)"'

    $matches = [regex]::Matches($content, $pattern)

    $number = $matches[0].Value  | Select-String -Pattern '\d+' -AllMatches | ForEach-Object { $_.Matches } | ForEach-Object { $_.Value }
    
    $numberAsString = $number.ToString()
    $numberWithoutLastDigit = [int]($numberAsString.Substring(0, $numberAsString.Length - 1))

    if ($numberWithoutLastDigit.ToString().Length -eq 4) {

        $firstTwoNumbers = $numberWithoutLastDigit.ToString().Substring(0, 2)
     
        if ($firstTwoNumbers -gt 59) { 
     
            $minutes = [math]::DivRem($firstTwoNumbers, 60, [ref]$null)
            $seconds = $firstThreeNumbers % 60

            write-Host "$($file.name) $minutes minutes and $seconds seconds"

        }

    }

    if ($numberWithoutLastDigit.ToString().Length -eq 5) {

        $firstThreeNumbers = $numberWithoutLastDigit.ToString().Substring(0, 3)
     
        $minutes = [math]::DivRem($firstThreeNumbers, 60, [ref]$null)
        $seconds = $firstThreeNumbers % 60

        write-Host "$($file.name) $minutes minutes and $seconds seconds"

    }

    
    $number1 = "{0:N2}" -f ($numberWithoutLastDigit / 100)

    if ($number1.ToString().Length -eq 4) {
       
  
        $string = $number1.ToString()
        $number1 = $string.PadLeft(5, "0")   
    }
    
    if ($number1.ToString().Length -eq 5) {      
  
        $number1 = "00:" + $number1
   
    }

    $Object = [PSCustomObject]@{
        'Track' = $file.name -replace ".gbx", ""
        'Time'  = $number1
    }

    $Object | export-csv "C:\Users\$env:username\Desktop\times.txt" -Append -nti

}

