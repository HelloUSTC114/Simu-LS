#!/bin/bash
source ~/.bashrc

nThreads=24
nRuns=30

function DoYielding() {
    pwdBefore=$PWD
    dataDir=$3
    cd ~/Codes/Simu-LSbuild
    # mkdir /data/John/LS 2>/dev/null
    mkdir $dataDir 2>/dev/null

    mkdir $dataDir/rootFile 2>/dev/null
    mkdir $dataDir/logFile 2>/dev/null

    echo $(date) >>RunLog.txt
    echo Groove2-$1, Running: $2 >>RunLog.txt
    echo >>RunLog.txt

    ./CRTest macJohn/LSBox2/Test.gdml macJohn/LSBox2/mac/test_pdu.mac $dataDir/rootFile/Test-$1-$2.root $(expr $(expr $1 \* $nThreads) + $2) >$dataDir/logFile/Test-$1-$2.log 2>&1
    # echo macJohn/LSBox2/Test.gdml macJohn/LSBox2/mac/test_pdu.mac $dataDir/rootFile/Test-$1-$2.root $(expr $(expr $1 \* $nThreads) + $2) $dataDir/logFile/Test-$1-$2.log

    cd $pwdBefore
}

# export LD_LIBRARY_PATH

for ((i = 0; i < $nRuns; i++)); do
    echo RUN $i begins now -------- >>RunLog.txt
    echo RUN $i begins now --------
    # DoGroove1 $i &
    # DoGroove2 $i &
    # DoResolution $i 1 &
    # DoResolution $i 2 &
    # DoResolution $i 3 &
    # DoResolution $i 4 &
    for ((j = 0; j < $nThreads; j++)); do
        DoYielding $i $j /home/john/Data/Geant4-Data/LS-SimuData/Data1 &
    done

    wait
    echo RUN $i ends now -------- >>RunLog.txt
    echo RUN $i ends now --------
done
