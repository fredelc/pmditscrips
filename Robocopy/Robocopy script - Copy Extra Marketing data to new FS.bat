
robocopy "\\pmsvrfile1\User_Shares" "E:\Marketing" /e /MIR /COPY:DATSOU /DCOPY:T /r:1 /w:5 /log+:"C:\Robocopy_Logs\robocopy_Marketing-%date%.log" /V /tee

pause