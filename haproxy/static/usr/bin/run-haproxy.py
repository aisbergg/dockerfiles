#!/usr/bin/env python3

import signal
import sys

from subprocess import Popen, PIPE


def reload_haproxy(signum, frame):
    global new_process
    global main_process
    if new_process is None or new_process.poll() is not None:
        new_process = Popen(["/usr/local/sbin/haproxy", "-f", sys.argv[1], "-sf", str(
            main_process.pid)], stdout=sys.stdout.buffer, stderr=sys.stderr.buffer)


def signal_haproxy(signum, frame):
    global new_process
    global main_process
    if new_process is not None and new_process.poll() is not None:
        new_process.send_signal(signum)
        new_process.wait()
        new_process = None
    main_process.send_signal(signum)


signal.signal(signal.SIGHUP, signal_haproxy)
signal.signal(signal.SIGINT, signal_haproxy)
signal.signal(signal.SIGQUIT, signal_haproxy)
signal.signal(signal.SIGTERM, signal_haproxy)
signal.signal(signal.SIGUSR1, reload_haproxy)
signal.signal(signal.SIGUSR2, reload_haproxy)
signal.signal(signal.SIGCHLD, signal.SIG_IGN)

main_process = Popen(["/usr/local/sbin/haproxy", "-f", sys.argv[1]],
                     stdout=sys.stdout.buffer, stderr=sys.stderr.buffer)
new_process = None

while True:
    return_code = main_process.wait()
    if return_code == 0 and new_process is not None:
        main_process = new_process
        new_process = None
    else:
        exit(return_code)
