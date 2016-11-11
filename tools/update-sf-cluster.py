#! /usr/bin/env python

import boto3
import sys
import jinja2


if len(sys.argv) < 3:
    print "usage: python render-manifest.py stack-id file-source"
    exit(1)
stack_id = sys.argv[1]
file_source = sys.argv[2]


client = boto3.client('ec2')

reservations = client.describe_instances(
    Filters=[{'Name': 'tag:aws:cloudformation:stack-id', 'Values': [stack_id]}])['Reservations']

private_ips = set()
for reservation in reservations:
    for instance in reservation['Instances']:
        for interface in instance['NetworkInterfaces']:
            private_ips.add(interface['PrivateIpAddress'])

context = {'ips': list(private_ips)}

with open(file_source, 'r') as f:
    print jinja2.Template(f.read()).render(context)

