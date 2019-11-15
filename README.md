## Kickstart file generator for CentOS 6 7 8
### Version:
#### CentKS: generate kickstart file, send to sftp server, send to Telegram group
* deploy.sh - deploy ks to sftp server
* deploy_eof.sh - deploy ks to sftp server (heredoc)
* telegram.sh - sending to Telegram group
#### CentKS_local: local kickstart generation, in case of generation processed on the same server where locates storage for kickstart files
#### CentKS_mono: same as CentKS but sftp upload function included to body of the main script
##### Required: at, pwgen, sshpass, sftp need to be installed
