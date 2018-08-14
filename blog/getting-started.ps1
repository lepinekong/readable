add-type -AssemblyName microsoft.VisualBasic
add-type -AssemblyName System.Windows.Forms
start-sleep -Milliseconds 500
[Microsoft.VisualBasic.Interaction]::AppActivate("getting-started.red") 
    
start-sleep -Milliseconds 500
[System.Windows.Forms.SendKeys]::SendWait('Red [{ENTER}')

start-sleep -Milliseconds 500
[System.Windows.Forms.SendKeys]::SendWait('Title: "getting-started.red"')

start-sleep -Milliseconds 1000
[System.Windows.Forms.SendKeys]::SendWait('{DOWN}{DOWN}{ENTER}')

start-sleep -Milliseconds 500
[System.Windows.Forms.SendKeys]::SendWait('{ENTER}')

start-sleep -Milliseconds 500
[System.Windows.Forms.SendKeys]::SendWait('Tutorial: [{ENTER}')

start-sleep -Milliseconds 500
[System.Windows.Forms.SendKeys]::SendWait('Title: {{}Getting Started{}}{ENTER}')

start-sleep -Milliseconds 500
[System.Windows.Forms.SendKeys]::SendWait('Sub-title: {{}Step by Step{}}{ENTER}')

start-sleep -Milliseconds 500
[System.Windows.Forms.SendKeys]::SendWait('{ENTER}Step-1: [{ENTER}')

start-sleep -Milliseconds 500
[System.Windows.Forms.SendKeys]::SendWait('.title: {{}Install Red{}}')

start-sleep -Milliseconds 500
[System.Windows.Forms.SendKeys]::SendWait('^+{END}')

start-sleep -Milliseconds 1000
[System.Windows.Forms.SendKeys]::SendWait('{DOWN}{ENTER}')

start-sleep -Milliseconds 500
[System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
start-sleep -Milliseconds 500
[System.Windows.Forms.SendKeys]::SendWait('do https://readable.red{ENTER}')
start-sleep -Milliseconds 500
[System.Windows.Forms.SendKeys]::SendWait('markdown-gen{ENTER}')


