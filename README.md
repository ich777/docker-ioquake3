# ioquake3 Server in Docker optimized for Unraid
This Docker will download and install ioquake3 Server (You have to copy your pak0.pk3 file from your game directory to your server).

PK3 Files: After the container started the first time you have to copy your pak0.pk3 file from your Quake III Arena directory into your server directory: .../.q3a/baseq3/ (i strongly recommend you to place all your pak*.pk3 files into it) after that simply restart the container to start the server.

>**WEB CONSOLE:** You can connect to the ioquake3 console by opening your browser and go to HOSTIP:9029 (eg: 192.168.1.1:9029) or click on WebUI on the Docker page within Unraid.


## Env params
| Name | Value | Example |
| --- | --- | --- |
| DATA_DIR | Folder for gamefile | /ioquake3 |
| GAME_PARAMS | The startup parameters for the server (only change if you know what you are doing!) | +set dedicated 2 +set sv_allowDownload 1 +set com_hunkmegs 64 |
| IOQ3_PORT | The ioquake3 Server base port | 27960 |
| Q3_MAP | The prefered startup map | q3dm1 |
| DL_URL | Only change if you know what you're doing! | https://files.ioquake3.org/Linux.zip |
| DL_URL_PATCH | Only change if you know what you're doing! | https://files.ioquake3.org/quake3-latest-pk3s.zip |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |
| UMASK | User file permission mask for newly created files | 000 |
| DATA_PERM | Data permissions for main storage folder | 770 |

## Run example
```
docker run --name ioquake3 -d \
	-p 27960:27960/udp -p 9029:8080 \
	--env 'GAME_PARAMS=+set dedicated 2 +set sv_allowDownload 1 +set com_hunkmegs 64' \
	--env 'IOQ3_PORT=27960' \
	--env 'Q3_MAP=q3dm1' \
	--env 'DL_URL_PR=https://files.ioquake3.org/Linux.zip' \
	--env 'DL_URL_PATCH=https://files.ioquake3.org/quake3-latest-pk3s.zip' \
	--env 'UID=99' \
	--env 'GID=100' \
	--env 'UMASK=000' \
	--env 'DATA_PERM=770' \
	--volume /path/to/ioquake3:/ioquake3 \
	ich777/ioquake3
```

This Docker was mainly edited for better use with Unraid, if you don't use Unraid you should definitely try it!

#### Support Thread: https://forums.unraid.net/topic/79530-support-ich777-gameserver-dockers/
