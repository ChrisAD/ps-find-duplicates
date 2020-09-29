# ps-find-duplicates
A script which finds duplicates based a needle, or folder of needles, in a haystack of files. 

## Switches
- recurse
   - Should the script explore sub-folders recursively? Switch, turn on and off. 
- needle
   - Which file or files should be used as subjects for duplicates? Can be a file or a folder of files. Not affeced by -Recurse. 
- haystack
   - Which folder to check for needles. Affected by the recurse switch. 
   
  ## Example
  - ./find-duplicate-hashes.ps1 -recurse -needle C:\needle.txt -haystack D:\
