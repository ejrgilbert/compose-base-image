#!/bin/bash
set -e

. /etc/sysconfig/rsyslog
exec /sbin/rsyslogd -n "${SYSLOGD_OPTIONS}"
