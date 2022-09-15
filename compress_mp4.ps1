$ffmpeg_bin = (Get-Item -Path .\ffmpeg_path.txt | Get-Content -Tail 1)

$outputFolder = "./output/"
$numberOfFiles = 0

[System.IO.DirectoryInfo]$file = $ffmpeg_bin

Measure-Command {
	if((Test-Path -path $file -PathType Leaf)){
		echo "ffmpeg executable found at path: " $ffmpeg_bin
		#Start-Process -Wait -NoNewWindow $ffmpeg_bin | Out-String
		if(!(Test-Path $outputFolder))
		{
			New-Item $outputFolder -ItemType Directory
		}
		Get-ChildItem -Path .\ -Filter *.mp4 -File -Name| ForEach-Object {
			#[System.IO.Path]::GetFileNameWithoutExtension($_)
			$currentFileName = $_
			$ffmpegProcessOptions = @{
				FilePath = $ffmpeg_bin
				#RedirectStandardInput = "TestSort.txt"
				#RedirectStandardOutput = "Sorted.txt"
				#RedirectStandardError = "SortError.txt"
				#UseNewEnvironment = $true
				NoNewWindow = $true
				Wait = $true
				# ffmpeg -i input.mp4 -vcodec libx265 -crf 28 output.mp4
				ArgumentList = @(
					"-i",
					$currentFileName, #input file name
					"-vcodec libx265 -crf 28",
					($outputFolder+$currentFileName)
				)
			}
			echo $outputFolder+$currentFileName
			Start-Process @ffmpegProcessOptions
			$numberOfFiles = $numberOfFiles + 1
			#Start-Process -Wait -NoNewWindow $ffmpeg_bin [-ArgumentList]  | Out-String
			
		}
	}else{
		echo "No executable found at: " + $ffmpeg_bin
		echo "Please, add a valid path at the end of .\ffmpeg_path.txt"
	}
}

echo 'Output folder' + $outputFolder
echo 'Number of processed files: '+$numberOfFiles
Read-Host -Prompt "Press any key to close the window"