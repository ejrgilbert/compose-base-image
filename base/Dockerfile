FROM vanilla:latest

ARG RESOURCES_DIR="/tmp/resources"
ARG UTILS="/opt/docker_utils"
ADD resources/sshd ${RESOURCES_DIR}
ADD resources/docker_utils ${UTILS}

# for run-parts
COPY entrypoint.d/* /entrypoint.d/

ONBUILD COPY entrypoint.d/* /entrypoint.d/
ONBUILD RUN chmod -R +x /entrypoint.d

# configure docker_utils
RUN chmod +x ${UTILS}/*

# pdsh
RUN yum -y clean all && \
    yum -y install openssh-server openssh-client pdsh pdsh-rcmd-ssh pdsh-mod-genders genders nc && \
    yum -y clean all

# sshd
RUN mkdir -p /etc/service/sshd && \
    mkdir ~root/.ssh && \
    cp ${RESOURCES_DIR}/config/sshd_config /etc/ssh/sshd_config && \
    cp ${RESOURCES_DIR}/root_key/compose_root_rsa ~root/.ssh/id_rsa && \
    cat ${RESOURCES_DIR}/root_key/compose_root_rsa.pub >>~root/.ssh/authorized_keys && \
    cp ${RESOURCES_DIR}/root_key/compose_root_rsa.pub ~root/.ssh/id_rsa.pub && \
    chmod -R 700 ~root/.ssh && \
    chmod 644 ~root/.ssh/id_rsa.pub && \
    chmod 600 ~root/.ssh/id_rsa && \
    chmod +x ${RESOURCES_DIR}/user_setup.sh && \
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' && \
    ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key -N '' && \
    # enable ssh within network for root
    printf "* " >>~root/.ssh/known_hosts && \
    cat /etc/ssh/ssh_host_rsa_key.pub >>~root/.ssh/known_hosts && \
    printf "* " >>~root/.ssh/known_hosts && \
    cat /etc/ssh/ssh_host_dsa_key.pub >>~root/.ssh/known_hosts && \
    ${RESOURCES_DIR}/user_setup.sh

# cleanup
RUN rm -rf /tmp/resources

CMD [ "/usr/sbin/sshd -D" ]
