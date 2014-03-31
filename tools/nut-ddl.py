#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#   Copyright (c) 2014 - Daniele Pezzini <hyouko@gmail.com>
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

import re
import os
import argparse

###

# Path to NUT's manpages directory, relative to the working directory
manDir = "nut/docs/man/"
# Path to manpage directory in website
webManDir = "../../docs/man/"

###

# Global vars

ndsVersion = "-1"
ndsSL = -1
varCmdComments = {}
devComment = []
nutVars = {}
nutRWs = {}
nutCommands = []
manPages = []

###

# Command line arguments

parser = argparse.ArgumentParser(description="Parse a NUT's .dev/.nds file to AsciiDoc")
parser.add_argument("infile", help="Input file to parse (either .dev or .nds)")
parser.add_argument("outfile", help="Output file where the resulting page should be stored")
parser.add_argument("-v", "--verbose", action="store_true", help="Be pedantic about what's going on")
args = parser.parse_args()
inputFile = args.infile
outputFile = args.outfile
verbose = args.verbose

###

# Comments parsing

def nds_version(raw):
    """
    Parse NDS file version.
    """

    # '# NDS:VERSION:<version>\n'

    global ndsVersion

    if ndsVersion != "-1":
        if verbose:
            print "Redeclaration of NDS version"
        return

    # Remove '# NDS:VERSION:'
    ndsVersion = raw[0][14:]


def nds_sl(raw):
    """
    Parse user-provided support-level for the device.
    """

    # '# DEVICE:SUPPORT-LEVEL:<support-level>\n'

    global ndsSL

    if ndsSL != -1:
        if verbose:
            print "Redeclaration od NDS support-level"
        return

    # Remove '# DEVICE:SUPPORT-LEVEL:'
    sl = int(raw[0][23:])

    if not 1 <= sl <= 10:
        if verbose:
            print "NDS support-level: '%d' out of range [1..10]" % sl
        return

    ndsSL = sl


def nds_dev_comment(raw):
    """
    Parse device comment.
    """

    # '# DEVICE:COMMENT:\n'
    # '# <comment>\n'
    # '# <comment>\n'
    #	...
    # '# DEVICE:EOC\n'

    if len(devComment):
        if verbose:
            print "Redeclaration of device comment"
        return

    # Remove leading 'start' line ('# DEVICE:COMMENT:\n')
    raw = raw[1:]

    # Not a valid device comment, don't do anything with it
    if not len(raw) or raw[-1] != "# DEVICE:EOC":
        if verbose:
            print "Invalid device comment"
        return

    # Remove the 'close' line
    raw = raw[:-1]

    # Empty comment
    if not len(raw):
        if verbose:
            print "Empty device comment"
        return

    # Remove hash and leading space
    for line in raw:
        devComment.append(line[2:])


def nds_var_cmd_comments(raw):
    """
    Parse comments of variables/commands.
    """

    # '# var.name[.suffix[. ...]]/command.name[.suffix[. ...]]:COMMENT:\n'
    # '# <comment>\n'
    # '# <comment>\n'
    #	...
    # '# var.name[.suffix[. ...]]/command.name[.suffix[. ...]]:EOC\n'

    # Get var/command name
    itemName = re.sub(":COMMENT:.*$", "", raw[0][2:])

    if varCmdComments.get(itemName):
        if verbose:
            print "Redeclaration of comment for '%s'" % itemName
        return

    # Remove leading 'start' line
    raw = raw[1:]

    # Not a valid comment, don't do anything with it
    if not len(raw) or raw[-1] != "# %s:EOC" % itemName:
        if verbose:
            print "Invalid comment for '%s'" % itemName
        return

    # Remove the 'close' line
    raw = raw[:-1]

    # Empty comment
    if not len(raw):
        if verbose:
            print "Empty comment for '%s'" % itemName
        return

    varCmdComments[itemName] = []

    # Remove hash and leading space
    for line in raw:
        varCmdComments[itemName].append(line[2:])


