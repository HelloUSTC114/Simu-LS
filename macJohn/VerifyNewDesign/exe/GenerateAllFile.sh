#!/bin/bash

echo "[workDir(\`pwd\`)] [srcDir(workDir/../src)]"

workDir=`pwd`
srcDir=$workDir/../src/

if [[ $# -ge 2 ]]; then
    workDir=$1
    srcDir=$2
fi

rm -rf $workDir/GDML 2> /dev/null
mkdir $workDir/GDML 2> /dev/null


# Generate Groove Gap research files for single groove

subDir=$workDir/GDML/OmegaGap
rm -rf $subDir 2> /dev/null
mkdir $subDir 2> /dev/null
echo Generating :Folder: $subDir

depth=1.8
fiberR=0.5
width=`echo "1.1*2*${fiberR}" | bc`

for offset in 3.0
do
    for depth in 2.5
    do
        for omegaGap in 0.6
        do
            echo
            filename=Omega-EJ-Width-${width}mm-Depth-${depth}mm-OmegaGap-${omegaGap}mm-Offset-${offset}mm-FiberR-${fiberR}mm.gdml
            echo $filename
            $workDir/ExecFolder/GenerateGDML.sh $subDir/$filename $srcDir ${width} $depth ${omegaGap} $offset Omega EJ ${fiberR}
        done
        
        # # Full round groove test
        # echo
        # filename=Full-EJ-Width-${width}mm-Depth-${depth}mm-OmegaGap-${omegaGap}mm-Offset-${offset}mm-FiberR-${fiberR}mm.gdml
        # echo $filename
        # $workDir/ExecFolder/GenerateGDML.sh $subDir/$filename $srcDir ${width} $depth ${omegaGap} $offset Full EJ ${fiberR}
        
    done
done

# # Genenrate FiberR information
# subDir=$workDir/GDML/FiberR
# rm -rf $subDir 2> /dev/null
# mkdir $subDir 2> /dev/null
# echo Generating :Folder: $subDir

# for fiberR in 0.25 0.5 0.75 1.0
# do
#     offset=3.0
#     omegaGap=0.6
#     depth=2.5
#     width=`echo "1.1*2*${fiberR}" | bc`
    
#     # Omega groove
#     echo
#     filename=Omega-EJ-Width-${width}mm-Depth-${depth}mm-OmegaGap-${omegaGap}mm-Offset-${offset}mm-FiberR-${fiberR}mm.gdml
#     echo $filename
#     $workDir/ExecFolder/GenerateGDML.sh $subDir/$filename $srcDir ${width} $depth ${omegaGap} $offset Omega EJ ${fiberR}
    
#     # Full round groove
#     echo
#     filename=Full-EJ-Width-${width}mm-Depth-${depth}mm-OmegaGap-${omegaGap}mm-Offset-${offset}mm-FiberR-${fiberR}mm.gdml
#     echo $filename
#     $workDir/ExecFolder/GenerateGDML.sh $subDir/$filename $srcDir ${width} $depth ${omegaGap} $offset Full EJ ${fiberR}
    
    
    
# done