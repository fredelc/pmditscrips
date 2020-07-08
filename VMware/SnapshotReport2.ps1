#Firstly, generate todays date and store in a variable
$date = (get-date -Format d/M/yyyy)
$FileDate = (Get-Date -Format yyyMMdd)
 
#Import the PowerCLI module and setup the credentials to connect to VI servers
Import-Module -Name VMWare.PowerCLI
$PasswordFile = "C:\Scripts\Snapshots\cred.txt"
$securePassword = Get-Content $PasswordFile | ConvertTo-SecureString
$Credentials = New-Object System.Management.Automation.PSCredential ("<Username>", $securePassword)
 
#This is where the styling for the HTML report is done
$styles = @"
<style>
body {   font-family: 'Helvetica Neue', Helvetica, Arial;
        font-size: 14px;
        line-height: 20px;
        font-weight: 400;
        color: black;
   }
table{
 margin: 0 0 40px 0;
 width: 100%;
 box-shadow: 0 1px 3px rgba(0,0,0,0.2);
 display: table;
 border-collapse: collapse;
 border: 1px solid black;
 text-align: left;
}
th {
   font-weight: 900;
   color: #ffffff;
   background: black;
  }
td {
   border: 0px;
   border-bottom: 1px solid black
   }
.20 {
   width: 20%;
   }
.40 {
   width: 40%;
   }
</style>
"@
 
#Setup the header for the HTML report
$report = $report = "<!DOCTYPE html><html><head>$Styles<title>VMWare Snapshot Report</title></head><body>"
 
#Connect to Server
Connect-VIServer -Server ServerName -Credential $Credentials
$report += "<h1>Snapshot Report for $date</h1><table><th>VM Name</th><th>Description</th><th>Date Created</th><th>Created By</th>"
$Snap = Get-VM | Get-Snapshot | Select-Object Description, Created, VM, SizeMB, SizeGB
 
foreach ($snap in Get-VM | Get-Snapshot)
    {
        $snapevent = Get-VIEvent -Entity $Snap.VM -Types Info -Finish $Snap.Created -MaxSamples 1 | Where-Object {$_.FullFormattedMessage -imatch 'Task: Create virtual machine snapshot'
    }
    if ($snapevent -ne $null)
    {
        $sVM = $Snap.VM
        $sDesc = $Snap.Description
        $sDate = $Snap.Created
        $sUser = $snapevent.UserName
       
        if ($sUser -eq "Domain\Username")
            {
                $report += "<tr style='background-color:MediumSeaGreen; color: white;'><td>$sVM</td><td>$sDesc</td><td>$sDate</td><td>$sUser</td></tr>"
            } else {
                $report += "<tr style='background-color:orange; color: white;'><td>$sVM</td><td>$sDesc</td><td>$sDate</td><td>$sUser</td></tr>"
            }
    } else {
 
        $sVM = $Snap.VM
        $sDesc = $Snap.Description
        $sDate = $Snap.Created
        $sUser = $snapevent.UserName
 
        if ($sDesc -eq "Please do not delete this snapshot. It is being used by Veeam Backup.")
        {
            $report += "<tr style='background-color:MediumSeaGreen; color: white;'><td>$sVM</td><td>$sDesc</td><td>$sDate</td><td>$sUser</td></tr>"
        } else {
            $report += "<tr><td>$sVM</td><td>$sDesc</td><td>$sDate</td><td>$sUser</td></tr>"
        }
    }
    }
$report += "</table>"
Disconnect-VIServer -Server bpvcent01.hostdomau.local -Confirm:$false
 
#Close out the report HTML code and export to file
$report += "</body></html>"
$report | Out-File "C:\Reports\Snapshots\Snapshot Report.html"
 
#Email Stuff
$AdminName = 'email@domain.com'
$Pass = Get-Content "C:\Scripts\Snapshots\emcred.txt" | ConvertTo-SecureString
$smtpcred = new-object -TypeName System.Management.Automation.PSCredential -ArgumentList $AdminName, $Pass
 
#This sets up the other settings for the email such as recipient
$ToAddress = 'recipient@domain.com'
$FromAddress = 'email@domain.com'
$SmtpServer = '<SMTP server>'
$SmtpPort = '587'
$Attachments = "C:\Reports\Snapshots\Snapshot Report.html"
 
#Mail parameters
$mailparam = @{
    To = $ToAddress
    From = $FromAddress
    Subject = 'Daily VMWare Snapshot Report for ' + $Date
    Body = 'Daily VMWare Snapshot Report'
    SmtpServer = $SmtpServer
    Port = $SmtpPort
    Credential = $smtpcred
    Attachments = $Attachments
}
 
#BENEATH COMMAND PULLS ALL OF THE INFO FROM PART 3 TO CREATE AN EMAIL+ ADD ATTACHMENT WITH WILDCARD FOR TIME AND DATE
Send-MailMessage @mailparam -UseSsl
 
Remove-Item -Path 'C:\Reports\Snapshots\Snapshot Report.html'