# Comments 'Pattern => parsing function' map
commentsMap = {
    # N[UT]D[evice]S[imulation] version
    #  '# NDS:VERSION:<value>\n'
    "^# NDS:VERSION:\S+$": nds_version,
    # Vars/commands - Start of comment:
    #  '# var.name[.suffix[. ...]]/command.name[.suffix[. ...]]:COMMENT:\n'
    "^# ([\w\-]+\.)+[\w\-]+:COMMENT:$": nds_var_cmd_comments,
    # Device - Start of comment
    #  '# DEVICE:COMMENT:\n'
    "^# DEVICE:COMMENT:$": nds_dev_comment,
    # Support level
    #  '# DEVICE:SUPPORT-LEVEL:<value>\n'
    "^# DEVICE:SUPPORT-LEVEL:\d\d?$": nds_sl
}

###

# End Of Comments patterns
EOCPatterns = [
    # Vars/commands comments
    #  '# var.name[.suffix[. ...]]/command.name[.suffix[. ...]]:EOC\n'
    "^# ([\w\-]+\.)+[\w\-]+:EOC$",
    # Device comment
    #  '# DEVICE:EOC\n'
    "^# DEVICE:EOC$"
]

###

# Non-comments parsing

def nds_vars(raw):
    """
    Parse NUT's vars.
    """

    # 'var.name[.suffix[. ...]]: <value>\n'

    varName = re.sub(":.*$", "", raw)

    if nutVars.get(varName):
        if verbose:
            print "Redeclaration of variable '%s'" % varName
        return

    nutVars[varName] = raw.replace("%s:" % varName, "", 1)[1:]


def nds_rw_vars(raw):
    """
    Parse NUT's RW vars.
    """

    # 'RW:var.name[.suffix[. ...]]:<type>:<options>\n'

    buf = raw.split(":", 4)

    varName = buf[1]
    varType = buf[2]

    if not nutRWs.get(varName):
        nutRWs[varName] = {}
        nutRWs[varName]["type"] = varType
    elif not nutRWs[varName].get("type") or nutRWs[varName]["type"] != varType:
        if verbose:
            print "Redeclaration of RW variable '%s' with mismatching types (%s != %s)" % (varName, varType, nutRWs[varName]["type"])
        return

    if varType == "STRING":
        # 'RW:var.name[.suffix[. ...]]:STRING:<len>\n'
        if not buf[3].isdigit():
            if verbose:
                print "Declaration of RW variable '%s' of type 'STRING' with an invalid length (%s)" % (varName, buf[3])
            if not nutRWs[varName].get("opts"):
                del nutRWs[varName]
            return
        length = int(buf[3])
        if nutRWs[varName].get("opts"):
            if verbose and length != nutRWs[varName]["opts"]:
                print "Redeclaration of variable '%s' of type 'STRING' with different length (%d != %d)" % (varName, length, nutRWs[varName]["opts"])
            elif verbose:
                print "Redeclaration of variable '%s' of type 'STRING'" % varName
            return
        nutRWs[varName]["opts"] = length
    elif varType == "ENUM":
        # 'RW:var.name[.suffix[. ...]]:ENUM:"<enumerated value>"\n'
        if not re.match("^\".+\"$", buf[3]):
            if verbose:
                print "Declaration of RW variable '%s' of type 'ENUM' with an invalid format." % varName
                print "\texpected: 'RW:var.name[.suffix[. ...]]:ENUM:\"<enumerated value>\"'"
                print "\tgot: '%s'" % raw
            if not nutRWs[varName].get("opts"):
                del nutRWs[varName]
            return
        if not nutRWs[varName].get("opts"):
            nutRWs[varName]["opts"] = []
        nutRWs[varName]["opts"].append(buf[3][1:-1])
    elif varType == "RANGE":
        # 'RW:var.name[.suffix[. ...]]:RANGE:"<min>" "<max>"\n'
        if not re.match("^\"\d+\" \"\d+\"$", buf[3]):
            if verbose:
                print "Declaration of RW variable '%s' of type 'RANGE' with an invalid range." % varName
                print "\texpected: 'RW:var.name[.suffix[. ...]]:RANGE:\"<min>\" \"<max>\"'"
                print "\tgot: '%s'" % raw
            if not nutRWs[varName].get("opts"):
                del nutRWs[varName]
            return
        rwRange = buf[3].split("\"")
        if not len(rwRange[1]) or not rwRange[1].isdigit() or not len(rwRange[3]) or not rwRange[3].isdigit():
            if verbose:
                print "Declaration of RW variable '%s' of type 'RANGE' with a non-numerical range (%s..%s)" % (varName, rwRange[1], rwRange[3])
            if not nutRWs[varName].get("opts"):
                del nutRWs[varName]
            return
        rangeMin = int(rwRange[1])
        rangeMax = int(rwRange[3])
        if not rangeMin < rangeMax:
            if verbose:
                print "Declaration of RW variable '%s' of type 'RANGE' with an invalid range (%d..%d)" % (varName, rangeMin, rangeMax)
            if not nutRWs[varName].get("opts"):
                del nutRWs[varName]
            return
        if not nutRWs[varName].get("opts"):
            nutRWs[varName]["opts"] = []
        nutRWs[varName]["opts"].append({ "min": rangeMin, "max": rangeMax })
    else:
        if not nutRWs[varName].get("opts"):
            del nutRWs[varName]
        if verbose:
            print "Declaration of RW variable '%s' of unknown type '%s'." % (varName, varType)
        return


