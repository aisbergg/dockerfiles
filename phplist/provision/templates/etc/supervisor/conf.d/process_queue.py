#!/usr/bin/env python
# -*- coding: utf-8 -*-

import schedule
import signal
import sys
import time

from subprocess import Popen, PIPE


class SignalExit(Exception):
    def __init__(self, signum):
        self.signum = signum


class ScheduledProgram(object):
    def __init__(self, cmd, exitcodes=[0]):
        super().__init__()
        self.cmd = cmd
        self.exitcodes = exitcodes
        self._prog = None
        self._return_code = 0

    def handle_signal(self, signum, frame):
        raise SignalExit(signum)

    def _run_prog(self):
        self._prog = Popen(self.cmd)
        self._return_code = self._prog.wait()

    def run(self):
        signal.signal(signal.SIGHUP, self.handle_signal)
        signal.signal(signal.SIGINT, self.handle_signal)
        signal.signal(signal.SIGQUIT, self.handle_signal)
        signal.signal(signal.SIGTERM, self.handle_signal)

        schedule.every(15).minutes.do(self._run_prog)

        while True:
            try:
                schedule.run_pending()
                # exit if program exited with error code
                if self._return_code not in self.exitcodes:
                    return self._return_code

                time.sleep(30)

            except SignalExit as e:
                if not self._prog:
                    return 0
                elif self._prog.poll() is None:
                    self._prog.send_signal(e.signum)
                    return self._prog.wait()
                else:
                    return self._prog.poll()

            except:
                if self._prog:
                    self._prog.kill()
                    self._prog.wait()
                raise


def main():
    cmd = ['/usr/bin/php', '/data/www/admin/index.php',
           '-pprocessqueue', '-c', '/data/www/config/config.php']
    exit(ScheduledProgram(cmd).run())


if __name__ == "__main__":
    main()
