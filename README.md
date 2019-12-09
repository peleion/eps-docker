# eps-docker 
A Docker container for Chris Belcher's excellent Electrum Personal Server based on Debian Buster:

https://github.com/chris-belcher/electrum-personal-server

This container uses a persistent docker volume which contains the configuration file and sample - this is the /srv directory within the container. 

STEPS TO RUN EPS

1. BITCOIND: Ensure your bitcoind (in a separate container) is running, fully synced, wallet enabled and you have set an RPC user and password in your bitcoin.conf. The default docker0 network isolates containers from each other - you must create a new docker network so these containers will be able to communicate. A suitable command to accomplish this would be:

   `docker network create -o "com.docker.network.bridge.name"="crypto" crypto`

2. CONFIGURATION: The default configuration is to serve a single wallet (xpub/ypub/zpub) by passing a few environment variables without manual configuration. No user changes are needed if you want to use this basic configuration and it also works with BTCPay. The variables only need to be passed on initial startup when they are hardcoded into the config.ini file - alternately you could modify config.ini directly. The variables are:

```
      HOST: <your_bitcoind_container_name>
      PORT: <your_bitcoind_container_port>
      RPC_USER: <your_bitcoind_rpc_username>
      RPC_PASSWORD: <your_bitcoind_rpc_password>
      XPUB: <your_xpub> 
```
3. ADVANCED (OPTIONAL): If you want to use more advanced configuration options available in EPS you can manually change the config.ini in the persistent volume - the sample file is there also. Any non-default (LetsEncrypt or other public) TLS certificates should be placed in the persistent volume as well. You should NOT use the default TLS certificates if you plan on exposing EPS to the internet as anyone could then decrypt your communication. To use advanced options start the container without any arguments (it won't run but will create the persistent volume) and modify/add the appropriate files - EPS will pick up the changes when restarted. Remember your Electrum wallet will not connect to EPS if you have previously connected to the same DNS name unless you remove the old TLS certificate from Electrum's cache. 

4. FIRST RUN: When first starting the container for the fist time bitcoind will load the addresses from your xpub (2,000 by default) and exit when finished. This may take up to 30 minutes.

5. WALLET RESCAN: When restarted (automatically if you called the container with that option) bitcoind will rescan the entire blockchain from origin to pick up any existing transactions in your wallet. This can take several hours - monitor the bitcoind container logs for progress.

When these steps are complete EPS will start up normally and should begin serving your wallet within a few minutes. These steps are only needed when initializing the container for the first time and should not need to be repeated unless you add/remove/change your wallet. You can force steps 4 or 5 at any time by touching an empty file .firstrun or .rescan in the persistent volume.

A sample docker-compose.yml is included - you should adapt it to your needs.
