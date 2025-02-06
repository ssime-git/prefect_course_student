# prefect_course_student

This repo is starter for DataScientest prefect course.

## VS code installation on the VM

You can skip this part but this is simply to have a vscode available for this course.

Please make sure to follow the instructions below: 

1. Fork this repo into your own account
2. Clone the repo on your local machin or your VM
3. Enter the cloned repository: `cd <the-forked-repo>``
4. Update the `.env` file with your VM Ip address :

```sh
VM_IP=34.240.199.59 # change this
WORKSPACE_DIR=./prefect
```
5. Run the command : `make setup`
This command will download and build everything you for you. It can take a couple of minutes. To have the status of the installation, you can use the command `docker logs <container ID>` (you can get the container `lscr.io/linuxserver/code-server` id with the command `docker ps`.)

Wait until you see :

```sh
[2025-02-06T14:31:48.332Z] info  Wrote default config file to /config/.config/code-server/config.yaml
[2025-02-06T14:31:48.937Z] info  code-server 4.96.2 08cbdfbdf11925e8a14ee03de97b942bba7e8a94
[2025-02-06T14:31:48.940Z] info  Using user-data-dir /config/data
[2025-02-06T14:31:48.970Z] info  Using config file /config/.config/code-server/config.yaml
[2025-02-06T14:31:48.970Z] info  HTTP server listening on http://0.0.0.0:8443/
[2025-02-06T14:31:48.971Z] info    - Authentication is enabled
[2025-02-06T14:31:48.971Z] info      - Using password from $PASSWORD
[2025-02-06T14:31:48.971Z] info    - Not serving HTTPS
[2025-02-06T14:31:48.971Z] info  Session server listening on /config/data/code-server-ipc.sock
Connection to 127.0.0.1 8443 port [tcp/*] succeeded!
[ls.io-init] done.
```

6. Then go to `http://<your-vm-ip-address>:8343` and enter the password `password`.

Enjoy 😁 !