# eps-docker

A Docker container for Electrum personal server based on Debian Buster:

https://github.com/chris-belcher/electrum-personal-server

This container uses a docker volume for /usr/local/etc/electrum-personal-server which contains the config.cfg along with the sample. It is set up to run with a bitcoind running in a separate container. The default docker0 network isolates containers from each other - you must create a new docker network so these containers will be able to communicate with each other.

You should follow these steps to initialize the container:

1. Run the container to create the docker volume
2. Stop the container and edit config.cfg adding your wallet xpub keys and the location/credentials of your bitcoind container. Any non default (LetsEncrypt or other public) SSL certs should go in the volume as well since it is the only data that persists between container restarts.
3. Start the container again. It will load the wallet addresses into the bitcoind wallet and can take a long time - you can monitor your bitcoind logs for progress.
4. If your wallet has any existing transactions you will have to again shut down the container and run the eps-rescan script to pick up these transactions - You MUST modify it for your specific setup first. This takes approximately one hour to rescan each 2,000 address Electrum wallet from genesis and will exit when done.
5. You may have to restart the container once again after address importation is finished depending on how you initially started the container. It may take a few minutes for EPS to accept connections - you can monitor the Docker EPS logs for the container.

A sample docker-compose.yml is included - you should adapt it to your needs.
