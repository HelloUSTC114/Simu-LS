#!/bin/bash
source ~/.bashrc
function DoGroove1() {
    pwdBefore=$PWD
    cd /Users/john/Codes/Simu-build
    mkdir rootFile 2>/dev/null
    mkdir logFile 2>/dev/null
    echo Groove1-$1
    ./CRTest macJohn/John_TriangleGroove1.gdml macJohn/test_muon.mac rootFile/Groove1-$1.root $1 >logFile/Groove1-$i.log
    cd $pwdBefore

}

function DoGroove2() {
    pwdBefore=$PWD
    cd /Users/john/Codes/Simu-build
    mkdir rootFile 2>/dev/null
    mkdir logFile 2>/dev/null
    echo Groove2-$1
    ./CRTest macJohn/John_TriangleGroove2.gdml macJohn/test_muon.mac rootFile/Groove2-$1.root $1 >logFile/Groove2-$i.log
    cd $pwdBefore
}

function DoResolution() {
    pwdBefore=$PWD
    cd ~/Codes/Simu-build
    mkdir Data 2> /dev/null
    mkdir Data/XResolution 2> /dev/null
    mkdir Data/XResolution/rootFile 2>/dev/null
    mkdir Data/XResolution/logFile 2>/dev/null

    echo `date` >> RunLog.txt
    echo Groove2-$1, Running: $2 >> RunLog.txt

    ./CRTest macJohn/XResolution/John_TriangleGroove2.gdml macJohn/XResolution/test_pdu.mac Data/XResolution/rootFile/Groove2-$1-$2.root `expr $1 \* 4 + $2` > Data/XResolution/logFile/Groove2-$1-$2.log 2>&1
    # echo ./CRTest macJohn/XResolution/John_TriangleGroove2.gdml macJohn/XResolution/test_muon.mac Data/XResolution/rootFile/Groove2-$1-$2.root `expr $1 \* 4 + $2`
    echo >> RunLog.txt
    
    cd $pwdBefore
}

function DoImaging(){
    pwdBefore=$PWD
    cd ~/Codes/Simu-build
    mkdir Data 2> /dev/null
    mkdir Data/ImagingTest 2> /dev/null
    mkdir Data/ImagingTest/rootFile 2>/dev/null
    mkdir Data/ImagingTest/logFile 2>/dev/null

    echo `date` >> $pwdBefore/RunLog.txt
    echo Groove2-$1, Running: $2 >> $pwdBefore/RunLog.txt

    ./CRTest macJohn/ImagingTest/ImagingLeadXY.gdml macJohn/ImagingTest/test_pdu.mac Data/ImagingTest/rootFile/ImagingFullLead-$1-$2.root `expr $1 \* 4 + $2` > Data/ImagingTest/logFile/ImagingFullLead-$1-$2.log 2>&1
    echo >> $pwdBefore/RunLog.txt
    
    cd $pwdBefore

}


function DoPoCA() {
    pwdBefore=$PWD
    cd ~/Codes/Simu-build
    mkdir Data 2>/dev/null
    mkdir Data/PoCAVerify-4Cubes 2>/dev/null
    mkdir Data/PoCAVerify-4Cubes/rootFile 2>/dev/null
    mkdir Data/PoCAVerify-4Cubes/logFile 2>/dev/null

    echo $(date) >>RunLog.txt
    echo Groove2-$1, Running: $2 >>RunLog.txt

    ./CRTest macJohn/PoCAVerify-4Cubes/ImagingLeadXY.gdml macJohn/PoCAVerify-4Cubes/test_pdu.mac Data/PoCAVerify-4Cubes/rootFile/Groove2-$1-$2.root $(expr $1 \* $2) >Data/PoCAVerify-4Cubes/logFile/Groove2-$1-$2.log 2>&1
    echo >>RunLog.txt

    cd $pwdBefore
}

function DoYielding() {
    pwdBefore=$PWD
    dataDir=/data/John/PhotonYielding-PreviousModule-Pdu/
    cd ~/Codes/Simu-build
    mkdir /data/John 2> /dev/null
    mkdir $dataDir 2> /dev/null

    mkdir $dataDir/rootFile 2>/dev/null
    mkdir $dataDir/logFile 2>/dev/null

    echo $(date) >>RunLog.txt
    echo Groove2-$1, Running: $2 >>RunLog.txt
    echo >>RunLog.txt

    ./CRTest macJohn/PhotonYielding-PhaseII/src/John_TriangleTest.gdml macJohn/PhotonYielding-PhaseII/src/mac/test_pdu.mac $dataDir/rootFile/Groove2-$1-$2.root $(expr $1 \* $2) >$dataDir/logFile/Groove2-$1-$2.log 2>&1

    cd $pwdBefore
}

# export LD_LIBRARY_PATH
for ((i = 0; i < 100; i++)); do
    echo RUN $i begins now -------- >> RunLog.txt
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
done
