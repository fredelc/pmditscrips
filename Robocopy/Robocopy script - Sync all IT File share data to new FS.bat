
robocopy "\\pmsvrfile1\User_Shares\IT" "E:\User_Shares\IT" /e /XO /COPY:DATSOU /DCOPY:T /r:1 /w:5 /log+:"C:\Robocopy_Logs\robocopy-%date%-2.log" /V /tee

robocopy "E:\User_Shares\IT" "\\pmsvrfile1\User_Shares\IT" /e /XO /COPY:DATSOU /DCOPY:T /r:1 /w:5 /log+:"C:\Robocopy_Logs\robocopy-%date%-2.log" /V /tee

pause