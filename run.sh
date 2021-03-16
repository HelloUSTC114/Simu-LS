#!/bin/bash
source ~/.bashrc


function DoYielding() {
    pwdBefore=$PWD
    dataDir=/data/John/LS/Yield1/
    cd ~/Codes/Simu-LSbuild
    mkdir /data/John/LS 2> /dev/null
    mkdir $dataDir 2> /dev/null

    mkdir $dataDir/rootFile 2>/dev/null
    mkdir $dataDir/logFile 2>/dev/null

    echo $(date) >>RunLog.txt
    echo Groove2-$1, Running: $2 >>RunLog.txt
    echo >>RunLog.txt

    ./CRTest macJohn/LSBox2/Test.gdml macJohn/LSBox2/mac/test_pdu.mac $dataDir/rootFile/Test-$1-$2.root $(expr $1 \* $2) >$dataDir/logFile/Test-$1-$2.log 2>&1

    cd $pwdBefore
}

# export LD_LIBRARY_PATH
for ((i = 1; i < 20; i++)); do
    echo RUN $i begins now -------- >> RunLog.txt
    echo RUN $i begins now -------- 
    # DoGroove1 $i &
    # DoGroove2 $i &
    # DoResolution $i 1 &
    # DoResolution $i 2 &
    # DoResolution $i 3 &
    # DoResolution $i 4 &

    DoYielding $i 1 &
    DoYielding $i 2 &
    DoYielding $i 3 &
    DoYielding $i 4 &
    DoYielding $i 5 &
    DoYielding $i 6 &
    DoYielding $i 7 &
    DoYielding $i 8 &
    DoYielding $i 9 &
    DoYielding $i 10 &
    DoYielding $i 11 &
    DoYielding $i 12 &
    wait
    echo RUN $i ends now -------- >> RunLog.txt
    echo RUN $i ends now -------- 
done
