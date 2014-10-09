#! /bin/bash

#immage to use
DOCKER_IMAGE_NAME="yanninho/eclipse"

#local workspace
LOCAL_WORKSPACE="[ Your local directory ]"

# local name for the container
DOCKER_CONTAINER_NAME="eclipse"

SSH_KEY_PRIVATE="-----BEGIN RSA PRIVATE KEY-----
	[ Your private key here ]
-----END RSA PRIVATE KEY-----"

# write ssh key to temp. file
SSH_KEY_FILE_PRIVATE=$(tempfile)
echo "${SSH_KEY_PRIVATE}" > ${SSH_KEY_FILE_PRIVATE}

# check if container already present
TMP=$(docker ps -a | grep ${DOCKER_CONTAINER_NAME})
CONTAINER_FOUND=$?

TMP=$(docker ps | grep ${DOCKER_CONTAINER_NAME})
CONTAINER_RUNNING=$?

if [ $CONTAINER_FOUND -eq 0 ]; then

	echo -n "container '${DOCKER_CONTAINER_NAME}' found, "

	if [ $CONTAINER_RUNNING -eq 0 ]; then
		echo "already running"
	else
		echo -n "not running, starting..."
		TMP=$(docker start ${DOCKER_CONTAINER_NAME})
		echo "done"
	fi

else
	echo -n "container '${DOCKER_CONTAINER_NAME}' not found, creating..."
	TMP=$(docker run -d -P -v ${LOCAL_WORKSPACE}:/home/eclipseuser/workspace --name ${DOCKER_CONTAINER_NAME} ${DOCKER_IMAGE_NAME})
	echo "done"
fi

#wait for container to come up
sleep 2

# find ssh port
SSH_URL=$(docker port ${DOCKER_CONTAINER_NAME} 22)
SSH_URL_REGEX="(.*):(.*)"

SSH_INTERFACE=$(echo $SSH_URL | awk -F  ":" '/1/ {print $1}')
SSH_PORT=$(echo $SSH_URL | awk -F  ":" '/1/ {print $2}')

echo "ssh running at ${SSH_INTERFACE}:${SSH_PORT}"

#-i ${SSH_KEY_FILE_PRIVATE}

cat ~/.ssh/id_rsa.pub | ssh -p ${SSH_PORT} eclipseuser@${SSH_INTERFACE} 'mkdir ~/.ssh && cat >> ~/.ssh/authorized_keys'

ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -Y -X eclipseuser@${SSH_INTERFACE} -p ${SSH_PORT} /home/eclipseuser/eclipse/eclipse -data workspace
rm -f ${SSH_KEY_FILE_PRIVATE}
