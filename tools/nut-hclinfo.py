#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#   Copyright (c) 2009 - Arnaud Quette <arnaud.quette@gmail.com>
#   Copyright (c) 2010 - Sébastien Volle <sebastien.volle@gmail.com>
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software
#   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

# This script convert the driver.list into HTML and JSON formated tables
# These tables are then used by the AsciiDoc generated website and
# documentation

try:
    import json
except ImportError:
    import simplejson as json # Required for Python < 2.6
  
import re
import sys
import os, errno

# HCL file location and name
rawHCL="../nut/data/driver.list";

# Website output
webJsonHCL = "../scripts/ups_data.js";
webStaticHCL = "../ups-html.txt";

# Relative path to NUT's manpages directory
manDir = "../nut/docs/man/"
# Path to manpages from HCL *in* website
webManDir = "docs/man/"

# from http://wiki.python.org/moin/EscapingHtml

html_escape_table = {
    "&": "&amp;",
    '"': "&quot;",
    "'": "&apos;",
    ">": "&gt;",
    "<": "&lt;",
    }

def html_escape(text):
    """Produce entities within text."""
    return "".join(html_escape_table.get(c,c) for c in text)

# # #

class WrongFieldNumberException(Exception):
    pass

def buildData(deviceDataFile):
    """
    Read and parse data file under provided path.
    Return a bi-dimensional list representing parsed data.
    """

    deviceData = []
    numFields = 6 # Manufacturer, type, support level, model comment, driver
    
    try:
        file = open(deviceDataFile, "r")
    except IOError:
        print "Cannot open", deviceDataFile
        exit(1)
           
    for line in file:     
        # Ignore empty lines or comments
        if re.match(r"^$|^\s*#", line):
            continue
        
        # Strip all trailing whitespace chars
        line = re.sub(r"\s+$", "", line)
        
        # Replace all tabs by commas
        line = re.sub(r"\t", ",", line)

        # Remove trailing comma
        line = re.sub(r",$", "", line)
        
        # Split fields and append result to device data list
        # We suppose there are no double-quotes in fields
        row = re.findall(r'"([^"]*)",?', line)
        
        if len(row) != numFields:
            print "Warning: Unexpected number of fields in line: %s" % row
            print "\tLine will be skipped."
        else:
            deviceData.append(re.findall(r'"([^"]*)",?', line))
    
    return deviceData