def nds_commands(raw):
    """
    Parse NUT's instant commands.
    """

    # 'CMD:command.name[.suffix[. ...]]\n'

    command = raw[4:]

    if command in nutCommands:
        if verbose:
            print "Redeclaration of command '%s'" % command
        return

    nutCommands.append(command)


# Non-comments 'Pattern => parsing function' map
nonCommentsMap = {
    # Vars
    #  'var.name[.suffix[. ...]]: <value>\n'
    "^([\w\-]+\.)+[\w\-]+: ": nds_vars,
    # Empty vars
    #  'var.name[.suffix[. ...]]:\n'
    "^([\w\-]+\.)+[\w\-]+:$": nds_vars,
    # RW Vars
    #  'RW:var.name[.suffix[. ...]]:<type>:<options>\n'
    "^RW:([\w\-]+\.)+[\w\-]+:\w+:\S": nds_rw_vars,
    # Commands
    #  'CMD:command.name[.suffix[. ...]]\n'
    "^CMD:(\w+\.)+\w+$": nds_commands
}

###

# End Of File patterns
EOFPatterns = [
    # Beginning of a sequence of [recorded] events
    "TIMER \d+"
]

###

def parseFile(inputFile):
    """
    Parse inputFile to split it in comments/non-comments:
    Return:
    - a list of non-comments lines
    - a bidimensional list of comments lines
    """

    try:
        file = open(inputFile, "r")
    except IOError:
        print "Cannot open", inputFile
        exit(1)

    # Whether the last processed line was a comment and we can expect the actually processed one belongs to that comment
    commentContinuation = False

    # Whether we have encountered a NUT's 'EOF' and therefore have to ignore all non-comment lines
    ignoreNonComments = False

    # Index of comments entities in comments list
    i = -1

    comments = []
    nonComments = []

    for line in file:
        # Whether to bail out
        bailout = False

        # Check whether this line should be considered as the End Of File (such as recorded events' 'TIMER') and therefore we have to ignore all non-comments lines from now on
        for pattern in EOFPatterns:
            if re.match(pattern, line):
                bailout = True
                break
        if bailout:
            if not ignoreNonComments:
                if verbose:
                    print "NUT's 'EOF' found, ignoring remaining non-comment lines"
                ignoreNonComments = True
            commentContinuation = False
            continue

        # Ignore empty lines, comments without the required leading space after the hash ('#<text>') and lines with spaces preceeding a hash, e.g. '   # comment ...\n'
        # note: an empty/'non-valid comment'/'indented comment' line 'breaks' a comment while an empty commented line ('#') doesn't
        if re.match("^(\s*|\s+#.*|#[^ \n\r].*)$", line):
            commentContinuation = False
            continue

        # Comments
        if re.match("^#", line):
            newEntity = False
            # New entity
            for pattern in commentsMap:
                if re.match(pattern, line):
                    i += 1
                    comments.append([])
                    comments[i].append(line[:-1])
                    commentContinuation = True
                    newEntity = True
                    break

            if newEntity:
                continue

            # Entity continuation
            if commentContinuation:
                comments[i].append(line[:-1])
                # End Of Comment
                for pattern in EOCPatterns:
                    if re.match(pattern, line):
                        commentContinuation = False
                        break

            continue

        # Check for known non-comments
        bailout = True
        for pattern in nonCommentsMap:
            if re.match(pattern, line):
                bailout = False
                break

        # Something unexepected
        if bailout:
            print "Unexepected line '%s'" % line[:-1]
            exit(1)

        if not ignoreNonComments:
            nonComments.append(line[:-1])

        commentContinuation = False

    return comments, nonComments

