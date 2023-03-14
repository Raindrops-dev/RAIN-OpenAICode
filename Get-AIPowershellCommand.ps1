<#
.SYNOPSIS
  A PowerShell script that uses OpenAI's GPT-3 API to generate PowerShell commands based on user input.

.DESCRIPTION
  This script uses OpenAI's GPT-3 API to generate PowerShell commands based on user input. The script will prompt the user for input, and then generate a command based on the input. The user can then confirm the command, and the script will execute it.

  The script is based on the example code provided by OpenAI at https://beta.openai.com/docs/developer-quickstart/1-introduction and on the bash version https://github.com/MxDkl/pls by MxDkl.

  The script requires an OpenAI API key, which can be obtained by signing up for an account at https://beta.openai.com/. The API key should be saved in a file called "openai.json" in the same directory as the script. The file should be in JSON format, and should contain a single key-value pair, where the key is "api_key" and the value is the API key.


.PARAMETER command
  The command to generate. If not specified, the script will inform the user that the command is missing.
  
.EXAMPLE
  .\Get-AIPowershellCommand.ps1 "Command to get the list of processes, sorted by name"


.NOTES
    Author: Padure Sergio
    Company: Raindrops.dev
    Last Edit: 2023-03-14
    Version 0.1 Initial functional code
#>
#Defining default parameter
Param(
  [Parameter(Mandatory = $true, Position = 0)]
  [string]$command = "Which commands can I request?"
)

#Clearing the Screen
Clear-Host

#Defining basic variables
$RootDir = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Path)
$ErrorActionPreference = "Stop"

# import the openai api key from a JSON file
$keyJson = Get-Content "$RootDir\openai.json" | ConvertFrom-Json
$token = $keyJson.api_key

#Defining the request body
$RequestBody = [ordered]@{
  "model"    = "gpt-3.5-turbo";
  "messages" = @(
    @{
      "role"    = "system";
      "content" = "You are a helpful assistant. You will generate Windows PowerShell commands based on user input. Your response should contain ONLY the command and NO explanation. Do NOT ever use newlines to seperate commands, instead use ;. The current working directory is $RootDir."
    }, @{
      "role"    = "user";
      "content" = $command
    }
  )
} | ConvertTo-Json -Depth 99

#Defining the request headers
$Headers = [ordered]@{
  "Content-Type"  = "application/json";
  "Authorization" = "Bearer $token"
}

#Doing the API call
$response = Invoke-WebRequest https://api.openai.com/v1/chat/completions -Method POST -Body $RequestBody -Headers $Headers

# echo the 'content' field of the response which is in JSON format
$content = ConvertFrom-Json $response.Content | Select-Object -ExpandProperty choices | Select-Object -ExpandProperty message | Select-Object -ExpandProperty content
Write-Warning "The command to execute is:"
Write-Warning $content

#Ask user to confirm the command
Write-Warning "Do you want to execute the command? [y/n]: "
$key = [System.Console]::ReadKey($true)

# if the user presses n, exit the script
if ($key.KeyChar -eq 'n' -or $key.KeyChar -eq 'N') {
  Write-Host "Aborted." -ForegroundColor Red
  exit 0
}
Write-Output "Executing command..." -ForegroundColor Green
Write-Output ""

#executing the command
Invoke-Expression $content
