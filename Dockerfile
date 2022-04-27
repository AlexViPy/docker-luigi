FROM ubuntu:latest
ARG USER=luigi
ARG LUIGI_HOME=/home/luigi
ENV LUIGI_HOME=${LUIGI_HOME}

RUN apt-get update \
    && useradd --password NP --create-home --shell /bin/bash ${USER} \
    && apt-get -y install \
    software-properties-common \
    python3 \
    python3-pip \
    build-essential \
    procps \
    libpq-dev \
    nano \
    postgresql-client \
    cron \
    supervisor \
    && echo "luigi ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN pip3 install 'luigi==3.0.3' 'sqlalchemy==1.4.35' 'psycopg2-binary==2.9.3'

# create files and dir
WORKDIR ${LUIGI_HOME}
ENV PYTHONPATH ${LUIGI_HOME}

COPY ./configs ${LUIGI_HOME}/configs
COPY ./src ${LUIGI_HOME}/src
COPY ./tasks ${LUIGI_HOME}/tasks
RUN touch src/logs/luigi.log && chmod 644 src/logs/luigi.log
RUN touch src/state/luigi-state.pickle && chmod 644 src/state/luigi-state.pickle

# install requirements
COPY ./scripts ${LUIGI_HOME}/scripts
RUN chmod +x scripts/install_requirements.sh
RUN scripts/install_requirements.sh

# cron settings
ADD crontab /etc/cron.d/crontab
RUN chmod 644 /etc/cron.d/crontab
RUN crontab /etc/cron.d/crontab
RUN touch /var/log/cron.log

# supervisor settings
COPY supervisord.conf /etc/supervisor/
RUN mkdir -p /var/log/supervisor 


CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
