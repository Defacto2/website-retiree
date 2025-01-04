# convert PNG images to WebP
find $1 -type f -and -iname "*.png" \
-exec bash -c '
webp_path=$(sed 's/\.[^.]*$/.webp/' <<< "$0");
if [ ! -f "$webp_path" ]; then
  cwebp -mt -near_lossless 70 -short "$0" -o "$webp_path";
fi;' {} \;