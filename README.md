# eps-docker

A Docker container for Electrum personal server based on Debian Buster:

https://github.com/chris-belcher/electrum-personal-server

This container uses a docker volume for /usr/local/etc/electrum-personal-server which contains the config.cfg along with the sample. It is set up to run with a bitcoind running in a separate container. The default docker0 network isolates containers from each other - you must create a new docker network so these containers will be able to communicate with each other.

You should follow these steps to initialize the container:

1. Run the container to create the docker volume
2. Stop the container
3. Edit config.cfg adding your wallet private keys and the location/credentials of your bitcoind container. Any local (non default or public) SSL certs should go in the volume as well since it is the only data that persists between container restarts.
4. Start the container again. It will load the wallet addresses into the bitcoind wallet and can take a long time. It will exit when done.
5. Start the container once again. It may take a few minutes for EPS to accept connections - you can monitor the Docker logs for the container.

A sample docker-compose.yml is included - you should adapt it to your needs.

TODO:

There is also a sample script to run if the wallets you imported into EPS have existing transactions. You MUST modify it for your specific setup. This script will fire up the container, rescan historical transactions, and exit when complete. This can take a long time also.
