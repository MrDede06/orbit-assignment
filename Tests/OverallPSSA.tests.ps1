#get current dir
$here = (Get-Location).Path
Describe 'Testing against PSSA rules' {
    $PSFiles = Get-ChildItem -Path $($here+"\Tests\") -Recurse -Name *.ps1 | ForEach-Object { $here+"\Tests\" + $_ }
    foreach ($PS1 in $PSFiles) {
        Context "PSSA Standard Rules - file: $PS1" {
            $analysis = Invoke-ScriptAnalyzer -Path $PS1
            $scriptAnalyzerRules = Get-ScriptAnalyzerRule
            foreach ($rule in $scriptAnalyzerRules) {
                #explicitly skipping PSAvoidUsingConvertToSecureStringWithPlainText for specific files file since it is not possible to code it differently
                $filesToSkipConvertToSecureString = @("run.ps1")
                if($PS1 -like "*Modules\Az.*")
                {
                    continue
                }
                if($rule.RuleName -eq 'PSAvoidUsingConvertToSecureStringWithPlainText' -and $filesToSkipConvertToSecureString -contains $PS1.split("\")[-1])
                {
                    continue
                }
                It "Should pass $rule" {
                    If ($analysis.RuleName -contains $rule) {
                        $analysis |
                            Where-Object RuleName -EQ $rule -outvariable failures |
                            Out-Default
                            $failures.Count | Should Be 0
                    }
                }
            }
        }
    }
}