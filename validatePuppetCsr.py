#!/usr/bin/python

import re
import sys
from subprocess import Popen, PIPE
import subprocess

pipe = Popen("openssl req -noout -text", shell=True, stdin=sys.stdin, stdout=subprocess.PIPE)

for line in iter(pipe.stdout.readline,''):
    if re.match("\s+(challengePassword)\s+:(MySuperSecretPasswordGoesHere)", line):
        sys.exit(0)

sys.exit(-1)
