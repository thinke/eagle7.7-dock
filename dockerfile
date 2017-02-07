FROM debian:jessie

RUN apt-get update && apt-get -y upgrade

RUN apt-get -y install wget bzip2
RUN apt-get -y install libcups2
RUN apt-get -y install man-db
RUN apt-get -y install sudo 
RUN apt-get -y install xserver-xorg-core libxrender1 libxrandr2 libxcursor1 libfontconfig1 libxi6
RUN apt-get -y clean
RUN mkdir -p /opt/eagle-7.7.0
ADD start.sh /opt/start.sh

RUN mkdir -p /home/eagle && \
	echo "eagle:x:${uid:-1000}:gid=${gid:-1000}:eagle,,,:/home/eagle:/bin/bash" >> /etc/passwd && \
	echo "eagle:x:${uid:-1000}:" >> /etc/group && \
	echo "eagle ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/eagle && \
	chmod 0440 /etc/sudoers.d/eagle && \
	chown ${uid:-1000}:${gid:-1000} -R /home/eagle
	
WORKDIR /home/eagle
RUN wget -q -O eagle-lin64-7.7.0.run http://web.cadsoft.de/ftp/eagle/program/7.7/eagle-lin64-7.7.0.run
RUN chmod +x eagle-lin64-7.7.0.run
RUN ./eagle-lin64-7.7.0.run /opt
RUN rm eagle-lin64-7.7.0.run
RUN chown ${uid:-1000}:${gid:-1000} -R /opt/eagle-7.7.0
RUN chown ${uid:-1000}:${gid:-1000} /opt/start.sh
RUN chmod +x /opt/start.sh
USER eagle
RUN mkdir /home/eagle/eagle
ENV HOME /home/eagle

CMD /opt/start.sh
