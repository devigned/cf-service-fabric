#! /usr/bin/env python

import boto3
import sys
import json
from subprocess import Popen, PIPE, STDOUT


def run_cmd(cmd):
    print "Running: %s" % cmd
    p = Popen(cmd, shell=True, stdin=PIPE, stdout=PIPE, stderr=STDOUT, close_fds=True)
    output = p.stdout.read()
    output.strip()
    return output


if len(sys.argv) < 2:
    print "usage: python update-sf-cluster.py stack-id"
    exit(1)
stack_id = sys.argv[1]

client = boto3.client('ec2')

reservations = client.describe_instances(
    Filters=[{'Name': 'tag:aws:cloudformation:stack-id', 'Values': [stack_id]}])['Reservations']

private_ips = set()
for reservation in reservations:
    for instance in reservation['Instances']:
        for interface in instance['NetworkInterfaces']:
            private_ips.add(interface['PrivateIpAddress'])

print json.dumps({'ips': list(private_ips)})
