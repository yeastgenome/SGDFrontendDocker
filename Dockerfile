FROM ubuntu:20.04

WORKDIR /data/www
RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get upgrade -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
	emboss \
	git \
        make \
        nodejs \
	npm \
        python3-pip \
        ruby \
        ruby-dev \
	tzdata \
    && gem install bundler \
    && git clone https://github.com/yeastgenome/SGDFrontendDocker.git

WORKDIR /data/www/logs
WORKDIR /data/www/tmp

WORKDIR /data/www/SGDFrontendDocker
RUN git checkout master_docker \
    && npm install -g bower \
    && bower install --force \
    && pip3 install virtualenv \
    && virtualenv /data/www/SGDFrontendDocker/venv \
    && . /data/www/SGDFrontendDocker/venv/bin/activate \
    && pip3 install -U setuptools==57.5.0 \
    && make build

WORKDIR /data/www/SGDFrontendDocker/src/sgd/tools/seqtools/emboss
RUN /usr/bin/rebaseextract -infile withrefm.809 -protofile proto.809

WORKDIR /

CMD ["sh", "-c", ". /data/www/SGDFrontendDocker/venv/bin/activate && pserve $INI_FILE --reload"]
