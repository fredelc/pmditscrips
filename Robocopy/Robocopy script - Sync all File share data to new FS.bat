
robocopy "\\pmsvrfile1\User_Shares" "E:\User_Shares" /e /XO /COPY:DATSOU /DCOPY:T /r:1 /w:5 /log+:"C:\Robocopy_Logs\robocopy-%date%-9.log" /V /tee

robocopy "E:\User_Shares" "\\pmsvrfile1\User_Shares" /e /XO /COPY:DATSOU /DCOPY:T /r:1 /w:5 /log+:"C:\Robocopy_Logs\robocopy-%date%-10.log" /V /tee

pause