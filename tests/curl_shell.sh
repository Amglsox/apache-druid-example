i=0
while
       echo "this command is executed at least once $i"
       : ${start=$i}              # capture the starting value of i
       # some other commands      # needed for the loop
       curl http://localhost:1010/create_event
       i="$((i+1))"               # increment the variable of the loop.
       [ "$i" -lt 40 ]            # test the limit of the loop.
do :;  done
echo "Final value of $i///$start"
echo "The loop was executed $(( i - start )) times "
