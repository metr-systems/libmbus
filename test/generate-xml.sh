#!/bin/sh
#------------------------------------------------------------------------------
# Copyright (C) 2010-2012, Robert Johansson and contributors, Raditex AB
# All rights reserved.
#
# rSCADA
# http://www.rSCADA.se
# info@rscada.se
#
# Contributors:
# Large parts of this file was contributed by Stefan Wahren.
#
#------------------------------------------------------------------------------

# Check commandline parameter
if [ $# -ne 1 ]; then
    echo "usage: $0 path_to_directory_with_xml_files"
    echo "or"
    echo "usage: $0 path_to_directory_with_xml_files path_to_mbus_parse_hex_with_filename"
    exit 3
fi

directory="$1"

# # Check directory
if [ ! -d "$directory" ]; then
    echo "$directory not found"
    exit 3
fi

# Default location is this one
mbus_parse_hex="build/bin/mbus_parse_hex"

# though can be overriten
if [ $# -eq 2 ]; then
    mbus_parse_hex="$2"
fi

# Check if mbus_parse_hex exists
if [ ! -x $mbus_parse_hex ]; then
    echo "mbus_parse_hex not found"
    echo "path to mbus_parse_hex: $mbus_parse_hex"
    exit 3
fi

generate_xml() {
    directory="$1"
    hexfile="$2"
    mode="$3"

    filename=$(basename "$hexfile" .hex)

    if [ $mode = "normalized" ]; then
        options="-n"
        suffix="norm.xml"
    else
        options=""
        suffix="xml"
    fi

    # Parse hex file and write XML in file
    $mbus_parse_hex $options "$hexfile" > "$directory/$filename.$suffix.new"
    result=$?

    # Check parsing result
    if [ $result -ne 0 ]; then
        echo "Unable to generate XML for $hexfile"
        rm "$directory/$filename.$suffix.new"
        return 1
    fi

    # Compare old XML with new XML and write in file
    diff -u "$directory/$filename.$suffix" "$directory/$filename.$suffix.new" 2> /dev/null > "$directory/$filename.$suffix.dif"
    result=$?

    case "$result" in
        0)
             # XML equal -> remove new
             rm "$directory/$filename.$suffix.new"
             rm "$directory/$filename.$suffix.dif"
             ;;
        1)
             # different -> print diff
             cat "$directory/$filename.$suffix.dif" && rm "$directory/$filename.$suffix.dif"
             echo ""
             ;;
        *)
             # no old -> rename XML
             echo "Create $filename.$suffix"
             mv "$directory/$filename.$suffix.new" "$directory/$filename.$suffix"
             rm "$directory/$filename.$suffix.dif"
             ;;
    esac

    return $result
}

for hexfile in "$directory"/*.hex;  do
    if [ ! -f "$hexfile" ]; then
        continue
    fi

    generate_xml "$directory" "$hexfile" "default"

    generate_xml "$directory" "$hexfile" "normalized"
done

