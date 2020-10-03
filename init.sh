#!/bin/sh
set -e
[ -f /tmp/.X1-lock ] && rm /tmp/.X1-lock
pgid=${pgid:-0}
puid=${puid:-0}
[ "$pgid" != 0 ] && [ "$puid" != 0 ] && \
 groupmod -o -g "$pgid" czkawka && \
 usermod -o -u "$puid" czkawka && \
 chown -R czkawka:czkawka /app && \
 chown czkawka:czkawka /data/.* && \
 chown czkawka:czkawka /data/*
[ "$resize" = "auto" ] && sed -r -i '/src/s/"[^"]+"/"vnc.html?autoconnect=true"/' /usr/share/novnc/index.html
[ "$resize" = "scale" ] && sed -r -i '/src/s/"[^"]+"/"vnc.html?autoconnect=true\&resize=scale"/' /usr/share/novnc/index.html
[ "$resize" = "remote" ] && sed -r -i '/src/s/"[^"]+"/"vnc.html?autoconnect=true\&resize=remote"/' /usr/share/novnc/index.html
resolution=${resolution:-1280x720}x16
/usr/bin/supervisord -c /etc/supervisord.conf
