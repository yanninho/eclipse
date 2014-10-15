
Démarrer eclipse :

sudo docker run -ti --rm --name eclipse -v [ Your workspace ]:/home/eclipseuser/workspace -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix yanninho/eclipse

