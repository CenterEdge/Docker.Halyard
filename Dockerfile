FROM ubuntu:14.04

RUN useradd -ms /bin/bash halyard && \
    apt-get update && \
    apt-get install -y apt-transport-https ca-certificates && \
    apt-get install -y curl vim && apt-get install -y software-properties-common && \
    curl -O https://raw.githubusercontent.com/spinnaker/halyard/master/install/stable/InstallHalyard.sh && \
    bash InstallHalyard.sh --user halyard
	
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
	chmod +x kubectl && \
	mv kubectl /usr/local/bin

USER halyard
WORKDIR /home/halyard
VOLUME /home/halyard

ENTRYPOINT ["/opt/halyard/bin/halyard"]