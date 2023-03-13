#get current dir
$here = (Get-Location).Path

#find all ps1 files in the dir
$PSFiles = Get-ChildItem -Path $($here+"\") -Recurse -Name *.ps1 |
ForEach-Object { $here+"\"+ $_}

#find all json files in the dir
$JsonFiles = Get-ChildItem -Path $($here+"\") -Recurse -Name *.json |
ForEach-Object { $here+"\"+ $_}

#Start testing
Describe 'Overall Tests' {
    Context 'PS1 tests'{
        foreach($ps1 in $PSFiles)
        {
            if($PS1 -like "*Modules\Az.*")
            {
                continue
            }
            It "$ps1 is valid PowerShell code" {
                $PSFileContent = Get-Content -Path $ps1 -ErrorAction Stop
                $errors = $null
                $null = [System.Management.Automation.PSParser]::Tokenize($PSFileContent, [ref]$errors)
                $errors.count | Should Be 0
            }
        }
    }
    Context 'JSON tests'{
        foreach($json in $JsonFiles)
        {
            It "$json is valid JSON code" {
                $jsonContent = Get-Content -Path $json -ErrorAction Stop
                $jsonContent | ConvertFrom-Json | Should Not Be $null
            }
        }
    }
  }