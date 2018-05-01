# coding:utf-8
"""
Utils to get and set kafka topic consumer group offsets.
"""

import sys
import json
import os
from kazoo.client import KazooClient

def _calculate_new_offsets(zk, zk_root, group, topic, offset_number_per_partition):
    """
    """
    offsets = _get_offset(zk, zk_root, group, topic)
    
    new_offsets = {}
    for partition_id, offset in offsets.items():
        new_offsets[partition_id] = long(offset) + long(offset_number_per_partition)

    return new_offsets

def _set_offset(zk_client, zk_root, group, topic, new_offsets):
    """
    new_offsets: key: partition_id, value: new offset of the partition.
    {
        "0": 123456,
        "1": 23456,
        ...
    }
    """
    
    for partition_id, offset in new_offsets.items():
        path = os.path.join(zk_root, 'consumers', group, 'offsets', topic, partition_id)
        if not zk.exists(path):
            zk.create(path, makepath=True)

        zk.set(path, str(offset).encode('utf-8'))

    return new_offsets


def _get_offset(zk_client, zk_root, group, topic):

    offsets = {}
    path = os.path.join(zk_root, 'consumers', group, 'offsets', topic)
    print "~~~ Get Offset of Group: %s, Topic: %s, zk path: %s" % (group, topic, path)

    partitions = zk.get_children(path)
    for part_id in partitions:
        ppath = os.path.join(path, part_id)
        partition_offset, stat = zk.get(ppath)

        offsets[part_id] = partition_offset.decode("utf-8")

    return offsets

if __name__ == '__main__':

    if len(sys.argv[1:]) < 4:
        print "Usage:"
        print "Get offsets of a specific topic in the group: "
        print "\t python", sys.argv[0], "get <zookeeper_list> <consumer_group> <topic>"
        print ""
        print "Set offsets by offsets config json file: "
        print "\t python", sys.argv[0], "set <zookeeper_list> <consumer_group> <topic> <offsets_config_json_file>"
        print ""
        print "Set offsets by add/subtract a [offset] based on current offsets: "
        print "\t python", sys.argv[0], "set2 <zookeeper_list> <consumer_group> <topic> <offset_number_per_partition>"
        sys.exit(1)

    command = sys.argv[1]
    zookeeper_list = sys.argv[2]
    group = sys.argv[3]
    topic = sys.argv[4]

    zk = KazooClient(hosts=zookeeper_list, read_only=True)
    zk.start()

    # default zk path root for kafka.
    zk_root = "/"

    offsets = {}
    if command == 'get':
        offsets = _get_offset(zk, zk_root, group, topic)

    elif command == 'set':
        new_offsets_file = sys.argv[5]
        with open(new_offsets_file, 'r') as f:
            new_offsets_json = json.load(f)
            offsets = _set_offset(zk, zk_root, group, topic, new_offsets_json)

    elif command == 'set2':
        offset_number_per_partition = sys.argv[5]
        new_offsets = _calculate_new_offsets(zk, zk_root, group, topic, offset_number_per_partition)
        offsets = _set_offset(zk, zk_root, group, topic, new_offsets)

    print json.dumps(offsets, indent=4)
