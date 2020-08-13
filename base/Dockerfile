FROM vanilla:latest

ARG RESOURCES_DIR="/tmp/resources"
ADD resources ${RESOURCES_DIR}

# for run-parts
COPY entrypoint.d/* /entrypoint.d/

ONBUILD COPY entrypoint.d/* /entrypoint.d/
ONBUILD RUN chmod -R +x /entrypoint.d

# sshd
RUN yum -y clean all && \
    yum -y install openssh-server openssh-client && \
    mkdir -p /etc/service/sshd && \
    mkdir ~root/.ssh && \
    cp ${RESOURCES_DIR}/sshd/config/sshd_config /etc/ssh/sshd_config && \
    cp ${RESOURCES_DIR}/sshd/root_key/insecure-key ~root/.ssh/id_rsa && \
    cat ${RESOURCES_DIR}/sshd/root_key/insecure-key.pub >>~root/.ssh/authorized_keys && \
    cp ${RESOURCES_DIR}/sshd/root_key/insecure-key.pub ~root/.ssh/id_rsa.pub && \
    chmod -R 700 ~root/.ssh && \
    chmod 644 ~root/.ssh/id_rsa.pub && \
    chmod 600 ~root/.ssh/id_rsa && \
    chmod +x ${RESOURCES_DIR}/sshd/user_setup.sh && \
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' && \
    ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key -N '' && \
    ${RESOURCES_DIR}/sshd/user_setup.sh

# cleanup
RUN rm -rf /tmp/resources

# configure entrypoint
ADD base_img_entrypoint.sh /
RUN chmod +x /base_img_entrypoint.sh

# runit will start up all services
ENTRYPOINT [ "/base_img_entrypoint.sh" ]
