#!/usr/bin/env python
# -*- coding: utf-8 -*-

# @see
# https://www.justinsilver.com/technology/linux/change-interval-munin-existing-rrd-data/
# http://www.sekuda.com/changing_munin_2_to_collect_data_every_minute

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see http://www.gnu.org/licenses/

import sys
from copy import deepcopy
from StringIO import StringIO

try:
    from lxml import etree
except ImportError:
    try:
        import xml.etree.cElementTree as etree
    except ImportError:
        try:
            import xml.etree.ElementTree as etree
        except ImportError:
            try:
                import cElementTree as etree
            except ImportError:
                try:
                    import elementtree.ElementTree as etree
                except ImportError:
                    raise

def main(dumpfile, factor):

    xmldoc = etree.parse(dumpfile)
    root = xmldoc.getroot()

    # change step, reducing it by a factor of "factor"
    step = root.find("step")
    assert(step!=None)
    old_step = int(step.text)
    new_step = old_step/factor
    step.text = str(new_step)

    database = root.findall("rra/database")
    for d in database:
        index = 0
        count = len(d)
        while count > 0:
            for i in range(0, factor-1):
                d.insert(index+1, deepcopy(d[index]))
            index = index + factor
            count = count - 1

    print etree.tostring(root)

if __name__ == "__main__":
    # arguments
    if len(sys.argv) != 3:
        print "rrd_step_reduce.py rrddump.xml factor"
        sys.exit(-1)

    # call main
    main(sys.argv[1], int(sys.argv[2]))
