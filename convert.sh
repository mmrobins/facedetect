# You'll need imagemagick and opencv3 installed properly
# http://www.pyimagesearch.com/2016/12/19/install-opencv-3-on-macos-with-homebrew-the-easy-way/
# This assumes the files are named from OSX Photo Booth

i=0
for file in ~/tmp/foo/*.jpg; do
  padding=100
  ./facedetect "$file" | while read x y w h; do
    name=$(basename "$file")

    # not all files had exif data :-/
    # datestamp=$(identify -verbose "$file" | grep exif:DateTimeOriginal | awk '{print $2}')

    # Photo on 2-27-13 at 12.44 PM.jpg
    rawdate=$(echo $file | sed -E "s/.*on ([[:digit:]]+-[[:digit:]]+-[[:digit:]]+).*/\1/")
    datestamp=$(date -j -f "%m-%d-%y" $rawdate +"%Y%m%d")

    echo $datestamp

    convert "$file" \
      -crop $((${w}+${padding}*2))x$((${h}+${padding}*2))+$((${x}-${padding}))+$((${y}-${padding})) \
      -resize "350x349!" `#349 because label ends up odd and ffmpeg needs even pixel count` \
      -background Khaki  label:"$datestamp" \
      -gravity Center -append \
      "$HOME/tmp/bar/${datestamp}_${i}.${name##*.}"
  done
  i=$(($i+1))
done

# you'll want to go through and delete photos where face detection messed up
# then from the output directory run:
#convert -delay 15 "20*.jpg" movie.m4v
