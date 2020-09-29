param(
    [Parameter()][switch]$recurse = $false, 
    [Parameter(Mandatory=$true)][string]$needle, 
    [Parameter(Mandatory=$true)][string]$haystack = "."
    )

<#
.SYNOPSIS
A script which finds duplicates based a needle, or folder of needles, in a haystack of files. 

.PARAMETER recurse
Should the script explore sub-folders recursively? Switch, turn on and off. 

.PARAMETER needle
Which file or files should be used as subjects for duplicates? Can be a file or a folder of files. Not affeced by -Recurse. 

.PARAMETER haystack
Which folder to check for needles. Affected by the recurse switch. 

.EXAMPLE
./find-duplicate-hashes.ps1 -recurse -needle C:\needle.txt -haystack D:\

.LINK
https://gist.github.com/ChrisAD/423ecc87ecb1e8ca05a2750cd45b1b9b
#>

#Needle operations
write-host 'Processing the needle(s).. This might take a while depending on how many files were selected for hashing.'
$needleHash = @()
if ($true -eq (Test-Path -Path $needle -PathType Container)) {
     get-childitem -Recurse $needle -File | ForEach-Object {
        $hash = get-filehash -Algorithm SHA256 -erroraction 'silentlycontinue' -Path $_.FullName
         if ($hash.hash -eq 'E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855') {
            write-host "Skipping empty hash" $hash.Path "("$hash.hash")" -ForegroundColor Yellow
         } else {
            $needleHash += @($hash)    
         }
     }
} else {
    $needleHash += @(get-filehash -Algorithm SHA256 -erroraction 'silentlycontinue' -Path $needle)
}

#Haystack operations
$haystackItems = ''
if ($recurse -eq $true) {
    $haystackItems = get-childitem -Recurse $haystack 
} else {
    $haystackItems = get-childitem $haystack 
}

#Look for needle in haystack
foreach ($hayItem in $haystackItems) {
    $haystackHash = $hayItem | get-filehash -Algorithm SHA256 -erroraction 'silentlycontinue'
    foreach ($h in $needleHash) {
        if ($h.hash -eq $haystackHash.hash) { 
            write-host "Identical files found" -ForegroundColor Yellow
            write-host $hayItem.FullName -ForegroundColor Blue
            write-host $h.Path -ForegroundColor Blue
        }
    }
}
