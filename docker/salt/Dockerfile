FROM python:3.7-alpine

ARG PYGIT2_VERSION=1.0.3

ARG SALT_PASSWORD=salt
ARG SALT_USER=salt
ARG SALT_USER_IDENTIFIER=1001
ARG SALT_VERSION=3000

LABEL com.github.sk4la.maintainer="sk4la <sk4la.box@gmail.com>"
LABEL com.github.sk4la.tag="sk4labs/salt:alpine"
LABEL com.github.sk4la.uri="https://github.com/sk4la/salt-bench"
LABEL com.github.sk4la.version="2020.1a"

ENV PYTHONDONTWRITEBYTECODE=true
ENV PYTHONHASHSEED=random

RUN apk --no-cache add --upgrade \
        dumb-init                \
        gcc                      \
        gnupg                    \
        less                     \
        libgit2-dev              \
        man                      \
        man-pages                \
        openssh-client           \
        openssl-dev              \
        sudo                     \
        tree

RUN apk --no-cache add --upgrade --virtual .build \
        autoconf                                  \
        g++                                       \
        libffi-dev                                \
        musl-dev

RUN python -m pip install --no-cache-dir --upgrade \
        distro                                     \
        wheel

RUN python -m pip install --no-cache-dir --upgrade \
        pycryptodomex                              \
        pygit2==${PYGIT2_VERSION}                  \
        pyopenssl                                  \
        salt==${SALT_VERSION}

RUN apk --purge del .build

RUN addgroup                                           \
        -g 1000                                        \
        -S sudo                                     && \
    addgroup                                           \
        -g ${SALT_USER_IDENTIFIER}                     \
        -S ${SALT_USER}                             && \
    adduser                                            \
        -D                                             \
        -g "${SALT_USER},,,,,"                         \
        -G ${SALT_USER}                                \
        -s /bin/ash                                    \
        -S                                             \
        -u ${SALT_USER_IDENTIFIER}                     \
        ${SALT_USER}                                && \
    touch /home/${SALT_USER}/.hushlogin             && \
    echo "${SALT_USER}:${SALT_PASSWORD}" | chpasswd && \
    addgroup ${SALT_USER} sudo                      && \
    sed -ie "s/.*# %sudo.*/%sudo ALL=(ALL) ALL/g" /etc/sudoers

COPY --chown=${SALT_USER_IDENTIFIER}:${SALT_USER_IDENTIFIER} \
        assets/etc/salt/master.d/master.conf                 \
        /etc/salt/master.d/master.conf

COPY --chown=${SALT_USER_IDENTIFIER}:${SALT_USER_IDENTIFIER} \
        assets/etc/salt/roster                               \
        /etc/salt/roster

COPY --chown=root:root            \
        assets/etc/ssh/ssh_config \
        /etc/ssh/ssh_config

COPY --chown=root:root                       \
        assets/usr/local/bin/deploy-ssh-keys \
        /usr/local/bin/deploy-ssh-keys

RUN mkdir -p                \
        /etc/pki            \
        /etc/salt/pki       \
        /etc/salt/minion.d  \
        /etc/salt/master.d  \
        /etc/salt/proxy.d   \
        /srv/pillar         \
        /srv/salt           \
        /var/cache/salt     \
        /var/log/salt       \
        /var/run/salt    && \
    chmod -R 2775           \
        /etc/pki            \
        /etc/salt           \
        /srv/pillar         \
        /srv/salt           \
        /var/cache/salt     \
        /var/log/salt       \
        /var/run/salt    && \
    chgrp -R salt           \
        /etc/pki            \
        /etc/salt           \
        /srv/pillar         \
        /srv/salt           \
        /var/cache/salt     \
        /var/log/salt       \
        /var/run/salt    && \
    chmod 644               \
        /etc/ssh/ssh_config \
        /etc/salt/roster    \
        /etc/salt/master.d/master.conf && \
    chmod 755                             \
        /usr/local/bin/deploy-ssh-keys

WORKDIR /

ENTRYPOINT [ "/usr/bin/dumb-init" ]

CMD [ "/bin/sleep", "infinity" ]
