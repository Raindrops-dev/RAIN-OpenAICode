# RAIN-OpenAICode

# PowerShell Script for Automating ChatGPT API

This script is written to automate polling the OpenAI's ChatGPT API for the purpose of asking PowerShell commands. With this script, you can quickly get answers to your PowerShell questions without having to manually make API requests.

## How to Run the Script

1. Add your API key to a `openai.json` file based on the `openai.json.example` file.
2. Run the script with the `-Command` parameter to provide the command you'd like to request.

Example:

    .\Get-AIPowershellCommand.ps1 -Command "Command to list all permissions of a fileshare"
    Time to get a response from OpenAI: 18.4290256 seconds
    Your query was:
    Powershell script to scan recursively all subfolders of a network share and get the non-inherited permissions
    The response from OpenAI was:
    Get-ChildItem -Path \\network\share -Recurse | Get-Acl | Select-Object -ExpandProperty Access | Where-Object { $_.IsInherited -eq $false }
    WARNING: Do you want to execute this command? [y/n]:
    Executing command...

This will return the result of the requested PowerShell command, as generated by the OpenAI API and it will ask you if you want to run it. Press y to run or n to not run.

Enjoy the convenience of having your PowerShell questions answered automatically!

P.S: Verify carefully before actually running any code it provides...
