#!/usr/bin/env bash
set -e

source /vagrant/utils/defaults.sh
source /vagrant/utils/helpers.sh

check_requirements curl tar

ARCHIVE="blackbox_exporter-${BLACKBOX_EXPORTER_VERSION}.linux-${ARCH}.tar.gz"

if ! check_cache "${ARCHIVE}"; then
  get_archive "https://github.com/prometheus/blackbox_exporter/releases/download/v${BLACKBOX_EXPORTER_VERSION}/${ARCHIVE}"
fi

if ! id blackbox_exporter > /dev/null 2>&1 ; then
  useradd --system blackbox_exporter
fi

tar zxf "${CACHE_PATH}/${ARCHIVE}" -C /usr/bin --strip-components=1 --wildcards */blackbox_exporter

install -m 0644 -D /vagrant/chapter05/configs/blackbox_exporter/blackbox.yml /etc/prometheus/blackbox.yml
install -m 0644 /vagrant/chapter05/configs/blackbox_exporter/blackbox-exporter.service /etc/systemd/system/

systemctl daemon-reload
systemctl enable blackbox-exporter
systemctl start blackbox-exporter

