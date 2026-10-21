# Linux Service Management Lab: rsyslog & CUPS

Hands-on lab covering how to inspect, stop, start, restart, reload, and troubleshoot services on Linux using the SysV `service` command.

## Objectives

- Get familiar with common system services on Linux
- Start, stop, restart, and reload services
- Fix a failing service
- Edit a service configuration and apply the change

## Environment

- Linux shell (Debian-based container, SysV `service` command)
- Commands used: `service`, `logger`, `tail`, `cat`, `grep`, `ls`, `mv`, `nano`

---

## 1. Listing system services

```shell
sudo service --status-all
```

```
[ - ]  avahi-daemon
[ - ]  cron
[ - ]  cups
[ - ]  cups-browsed
[ - ]  dbus
[ - ]  exim4
[ ? ]  hwclock.sh
[ - ]  procps
[ + ]  rsyslog
[ - ]  saned
[ + ]  ssh
[ - ]  sudo
[ + ]  udev
```

| Symbol | Meaning |
|--------|---------|
| `+` | Service is running |
| `-` | Service is stopped |
| `?` | State can't be determined |

Searching the system log for errors:

```shell
sudo cat /var/log/syslog | grep error | tail
```

---

## 2. Stopping and starting a service (rsyslog)

`rsyslog` receives log output from processes and writes it to files such as `/var/log/syslog`, `/var/log/auth.log`, and `/var/log/kern.log`.

### Check status

```shell
sudo service rsyslog status
```

Expected: `rsyslogd is running.`

### Send a test log entry

```shell
logger This is a test log entry
sudo tail -1 /var/log/syslog
```

```
Jun 18 08:48:21 93431e170ddb student: This is a test log entry
```

### Stop the service

```shell
sudo service rsyslog stop
sudo service rsyslog status
```

Expected: `rsyslogd is not running ... failed!`

### Log while the service is stopped

```shell
logger This is another test log entry
sudo tail /var/log/syslog
```

The new message does **not** appear. The last entry is still the earlier test line, because nothing was running to write it to disk.

### Start the service again

```shell
sudo service rsyslog start
sudo service rsyslog status
logger This is another test log entry
sudo tail /var/log/syslog
```

```
Jun 18 08:52:38 93431e170ddb rsyslogd: [origin software="rsyslogd" swVersion="8.1901.0" ...] start
Jun 18 08:53:03 93431e170ddb student: This is another test log entry
```

The message is logged again after the restart.

> **Note:** The `imklog: cannot open kernel log (/proc/kmsg): Operation not permitted` warning is expected in a container and does not affect the lab.

---

## 3. Fixing a failing service (CUPS)

### Diagnose

```shell
sudo service --status-all     # cups shows [ - ]
sudo service cups status
```

Expected: `cupsd is not running ... failed!`

### Inspect the config directory

```shell
sudo ls -l /etc/cups
```

```
-rw-r--r-- 1 root root  6496 Jun 18 08:32 cupsd.conf.old
```

**Root cause:** `cupsd.conf` is missing, but a backup named `cupsd.conf.old` exists.

### Fix

```shell
sudo mv /etc/cups/cupsd.conf.old /etc/cups/cupsd.conf
sudo ls -l /etc/cups          # confirm cupsd.conf now exists
sudo service cups start
sudo service cups status
```

Expected: `cupsd is running.`

---

## 4. Restarting a service after a config change

By default CUPS only logs warnings and errors, so `/var/log/cups` starts out empty:

```shell
sudo ls -l /var/log/cups
```

```
total 0
```

### Enable debug logging

```shell
sudo nano /etc/cups/cupsd.conf
```

Change:

```
LogLevel warn
```

to:

```
LogLevel debug
```

### Apply with a restart

```shell
sudo service cups restart
sudo cat /var/log/cups/error_log
```

Sample output (trimmed):

```
I [18/Jun/2024:09:02:21 +0000] Listening to 0.0.0.0:631 (IPv4)
I [18/Jun/2024:09:02:21 +0000] Loaded configuration file "/etc/cups/cupsd.conf"
D [18/Jun/2024:09:02:21 +0000] Creating KeepAlive/PID file "/run/cups/cupsd.pid".
I [18/Jun/2024:09:02:21 +0000] Resuming new connection processing...
```

Debug (`D`) entries now appear in the log.

---

## 5. Reloading a service (no downtime)

Revert the log level:

```shell
sudo nano /etc/cups/cupsd.conf
```

Change `LogLevel debug` back to `LogLevel warn`, then:

```shell
sudo service cups reload
sudo service cups status
```

Expected: `cupsd is running.` The service re-read its configuration without being stopped.

---

## Restart vs. reload

| Action | Behavior | Use when |
|--------|----------|----------|
| `restart` | Stops, then starts the service | Config change needs a full restart; brief downtime is acceptable |
| `reload` | Re-reads config without stopping | Service supports it and you want zero downtime |

## Key takeaways

- Only users with admin rights (`sudo`) can stop or start services; anyone can query status.
- `service <name> status` is the first step when troubleshooting.
- A missing config file is a common cause of service failure. Check the config directory and any backups.
- `reload` applies config changes without interrupting the service.
- **Security relevance:** when `rsyslog` is stopped, events are silently lost. Attackers may stop logging services to hide activity, so monitoring that logging services stay up is important for SOC work.

## Commands reference

| Command | Purpose |
|---------|---------|
| `sudo service --status-all` | List all services and their state |
| `sudo service <name> status` | Check one service |
| `sudo service <name> start` | Start a service |
| `sudo service <name> stop` | Stop a service |
| `sudo service <name> restart` | Stop and start |
| `sudo service <name> reload` | Re-read config without stopping |
| `logger <text>` | Send a message to the system log |
| `sudo tail /var/log/syslog` | View recent log lines |
