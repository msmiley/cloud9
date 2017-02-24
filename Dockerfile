FROM debian:jessie

#############################
# Debian APT dependencies
RUN apt-get update; apt-get install -y git curl build-essential python2.7 tmux

#############################
# Cloud9 IDE
# default ide port is 8181, we use 8080 for ide
# 8081 and 8082 are ports cloud9 prefers for running your webapps
EXPOSE 8080 8081 8082

# add in some nice Cloud9 default settings
COPY user.settings /root/.c9/
COPY .c9 /go/.c9

# install cloud9
RUN git clone git://github.com/c9/core.git c9sdk
RUN cd c9sdk; ./scripts/install-sdk.sh; ln -s /c9sdk/bin/c9 /usr/bin/c9

# start cloud9 with no authentication by default
# if authentication is desired, set the value of -a, i.e. -a user:pass at the end of the docker run line
ENTRYPOINT ["/root/.c9/node/bin/node", "c9sdk/server.js", "-w", "/go", "--listen", "0.0.0.0", "-p", "8080"]
CMD ["-a", ":"]