#!/usr/bin/python3
import os
import os.path
import shutil
import re

HADOOP_CONF = os.getenv('HADOOP_CONF_DIR')
HADOOP_CONFIG_REGEX = r"<!--\s*{{([\w.]+)}}\s*-->"

def insert_hadoop_config(filename, config):
    conf_file = os.path.join(HADOOP_CONF, filename)
    conf_old = "%s.old" % conf_file
    shutil.move(conf_file, conf_old)

    infile = open(conf_old, "r")
    outfile = open(conf_file, "w")

    for line in infile:
        m = re.search(HADOOP_CONFIG_REGEX, line)
        func = config[m.group(1)] if m else None

        if func:
            outfile.write("<property>\n")
            outfile.write(" <name>%s</name>\n" % m.group(1))
            outfile.write(" <value>%s</value>\n" % func())
            outfile.write("</property>\n")
        else:
            outfile.write(line)

    infile.close()
    outfile.close()

def yarn_application_classpath():
    import subprocess
    cpath = subprocess.check_output(["hadoop", "classpath", "--glob"])
    return cpath.decode().replace(':', ',')

insert_hadoop_config(
    filename="yarn-site.xml",
    config={
        'yarn.application.classpath': yarn_application_classpath,
    }
)
