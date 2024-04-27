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
echo "This script will only test from .1 to .254 of a given IPv4 network." | Write-Host -ForegroundColor Cyan
echo "Will end in about 10min." | Write-Host -ForegroundColor Cyan
echo ""

$userInputNetwork = Read-Host "Network to scan [192.168.0.0]"
$userInputFile = Read-Host "Do you want to send result in a file ? [y/N]"
$dateTime = Get-Date -Format "yyyy-MM-dd-HH-mm-ss"


function Test-NetworkIPs {
    while($ip -ne 254) {

    		$ip++

		$networkIp="$network.$ip"

		if (Test-Connection $networkIp -Delay 1 -Count 1 -Quiet) {
			"Testing : $networkIp --->		True" | Write-Host -ForegroundColor Green
		} else {
			"Testing : $networkIp --->		False" | Write-Host -ForegroundColor Red
		}
	}
}


function Display-Results {
	if ($userInputNetwork) {
		$network = ($userInputNetwork -split "\.")[0..2] -join "."	

		echo ""
		echo "Testing network : $userInputNetwork" | Write-Host -ForegroundColor Yellow
		
		Test-NetworkIPs
	} else {
		$network = "192.168.0"

		echo ""
		echo "Testing default network : 192.168.0.0" | Write-Host -ForegroundColor Yellow
	
		Test-NetworkIPs
	}
}


if ($userInputFile -eq "Y" -Or $userInputFile -eq "y" -Or $userInputFile -eq "yes") {

	$resultsFile = "multi-ping-$dateTime.txt"
	
	echo ""
	echo "Results will be sent to $resultsFile" | Write-Host -ForegroundColor Yellow
	
	Start-Transcript -Path $resultsFile -NoClobber
	
	Display-Results

	Stop-Transcript

} else {
	echo ""
	echo "Results will be not be saved." | Write-Host -ForegroundColor Yellow

	Display-Results
}