###

def buildPage():
    """
    Build raw AsciiDoc page from data get from the input file.
    """

    # [/path/to/]<manufacturer>__<model>__<driver_name>__<NUT_version>__<report_number>.{dev,nds}
    [ filePath, fileNameExt ] = os.path.split(inputFile)

    [ fileName, fileExt ] = os.path.splitext(fileNameExt)

    fileType = fileExt[1:]

    if fileType not in [ "dev", "nds" ]:
        print "%s: unexpected type of file" % inputFile
        print "\texpected: .dev/.nds"
        exit(1)

    # <manufacturer>__<model>__<driver_name>__<NUT_version>__<report_number>
    infos = fileName.split("__")

    if len(infos) < 5:
        print "%s: unsuitable name; expected:" % inputFile
        print "\t<manufacturer>__<model>__<driver_name>__<NUT_version>__<report_number>.{dev,nds}"
        exit(1)

    # Info From File Name:
    manufacturerFFN = infos[0].replace("_", " ")
    driverNameFFN = infos[2]
    nutVersionFFN = infos[3]

    if not infos[4].isdigit() or int(infos[4]) < 1:
        print "%s: unsuitable report number '%s'; expected 1+" % (inputFile, infos[4])
        exit(1)

    reportNumberFFN = int(infos[4])

    # old .dev/.seq
    if fileType == "dev":
        simProgName = "dummy-ups"
        rwProgName = "upsrw"
        cmdProgName = "upscmd"
    # .nds
    else:
        simProgName = "dummy-ups" # TODO
        rwProgName = "upsrw" # TODO
        cmdProgName = "upscmd" # TODO

    page = []

    # New NUT version in page
    if reportNumberFFN == 1:
        page.append("\n\n== %s\n" % nutVersionFFN)

    page.append("\n=== Report #%d\n" % reportNumberFFN)

    buf = "This device is known to work with driver "
    if driverNameFFN in manPages:
        buf += "link:%s%s.html[%s].\n" % (webManDir, driverNameFFN, driverNameFFN)
    else:
        buf += "%s.\n" % driverNameFFN
    page.append(buf)

    buf = "You can grab a "
    if simProgName in manPages:
        buf += "link:%s%s.html[%s]" % (webManDir, simProgName, simProgName)
    else:
        buf += "%s" % simProgName
    buf += " compliant +.%s+ file " % fileType
    # .nds files
    if fileType == "nds" and ndsVersion != "-1":
        buf += "(_v%s_) " % ndsVersion
    buf += "to simulate this device link:$$raw/%s.%s$$[clicking here]" % (fileName, fileType)
    # Old .dev/.seq files
    if fileType == "dev" and os.path.isfile(os.path.join(filePath, fileName + ".seq")):
        buf += " and a +.seq+ file to simulate power events link:$$raw/%s.seq$$[clicking here]" % (fileName)
    buf += ".\n"
    page.append(buf)

    # NUT vars
    page.append("\n==== Known supported variables\n")
    page.append("This device is known to support the following variables (values are just examples):\n")

    for nutVar in sorted(nutVars):
        if len(nutVars[nutVar]):
            buf = "- _%s_: +pass:specialcharacters[%s]+" % (nutVar, nutVars[nutVar].replace("]", "\]"))
        else:
            buf = "- _%s_:" % nutVar
        page.append(buf)

        # RW vars
        if nutRWs.get(nutVar):
            page.append("+\n--")

            incipit = "This variable can be set through "
            if rwProgName in manPages:
                incipit += "link:%s%s.html[%s]" % (webManDir, rwProgName, rwProgName)
            else:
                incipit += "%s" % rwProgName

            if nutRWs[nutVar]["type"] == "STRING":
                page.append("%s to a string value upto the length of `%d` characters." % (incipit, nutRWs[nutVar]["opts"]))
            elif nutRWs[nutVar]["type"] == "RANGE":
                page.append("%s within the following ranges:\n" % incipit)
                for rwRange in nutRWs[nutVar]["opts"]:
                    page.append("- `%d`..`%d`" % (rwRange["min"], rwRange["max"]))
            elif nutRWs[nutVar]["type"] == "ENUM":
                page.append("%s to one of the following values:\n" % incipit)
                for enum in nutRWs[nutVar]["opts"]:
                    page.append("- +pass:specialcharacters[%s]+" % enum.replace("]", "\]"))

            page.append("--")

        # Var comment
        if varCmdComments.get(nutVar):
            page.append("+\n--")
            for commentLine in varCmdComments[nutVar]:
                page.append(commentLine)
            page.append("--")

    # NUT instant commands
    if len(nutCommands):
        page.append("\n\n==== Known supported commands\n")

        buf = "This device is known to support the following "
        if cmdProgName in manPages:
            buf += "link:%s%s.html[NUT's instant commands]:\n" % (webManDir, cmdProgName)
        else:
            buf += "NUT's instant commands:\n"
        page.append(buf)

        for nutCommand in sorted(nutCommands):
            page.append("- _%s_" % nutCommand)
            # Command comment
            if varCmdComments.get(nutCommand):
                page.append("+\n--")
                for commentLine in varCmdComments[nutCommand]:
                    page.append(commentLine)
                page.append("--")

    # Device comment/support-level
    if len(devComment) or ndsSL != -1:
        page.append("\n\n==== About this device\n")
        # Support level
        if ndsSL != -1:
            page.append("*Support level*: *%d* (out of 10)\n" % ndsSL)
        # Device comment
        if len(devComment):
            for commentLine in devComment:
                page.append(commentLine)

    page.append("")

    return page

