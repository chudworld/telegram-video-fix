# telegram-video-fix
determines and reencodes the audio of .mp4 files from Telegram to allow playback on chromium (chrome, brave ...)

Chromium has a bug where it will not play videos that contain AAC audio witzh the HE-AACv2/HE-AAC/LC Profile. 
Telegram on the other hand uses that as a default for when they reencode a for their platform.

For easy access you can add a shortcut to:
%appdata%\Roaming\Microsoft\Windows\SendTo

This way you can simply select all files you want to process and use windows' SendTo functionality.

Requirements:
- Windows with Powershell
- ffmpeg + ffprobe in PATH
- If you use the .ps1 script instead of the .exe, you will have to change the execution policy in powershell with admin permissions
  >> Set-ExecutionPolicy RemoteSigned
