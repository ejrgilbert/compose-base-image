#!/bin/bash
# create all users (datawave, accumulo, hdfs)
# they will all have the same ssh key

declare -A USERS=(
    ["datawave"]="/opt/datawave-ingest"
    ["accumulo"]="/opt/accumulo"
    ["hdfs"]="/opt/hadoop"
    ["zookeeper"]="/usr/lib/zookeeper"
)

authorized_keys_loc="/tmp/authorized_keys"
touch "${authorized_keys_loc}"
chmod 777 "${authorized_keys_loc}"
for user in "${!USERS[@]}"; do
    home_dir="${USERS[${user}]}"
    echo "Create ${user} user with home directory -> ${home_dir}"

    useradd -d "${home_dir}" -p "${user}" "${user}"
    usermod -U "${user}"
    chown -R "${user}:${user}" "${home_dir}"

    su -  "${user}" -c "mkdir ~/.ssh"
    su -  "${user}" -c "ssh-keygen -f ~/.ssh/id_rsa -q -N \"\""
    su -  "${user}" -c "cat ~/.ssh/id_rsa.pub >${authorized_keys_loc}"
    su -  "${user}" -c "chmod 700 ~/.ssh"
    su -  "${user}" -c "chmod 644 ~/.ssh/id_rsa.pub"
    su -  "${user}" -c "chmod 600 ~/.ssh/id_rsa"
    su -  "${user}" -c "echo \"* \" >~/.ssh/known_hosts"
done

for user in "${!USERS[@]}"; do
    home_dir="${USERS[${user}]}"

    # copy authorized_keys to ~/.ssh for each user
    cp "${authorized_keys_loc}" "${home_dir}/.ssh"
    chown "${user}:${user}" "${home_dir}/.ssh/authorized_keys"
    chmod 640 "${home_dir}/.ssh/authorized_keys"

    # enable localhost ssh for each user
    cat /etc/ssh/ssh_host_rsa_key.pub >>"${home_dir}/.ssh/known_hosts"
    cat /etc/ssh/ssh_host_dsa_key.pub >>"${home_dir}/.ssh/known_hosts"
done
rm "${authorized_keys_loc}"