###

# Start!

# Check if file exists..
if not os.path.isfile(inputFile):
    print "Input file '%s' doesn't exist" % inputFile
    exit(1)

# ..and it's not empty
if not os.stat(inputFile).st_size:
    print "Input file '%s' is empty" % inputFile
    exit(1)

# Parse given file
comments, nonComments = parseFile(inputFile)

# Parse comment lines
for comment in comments:
    for pattern in commentsMap:
        if re.match(pattern, comment[0]):
            commentsMap[pattern](comment)
            break

# Parse non-comment lines
for nonComment in nonComments:
    for pattern in nonCommentsMap:
        if re.match(pattern, nonComment):
            nonCommentsMap[pattern](nonComment)
            break

# Check if we have some vars
if not len(nutVars):
    print "Input file '%s' doesn't appear to be a valid .dev/.nds file" % inputFile
    exit(1)

# List of manpages
try:
    for name in os.listdir(manDir):
        if os.path.isfile(os.path.join(manDir, name)) and name.endswith(".html") and name != "index.html":
            manPages.append(name[:-5])
except OSError:
    print "Unable to get manpage list from '%s'" % manDir

# Build page
page = buildPage()

# Write page to outputFile
try:
    # Already existing page
    if os.path.isfile(outputFile):
        if verbose:
            print "'%s' already exists; overwriting it" % outputFile
    # New page
    else:
        if verbose:
            print "Creating new file '%s'" % outputFile
    file = open(outputFile, "w")
    file.write("\n".join(page))
    file.close()
    if verbose:
        print "'%s' written" % outputFile
except IOError:
    print "Unable to write parsed file to '%s'" % outputFile
    exit(1)

