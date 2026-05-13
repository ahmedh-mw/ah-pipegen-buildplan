Get-Content (Get-PSReadlineOption).HistorySavePath | Where-Object { $_ -like "git remote*" }

git remote set-url origin git@github.com:ahmedh-mw/ah-pipegen-buildplan.git
git remote set-url origin git@insidelabs-git.mathworks.com:ahmedh/ah-pipegen-buildplan.git
git remote set-url origin git@ssh.dev.azure.com:v3/ahmedh-mw/Pipeline_Generation/ah-pipegen-buildplan