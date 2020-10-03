FROM ubuntu:bionic
ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && \
 apt-get install -y libgtk-3-dev git binutils ca-certificates curl dbus libssl1.0-dev locales openbox patch supervisor x11vnc xvfb --no-install-recommends
RUN dbus-uuidgen > /etc/machine-id && \
 locale-gen en_US.UTF-8 && \
 mkdir /usr/share/novnc && \
 curl -fL# https://github.com/novnc/noVNC/archive/master.tar.gz -o /tmp/novnc.tar.gz && \
 tar -xf /tmp/novnc.tar.gz --strip-components=1 -C /usr/share/novnc && \
 mkdir /usr/share/novnc/utils/websockify && \
 curl -fL# https://github.com/novnc/websockify/archive/master.tar.gz -o /tmp/websockify.tar.gz && \
 tar -xf /tmp/websockify.tar.gz --strip-components=1 -C /usr/share/novnc/utils/websockify && \
 curl -fL# https://use.fontawesome.com/releases/v5.12.0/svgs/solid/cloud-download-alt.svg -o /usr/share/novnc/app/images/downloads.svg && \
 curl -fL# https://use.fontawesome.com/releases/v5.12.0/svgs/solid/comments.svg -o /usr/share/novnc/app/images/logs.svg && \
 bash -c 'sed -i "s/<path/<path style=\"fill:white\"/" /usr/share/novnc/app/images/{downloads,logs}.svg' && \
 sed -i 's/10px 0 5px/8px 0 6px/' /usr/share/novnc/app/styles/base.css && \
 git clone https://github.com/qarmin/czkawka.git /czkawka && cd /czkawka && \
 useradd -u 1000 -U -d /data -s /bin/false czkawka && \
 usermod -G users czkawka && \
 mkdir /data && \
 apt-get purge -y binutils curl dbus patch && \
 apt-get autoremove -y && \
 rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    XDG_RUNTIME_DIR=/data
COPY init.sh /init.sh
COPY supervisord.conf /etc/supervisord.conf
ENTRYPOINT ["/init.sh"]
