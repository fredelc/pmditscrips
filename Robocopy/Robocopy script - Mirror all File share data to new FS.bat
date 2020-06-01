
robocopy "\\pmsvrfile1\User_Shares" "E:\User_Shares" /e /MIR /COPY:DATSOU /DCOPY:T /r:1 /w:5 /log+:"C:\Robocopy_Logs\robocopy-%date%.log" /V /tee

pause