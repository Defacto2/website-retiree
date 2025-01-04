# /docker_assets/lucee/Dockerfile
# https://hub.docker.com/r/lucee/lucee
#
# note: To sync lucee/lucee to current version on Docker Hub,
# `docker compose build --pull --no-cache`
FROM lucee/lucee:5.4-nginx

# Package versions
# Debian 11 (bullseye) [debianEd value must be lowercase!]
# Debian 12 (bookworm)
ARG debianEd=bullseye

# https://github.com/sharkdp/bat/releases
ARG batTag=0.24.0

# https://github.com/ansilove/libansilove/releases
ARG libansiloveTag=1.4.1

#https://github.com/ansilove/ansilove/releases
ARG ansiloveTag=4.2.0

# Install nginx and supervisord
COPY nginx_signing.key /tmp/nginx_signing.key
#RUN apt-key add /tmp/nginx_signing.key # this command will not work after Bullseye, below is the replacement
RUN cat /tmp/nginx_signing.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/nginx_signing.gpg >/dev/null
RUN useradd -r nginx

# note: if you receive errors such as
# libc6-dev : Depends: libc6 (= 2.28-10) but 2.31-13 is to be installed
# confirm the Debian edition in use on lucee/lucee, as these sources below maybe out of sync

# Require nginx and non-free sources to install `unrar`
# note: > overrides text to avoid duplicate entries on rebuilds, >> appends text
# RUN echo "deb http://deb.debian.org/debian ${debianEd} main non-free" > /etc/apt/sources.list && \
#  	echo "deb http://security.debian.org/debian-security/ ${debianEd}-security main non-free" >> /etc/apt/sources.list && \
#  	echo "deb http://deb.debian.org/debian ${debianEd}-updates main non-free" >> /etc/apt/sources.list

# apt-utils is required for ansilove deb libs
# libgd-dev and libgd3 are required for the ansilove build
RUN set -x && \
	apt-get autoremove && \
	apt-get update --quiet && \
	apt-get install --quiet --assume-yes apt-utils && \
	apt-get install --quiet --assume-yes \
	arc \
	bind9-host \
	build-essential \
	cmake \
	fdupes \
	file \
	git \
	iputils-ping \
	libgd-dev \
	libgd3 \
	lsb-release \
	tofrodos \
	graphicsmagick \
	nano \
	net-tools \
	netpbm \
	optipng \
	p7zip-full \
	pngquant \
	unrar \
	webp \
	zsh && \
	apt-get upgrade --quiet --assume-yes

# Optional, install oh-my-zsh (https://github.com/robbyrussell/oh-my-zsh)
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
COPY .zshrc /root/

# Optional, install bat - a coloured `cat` clone (https://github.com/sharkdp/bat)
RUN curl -L https://github.com/sharkdp/bat/releases/download/v${batTag}/bat_${batTag}_amd64.deb -o bat_install.deb && \
	dpkg -i bat_install.deb && \
	rm bat_install.deb

# Copy default nginx config files
# Note: these are temporary and should be overwritten by docker-compose.yml
COPY nginx.conf /etc/nginx/
COPY default.conf /etc/nginx/conf.d/

# Copy supervisord.conf
COPY supervisord.conf /etc/supervisor/conf.d/

# Provide test page
RUN mkdir -p /var/www
COPY index.cfm /var/www/
ONBUILD RUN rm -rf /var/www/*

# Clone and install libansilove and ansilove
RUN git clone --quiet -c advice.detachedHead=false --branch ${libansiloveTag} https://github.com/ansilove/libansilove.git /tmp/libansilove && \
	mkdir --parents /tmp/libansilove/build
WORKDIR /tmp/libansilove/build
RUN cmake ..\
	&& make \
	&& make install
RUN git clone --quiet -c advice.detachedHead=false --branch ${ansiloveTag} https://github.com/ansilove/ansilove.git /tmp/ansilove && \
	mkdir --parents /tmp/ansilove/build
WORKDIR /tmp/ansilove/build
RUN cmake .. \
	&& make \
	&& make install

# Fix for libansilove v1.1.x on Debian
# https://github.com/ansilove/ansilove/issues/23
WORKDIR /usr/local/lib
RUN ldconfig /usr/local/lib

# Clean-up
RUN apt-get purge --yes apt-utils git cmake build-essential libgd-dev && \
 	apt-get autoremove --yes \
 	&& apt-get clean --quiet --yes && \
 	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy custom shell scripts (source: /docker_assets/lucee/scripts)
COPY scripts/create-7zs.sh /usr/local/bin
COPY scripts/iff-to-png.sh /usr/local/bin
COPY scripts/tmp-clean.sh /usr/local/bin

# Fix Lucee errors (https://github.com/lucee/lucee-dockerfiles/issues/61)
RUN sed -i 's~\(<Connector [^\>]*AJP/.*\)\( />\)~ \1 secretRequired="false" \2 ~' '/usr/local/tomcat/conf/server.xml'
RUN touch '/opt/lucee/server/lucee-server/context/password.txt' \
	&& ls -l /opt/lucee/server/lucee-server/context/password.txt

# Restore original lucee image workdir
WORKDIR /usr/local/tomcat

# Expose HTTP and HTTPS ports
EXPOSE 80 443

# Engage
RUN lsb_release -a && \
	bin/version.sh && \
	nginx -v && \
	ansilove -v
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
