
robocopy "\\pmsvrfs1\User_Shares\Finance" "\\pmsvrpastel1\d$\Finance" /e /MIR /COPY:DATSOU /DCOPY:T /r:1 /w:5 /log+:"C:\Robocopy_Logs\Finance-%date%.log" /V /tee

pause