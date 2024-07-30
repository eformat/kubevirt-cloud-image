FROM scratch
USER root
ADD --chown=107:107 image.qcow2 /disk/