def buildHTMLTable(deviceData):
    """
    Convert provided device data into an HTML table.
    Return string representation of the HTML table.
    
    Identical cells are merged vertically with rowspan attribute.
    The driver column is color-coded on support level.
    
    A support level column is also provided. It should be hidden in a graphic
    browser but should be visible from a console based browser (w3m).
    """
    
    from lxml import etree, html
    from lxml.builder import E
    
    if not type(deviceData).__name__ == "list" or len(deviceData) == 0:
        raise Exception("Incorrect data was provided")
    
    # HTML table columns definition
    columns = [
        {
            "name": "manufacturer", "id": "manufacturer-col",
            "text": "Manufacturer", "fields": ["manufacturer"]
        },
        {
            "name": "model", "id": "model-col",
            "text": "Model", "fields": ["model", "comment"]
        },
        {
            "name": "driver", "id": "driver-col",
            "text": "Driver", "fields": ["driver"]
        },
        {
            "name": "support-level", "id": "support-level-col",
            "text": "Support Level", "fields": ["support-level"]
        },
    ]
    # Device data fields definition
    dataFields = [
        "manufacturer", "device-type", "support-level",
        "model", "comment", "driver"
    ]
    
    # FIXME: CSS classes should be defined in script global settings
    supportLevelClasses = {
        "0": "", "1": "red", "2": "orange",
        "3": "yellow", "4": "blue", "5": "green"
    }
    hiddenClass = "hidden"

    # Build table header
    table = E.table(id="ups_list", border="1")
    header = E.tr()
    
    for column in columns:
        td = E.td(column.get("text"), id=column.get("id"))
        if column["id"] == "support-level-col":
            td.set("class", hiddenClass)
        header.append(td)
    
    table.append(E.thead(header))
    
    # Build table body
    tbody = E.tbody(id="ups_list_body")
    
    cellHistory = []
    rowHistory = deviceData[0][0]
    rows = []
    classes = ("even", "odd")
    currentClass = 0
    manufIndex = dataFields.index("manufacturer")
    
    # Build table rows
    for device in deviceData:
        
        # Devices are expected to have a specified number of fields
        if len(device) < len(dataFields):
            print "Unexpected number of fields in device: %s" % device
            print "Device will not be included in result set."
            continue
        
        # Alternate CSS class if current manufacturer is different from the last
        if device[manufIndex] != rowHistory :
            currentClass = (currentClass + 1) % 2
            rowHistory = device[manufIndex]
        
        cells = []
        
        colIndex = 0
        for column in columns:
            cellContent = []
            for field in column["fields"]:
                fieldIndex = dataFields.index(field)
                # Link driver => manpage
                if field == "driver":
                    words = device[fieldIndex].split()
                    linkedWords = []
                    for word in words:
                        if word in manPages:
                            linkedWords.append("<a href=\"%s.html\">%s</a>" % (webManDir + word, word))
                        else:
                            linkedWords.append(html_escape(word))
                    cellContent.append(" ".join(linkedWords))
                else:
                    fieldContent = device[fieldIndex]
                    cellContent.append(html_escape(fieldContent))
            cellContent = "<br />".join(cellContent)
            
            try:
                cH = cellHistory[colIndex]
            except:
                cH = False

            # Find last seen support-level (to merge driver rows)
            if column["name"] == "driver":
                for slI, slC in enumerate(columns):
                    if slC["name"] == "support-level":
                        break
                try:
                    slcH = cellHistory[slI]
                except:
                    slcH = False

            if cH and cH.get("text") == cellContent and (column["name"] != "driver" or (slcH and slcH.get("text") == device[dataFields.index("support-level")])):
                cH["rowspan"] = cH.get("rowspan", 1) + 1
            else:
                cell = { "text": cellContent, "rowspan": 1 }
                if column["name"] == "driver":
                    cell["class"] = supportLevelClasses[device[dataFields.index("support-level")]]
                else:
                    cell["class"] = classes[currentClass]
                if column["name"] == "support-level":
                    cell["class"] = hiddenClass
                    
                cells.append(cell)
                try:
                    cellHistory[colIndex] = cell
                except:
                    cellHistory.append(cell)
                
            colIndex += 1
        
        rows.append(cells)
    
    for row in rows:
        r = E.tr()
        for cell in row:
            attr = ""
            innerHTML = ""
            for key, value in cell.iteritems():
                val = unicode(str(value), "utf-8")
                if key != "text":
                    attr += " %s='%s'" % (key, val)
                else:
                    innerHTML = val
            
            r.append(html.fromstring("<td%s>%s</td>" % (attr, innerHTML)))
            
        tbody.append(r)
            
    table.append(tbody)
    
    return etree.tostring(table, pretty_print=True)

# main program
deviceData = buildData(rawHCL)

# List of manpages
manPages = []
try:
    for name in os.listdir(manDir):
        if os.path.isfile(os.path.join(manDir, name)) and name.endswith(".html") and name != "index.html":
            manPages.append(name[:-5])
except OSError:
    print "Unable to get manpage list from '%s'" % manDir

# Dump device data and manpage names as JSON
jsonData = "var UPSData = %s, NUTManPages = %s" % (json.dumps(deviceData, encoding="utf-8"), json.dumps(manPages, encoding="utf-8"))

# First, check if target directory exists (which is not the case for 'dist')
dir = os.path.dirname(webJsonHCL)
try:
    os.makedirs(dir)
except OSError:
    pass

try:
    file = open(webJsonHCL, "w")
    file.write(jsonData)
    file.close()
    print "JSON HCL written"
except IOError:
    print "Unable to write JSON device data to %s" % webJsonHCL
    exit(1)

# Create HTML table from device data
table = buildHTMLTable(deviceData)
try:
    file = open(webStaticHCL, "w")
    file.write("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n")
    file.write(table)
    file.write("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n")
    print "HTML HCL written"
except IOError:
    print "Unable to write HTML device table to %s" % webStaticHCL
    exit(1)

