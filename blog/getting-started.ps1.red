Red [
    Title: ""
]

code-block: copy [
    {
add-type -AssemblyName microsoft.VisualBasic
add-type -AssemblyName System.Windows.Forms
start-sleep -Milliseconds 500
[Microsoft.VisualBasic.Interaction]::AppActivate("getting-started.red")        
    }
]

red-block: read/lines %getting-started.0.red
forall red-block [
    append code-block {start-sleep -Milliseconds 500}
    append code-block rejoin [{[System.Windows.Forms.SendKeys]::SendWait('} red-block/1 {{ENTER}} {')}] 
]

code: copy ""
forall code-block [
    code: rejoin [code newline code-block/1]
]

write-clipboard code
