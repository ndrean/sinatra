#! usr/bin/env bash

# times
# start=$(( (date +%s%N)/1000 ))
# start=$(( 2 * 3 /5 ))
# printf %.5f "$((10**3 * 2/3))e-3
# printf %.5f "$(($start))"
# echo "scale=3; $(date +%s%3N)/1000" | bc
# main
# end=$(( (date +%s%N)/1000 ))
# echo "$end"
# res=$(( end - start ))
# echo "$res"

gettime(){  ruby -e "puts (Time.now.to_f * 1000).to_i"; }
# start1=$(ruby -e "puts Time.now")

start=$(gettime)
echo "$start"

# start=gdate; gdate +%s%3N

sleep 1.4

end=$(gettime)
echo "$end"

res=$(( end - start )) #| bc -l

echo $res
printf %.6f "$res"
