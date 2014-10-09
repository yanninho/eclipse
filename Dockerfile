FROM     yanninho/ssh
MAINTAINER Yannick Saint Martino

# make sure the package repository is up to date
RUN apt-get update

RUN apt-get install -y openjdk-7-jdk && rm -rf /var/lib/apt/lists/*

RUN groupadd eclipseuser && useradd eclipseuser -s /bin/bash -m -g eclipseuser -G eclipseuser && adduser eclipseuser sudo
RUN echo 'eclipseuser:eclipseuser' |chpasswd 

RUN cd /home/eclipseuser/ && \
	wget http://ftp-stud.fht-esslingen.de/pub/Mirrors/eclipse/technology/epp/downloads/release/luna/R/eclipse-jee-luna-R-linux-gtk-x86_64.tar.gz && \
	tar -xzvf eclipse-jee-luna-R-linux-gtk-x86_64.tar.gz && \
	rm eclipse-jee-luna-R-linux-gtk-x86_64.tar.gz

RUN mkdir -p /home/eclipseuser/workspace
RUN chown eclipseuser:eclipseuser -R /home/eclipseuser/*


VOLUME ["/home/eclipseuser/workspace"]

	
ENV PATH /home/eclipseuser/eclipse:$PATH

