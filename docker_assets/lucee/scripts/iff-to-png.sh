# convert Amiga ILBM, IFF and Electronic Artgs Deluxe Paint images to PNG
# requires: netpbm
#! /bin/sh
ilbmtoppm < $1 | pnmtopng - > $2.png