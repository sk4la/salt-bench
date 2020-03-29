FROM ubuntu:bionic

ARG SALT_PASSWORD=salt
ARG SALT_USER=salt

LABEL com.github.sk4la.maintainer="sk4la <sk4la.box@gmail.com>"
LABEL com.github.sk4la.tag="sk4labs/dummy:ubuntu"
LABEL com.github.sk4la.uri="https://github.com/sk4la/salt-bench"
LABEL com.github.sk4la.version="2020.1a"

ENV PYTHONDONTWRITEBYTECODE=true
ENV PYTHONHASHSEED=random

RUN apt-get update                   && \
    apt-get install --yes               \
        dumb-init                       \
        openssh-server                  \
        python3.7                       \
        sudo                         && \
    apt-get autoremove --purge --yes && \
    apt-get clean

RUN adduser                                            \
        --disabled-password                            \
        --gecos "${SALT_USER},,,,,"                    \
        --uid 1001                                     \
        ${SALT_USER}                                && \
    touch /home/${SALT_USER}/.hushlogin             && \
    echo "${SALT_USER}:${SALT_PASSWORD}" | chpasswd && \
    echo "${SALT_USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

COPY --chown=0:0                   \
        assets/etc/ssh/sshd_config \
        /etc/ssh/sshd_config

RUN chmod 644 /etc/ssh/sshd_config && \
    mkdir --parents /var/run/sshd

WORKDIR /

ENTRYPOINT [ "/usr/bin/dumb-init" ]

CMD [ "/usr/sbin/sshd", "-D" ]
