
robocopy "\\172.16.1.161\Jobs Disk" "\\pmsvrfs1\e$\Marketing" /e /MIR /COPY:DAT /DCOPY:T /r:1 /w:5 /log:"C:\Robocopy_Logs\Marketing_30Mar2017.log" /V /tee

pause