#!/usr/bin/env bash

IMGDIR=/var/www/images/uuid
OUTDIR=/opt/archives

if [ ! -f $OUTDIR/images150.7z ]; then
    echo "Creating $OUTDIR/images150.7z"
    7z a -y -bb2 -m0=Copy $OUTDIR/images150.7z $IMGDIR/150x150/*.png
else
    echo "Updating $OUTDIR/images150.7z"
    7z u -y -bb2 -m0=Copy $OUTDIR/images150.7z $IMGDIR/150x150/*.png
fi
if [ ! -f $OUTDIR/images400.7z ]; then
    echo "Creating $OUTDIR/images400.7z"
    7z a -y -bb2 -m0=Copy $OUTDIR/images400.7z $IMGDIR/400x400/*.png
else
    echo "Updating $OUTDIR/images400.7z"
    7z u -y -bb2 -m0=Copy $OUTDIR/images400.7z $IMGDIR/400x400/*.png
fi
if [ ! -f $OUTDIR/images000.7z ]; then
    echo "Creating $OUTDIR/images000.7z"
    7z a -y -bb2 -m0=Copy $OUTDIR/images000.7z $IMGDIR/original/*.png
else
    echo "Updating $OUTDIR/images000.7z"
    7z u -y -bb2 -m0=Copy $OUTDIR/images000.7z $IMGDIR/original/*.png
fi