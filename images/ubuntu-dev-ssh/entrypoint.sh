#!/usr/bin/env bash
set -euo pipefail

readonly expected_user="dev"
readonly configured_user="${SSH_USER:-dev}"
readonly configured_password="${SSH_PASSWORD:-fungi}"
readonly data_dir="/data"
readonly home_dir="${data_dir}/home/dev"
readonly ssh_data_dir="${data_dir}/ssh"

if [[ "${configured_user}" != "${expected_user}" ]]; then
  echo "SSH_USER must remain '${expected_user}' in this image" >&2
  exit 1
fi

if [[ -z "${configured_password}" ]]; then
  echo "SSH_PASSWORD must not be empty" >&2
  exit 1
fi

install -d -m 0755 "${data_dir}" "${data_dir}/home"
install -d -m 0750 -o dev -g dev "${home_dir}"

if [[ ! -e "${home_dir}/.fungi-home-initialized" ]]; then
  cp -a /usr/local/share/fungi/home-template/. "${home_dir}/"
  touch "${home_dir}/.fungi-home-initialized"
fi

install -d -m 0700 -o dev -g dev "${home_dir}/.ssh"
touch "${home_dir}/.ssh/authorized_keys"
chown dev:dev "${home_dir}/.ssh/authorized_keys"
chmod 0600 "${home_dir}/.ssh/authorized_keys"
chown -R dev:dev "${home_dir}"

install -d -m 0700 "${ssh_data_dir}"

if [[ ! -f "${ssh_data_dir}/ssh_host_ed25519_key" ]]; then
  ssh-keygen -q -t ed25519 -N '' -f "${ssh_data_dir}/ssh_host_ed25519_key"
fi

if [[ ! -f "${ssh_data_dir}/ssh_host_rsa_key" ]]; then
  ssh-keygen -q -t rsa -b 4096 -N '' -f "${ssh_data_dir}/ssh_host_rsa_key"
fi

chmod 0600 "${ssh_data_dir}/ssh_host_ed25519_key" "${ssh_data_dir}/ssh_host_rsa_key"

printf '%s:%s\n' "${expected_user}" "${configured_password}" | chpasswd

install -d -m 0755 /run/sshd
/usr/sbin/sshd -t -f /etc/ssh/sshd_config

exec /usr/sbin/sshd -D -e -f /etc/ssh/sshd_config
