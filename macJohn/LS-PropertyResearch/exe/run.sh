#!/bin/bash
source ~/.bashrc

nRuns=30

cd ~/Codes/Simu-LSbuild

dataDirRoot=~/Data/Geant4-Data/LS-Property/
mkdir $dataDirRoot 2>/dev/null

sourceDirRoot=~/Codes/Simu-LS/macJohn/LS-PropertyResearch/

# export LD_LIBRARY_PATH

function DoYield() {
    ./CRTest $sourceDirRoot/exe/Yield-$yield.gdml $sourceDirRoot/src/mac/test_pdu.mac $dataDir/rootFile/Yield-$yield-Run-$1.root $yield >$dataDir/logFile/Yield-$yield-Run-$1.log 2>&1
    # echo $sourceDirRoot/exe/Yield-$yield $sourceDirRoot/src/mac/test_pdu.mac $dataDir/rootFile/Yield-$yield-Run-$i.root $yield $dataDir/logFile/Yield-$yield-Run-$i.log

}

function DoLength() {
    ./CRTest $sourceDirRoot/exe/AbsLength-$absLength.gdml $sourceDirRoot/src/mac/test_pdu.mac $dataDir/rootFile/AbsLength-$absLength-Run-$1.root $absLength >$dataDir/logFile/AbsLength-$absLength-Run-$1.log 2>&1
    # echo $sourceDirRoot/exe/AbsLength-$absLength.gdml $sourceDirRoot/src/mac/test_pdu.mac $dataDir/rootFile/AbsLength-$absLength-Run-$i.root $absLength $dataDir/logFile/AbsLength-$absLength-Run-$i.log

}

for ((i = 0; i < $nRuns; i++)); do
    echo RUN $i begins now -------- >>RunLog.txt
    echo RUN $i begins now --------

    for yield in 25 30 35 40 45 50 55 60 65 70 75 80; do
        dataDir=$dataDirRoot/Yield-$yield
        mkdir $dataDir 2>/dev/null
        mkdir $dataDir/rootFile 2>/dev/null
        mkdir $dataDir/logFile 2>/dev/null

        DoYield $i &

    done

    for absLength in 100 130 160 200 250 300 400 500 700 900 1200 1500; do
        dataDir=$dataDirRoot/AbsLength-$absLength
        mkdir $dataDir 2>/dev/null
        mkdir $dataDir/rootFile 2>/dev/null
        mkdir $dataDir/logFile 2>/dev/null

        DoLength $i &
    done

    wait
    echo RUN $i ends now -------- >>RunLog.txt
    echo RUN $i ends now --------
done
