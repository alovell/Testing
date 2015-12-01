#!/bin/bash

#script to itterate through nlag and nbmax and see if convergence depends on the combination
#nlag > nbmax, define nbmax and loop nlag up to nbmax
#read in file name
echo "Input file:  "
read iFile

#check to make sure the file exists, if not exit program
if [ -f "$iFile".in ];
then
    echo "Running FaCE"
    #variable to find in the input file
    #find nlag and nbmax
    in1="nlag=80";
    in2="nbmax=20";
    #in3="kmaxa(1)=18";
    #in4="kmaxa(2)=18";
    #in5="kmaxa(3)=18";
    for (( c=15; c<=30; c++ ))
    do
	#put the value of nbmax at the top of each iteration in the output file
	#echo "# nlag/nbmax = $c" >> NoProj_IDEknblag.txt
	#echo "# nlag/nbmax = $c" >> NoProj_IDRhonblag.txt
	#echo "# nlag/nbmax = $c" >> NoProj_IDRmatnblag.txt
	#echo "nlag/nbmax=$c"
	echo "nbmax=$c"
	#for each value of nlag/nbmax (c), iterate kxama (d) through a fixed set of values
	for (( d=$c; d<=$c+10; d++ ))
	do
	    #echo "$d and $c"
	    out1="nlag="$d
	    out2="nbmax="$c
	    #out3="kmaxa(1)="$d
	    #out4="kmaxa(2)="$d
	    #out5="kmaxa(3)="$d
	    #echo "$out1 $out2"
	    sed -i "s/$in1/$out1/g" "$iFile".in
	    sed -i "s/$in2/$out2/g" "$iFile".in
	    #sed -i "s/$in3/$out3/g" "$iFile".in
	    #sed -i "s/$in4/$out4/g" "$iFile".in
	    #sed -i "s/$in5/$out5/g" "$iFile".in
	    ~/My\ Documents/FaCE/face < "$iFile".in > "$iFile".out
	    sed -i "s/$out1/$in1/g" "$iFile".in
	    sed -i "s/$out2/$in2/g" "$iFile".in
	    #sed -i "s/$out3/$in3/g" "$iFile".in
	    #sed -i "s/$out4/$in4/g" "$iFile".in
	    #sed -i "s/$out5/$in5/g" "$iFile".in
	    #get energy out of the output file
	    line=`tail -1 "$iFile".out`
	    echo "$line"
	    echo "$d $line" >> FixnbIttnlag.txt
	    #get matter radius and rms rho out of the output file
	    #-m 1 takes only the first occurence of the line
	    rholine=`grep -o -m 1 'rms <rho> [^"]*' "$iFile".out`
	    if [ -z "$rholine" ]
		then
		     finalrr=0
		else
		     frontrr=${rholine#*=};
		     #echo "$frontrr";
		     backrr=${frontrr%fm*};
		     #echo "$backrr";
		     finalrr=${backrr%fm*};
		
	    fi
	    #-m 1 takes only the first occurence of the line
	    rmat=`grep -o -m 1 'rms matter radius = [^"]*' "$iFile".out`
	    if [ -z "$rmat" ]
		then
		     backrm=0
		else
	             frontrm=${rmat#*=};
		     backrm=${frontrm%fm*};
	    fi
	    echo "$finalrr $backrm"
	    echo "$d $finalrr" >> RhoFixnbIttnlag.txt
	    echo "$d $backrm" >> RmatFixnbIttnlag.txt
	done
	echo "&" >> FixnbIttnlag.txt
	echo "&" >> RhoFixnbIttnlag.txt
	echo "&" >> RmatFixnbIttnlag.txt
     done
    
else
    echo "Input file $iFile.in does not exist, exiting"
    exit
fi

#nlag > nbmax