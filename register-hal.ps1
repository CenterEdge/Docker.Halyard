# For instructions on use, see https://github.com/CenterEdge/Docker.Halyard

function hal {
	Param(
		[parameter(ValueFromRemainingArguments=$true)]
		[object[]]
		$args
	)
	
	if (-not ((docker volume ls -q) -contains "halyard")) {
		Out-Host "Creating Halyard volume..."
		& docker volume create halyard
	}
	
	if ($args -ne $null -and $args[0] -eq "start") {
		& docker run -d --rm -v ${HOME}/.kube:/home/halyard/.kube:ro -v halyard:/home/halyard/.hal -v ${HOME}/.halbackups:/home/halyard/halbackups --name halyard centeredge/halyard
	} elseif ($args -ne $null -and $args[0] -eq "stop") {
		& docker stop halyard
	} elseif ($args -ne $null -and $args[0] -eq "backup" -and $args[1] -eq "create") {
		$output = (& docker exec -it halyard /bin/bash /usr/local/bin/hal $args)
		$output # Print the output that was captured
		
		if ($LASTEXITCODE -eq 0) {
			$fileLocation = $output | where { $_.StartsWith("/home/halyard/") }
			$fileLocation = $fileLocation -replace '\x1b\[\d+m', ''
		
			if ($fileLocation -ne "") {
				& docker exec halyard mv $fileLocation /home/halyard/halbackups/$($fileLocation -split '/' | select -last 1)
			}
		}
	} else {
		& docker exec -it halyard /bin/bash /usr/local/bin/hal $args
	}
}