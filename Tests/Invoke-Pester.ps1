#get current dir
$here = (Get-Location).Path

#find all ps1 files in the dir
$PSFiles = Get-ChildItem -Path $($here+"/Tests/") -Recurse -Name *.ps1 |
ForEach-Object { $here+"/"+ $_}

#find all json files in the dir
$JsonFiles = Get-ChildItem -Path $($here+"/Tests/") -Recurse -Name *.json |
ForEach-Object { $here+"/"+ $_}

#Start testing
Describe 'Overall Tests' {
    Context 'PS1 tests'{
            It "$ps1 is valid PowerShell code" {
                $ps1 = $here + "\FunctionApp\run.ps1"
                $PSFileContent = Get-Content -Path $ps1 -ErrorAction Stop
                $errors = $null
                $null = [System.Management.Automation.PSParser]::Tokenize($PSFileContent, [ref]$errors)
            }
    }
}