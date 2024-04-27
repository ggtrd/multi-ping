# MIT License
# 
# Copyright (c) 2023 Geoffrey Gontard
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.



echo ""
echo "This script will continuously test a given range of IPv4 addresses." | Write-Host -ForegroundColor Cyan
echo ""


$userInputIpFirst = Read-Host "First IP to scan"
$userInputIpLast = Read-Host "Last  IP to scan"
$userInputFile = Read-Host "Do you want to send result in a file ? [y/N]"
$dateTime = Get-Date -Format "yyyy-MM-dd-HH-mm-ss"

[int]$ipFirst = ($userInputIpFirst -split "\.")[3] -join "."
[int]$ipLast = ($userInputIpLast -split "\.")[3] -join "."



function Test-NetworkIPs-Infinite {
	while($true) {
    		$ip++
	
		Test-NetworkIPs 
	}	
}


function Test-NetworkIPs {
	$ip = $ipFirst - 1
	while($ip -ne $ipLast) {

    		$ip++

		$networkIp="$network.$ip"
		
		$testTime = Get-Date -Format "yyyy/MM/dd HH:mm:ss"

		if (Test-Connection $networkIp -Delay 1 -Count 1 -Quiet) {
			"$testTime | Testing : $networkIp --->		True" | Write-Host -ForegroundColor Green
			Start-Sleep -Seconds 1
		} else {
			"$testTime | Testing : $networkIp --->		False" | Write-Host -ForegroundColor Red
		}
	}
}


function Display-Results {
	if ($userInputIpFirst) {
		$network = ($userInputIpFirst -split "\.")[0..2] -join "."	

		echo ""
		echo "Testing range : $userInputIpFirst - $userInputIpLast" | Write-Host -ForegroundColor Yellow
		
		Test-NetworkIPs-Infinite
	} else {
		echo "Please enter a valid range" | Write-Host -ForegroundColor Yellow
	}
}


if ($userInputFile -eq "Y" -Or $userInputFile -eq "y" -Or $userInputFile -eq "yes") {

	$resultsFile = "multi-ping-infinite-$dateTime.txt"
	
	echo ""
	
	Start-Transcript -Path $resultsFile -NoClobber | Write-Host -ForegroundColor Yellow
	
	Display-Results

	Stop-Transcript

} else {
	echo ""
	echo "Results will be not be saved." | Write-Host -ForegroundColor Yellow

	Display-Results
}
