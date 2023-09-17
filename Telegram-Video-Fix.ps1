$AbortScript = 0

if ((Get-Command "ffprobe" -ErrorAction SilentlyContinue) -eq $null) { 
   Write-Host "Unable to find ffprobe in your PATH"
   $AbortScript = 1
}

if ((Get-Command "ffmpeg" -ErrorAction SilentlyContinue) -eq $null) { 
   Write-Host "Unable to find ffmpeg in your PATH"
   $AbortScript = 1
}

if ($AbortScript -eq 1) {
	Read-Host -Prompt "Press Enter to exit"
	Exit
}

If ($Args.count -eq 0) {
  
    "No Files were passed from File Explorer."
    Read-Host -Prompt "Press Enter to exit"
    Exit
  }
  Else {
    $Files = $Args
	
	$Total = $Files.Length
	$i = 1
	foreach ($File in $Files) {
		$extn = [IO.Path]::GetExtension($File)
		if ($extn -eq ".mp4") {
			$File = [Management.Automation.WildcardPattern]::Escape($File)
			$probe = [String](& ffprobe -hide_banner -select_streams a:0 "$File" 2>&1)
			if ($probe -notlike "*HE-AACv2*") {
				"[$i/$Total] Skipped: $File (healthy)"
			} Else {
			$FileName = Split-Path $File -leaf
			$FolderPath = Split-Path $File -Parent
			$FolderPath = $FolderPath + "\"
			$FileNameNoextn = [System.Io.Path]::GetFileNameWithoutExtension($File)
			$Spacer = "_"
			$Counter = 1
			"[$i/$Total] Processing $FileName"
			$TempFile = $FolderPath + $FileNameNoextn + "_" + $Counter + $extn
			while ([System.IO.File]::Exists($TempFile)) {
				$Counter = $Counter + 1
				$TempFile = $FolderPath + $FileNameNoextn + "_" + $Counter + $extn
			}
			ffmpeg -hide_banner -loglevel panic -i "$File" -c:v copy "$TempFile"
			Remove-Item "$File"
			Rename-Item -Path "$TempFile" -NewName "$FileName"
			}
		} else {
			"[$i/$Total] Skipped: $File (no .mp4)"
		}
		$i = $i + 1
	}
  }
Read-Host -Prompt "Press Enter to exit"
Exit