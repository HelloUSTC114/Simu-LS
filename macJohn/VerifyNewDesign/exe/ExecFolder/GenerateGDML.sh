#!/bin/bash

echo Format: "[GeneratedFile] [srcDir(\`pwd\`)] [grooveWidth(1.2)] [grooveDepth(1.8)] [omegaGrooveGap(1.2/2)] [grooveOffset(3)] [Omega/Round/Full] [EJ/Air] [optional: fiberR] [optional: triangleBarL(500)] [optional: coatingThickness(0.12)]"
echo Tips:
echo 1. omegaGroove Gap is valid only "in" Omega mode
echo 2. grooveOffset is valid only "in" Double mode
echo "3. srcDir should be absolute path, and contain folders like DB, Surface, etc."

if [[ $# -lt 8 ]]; then
    echo Error: wrong parameter number: $#
    exit
fi

if [[ -e $1 ]]; then
    echo Error: File exists, please change file name
    exit
fi

GeneratedFile=$1
srcDir=$2
grooveWidth=$3
grooveDepth=$4
omegaGrooveGap=$5
grooveOffset=$6
shape=$7
coupling=$8
fiberR=0.5

triangleBarL=500
triangleBarN0=25
coatingThickness=0.12
if [[ -n ${9} ]]; then
    echo ${9}
    fiberR=${9}
    
    if [[ -n ${10} ]]; then
        echo ${10}
        triangleBarL=${10}
        
        
        if [[ -n ${11} ]]; then
            echo ${11}
            coatingThickness=${11}
        fi
        
        
    fi
fi

echo "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>" >>$GeneratedFile
echo >>$GeneratedFile
echo "<!DOCTYPE gdml [" >>$GeneratedFile
echo "  <!ENTITY Config SYSTEM \"$srcDir/VariableConfig/Config.gdml_entity\">" >>$GeneratedFile
echo "<!ENTITY Property SYSTEM \"$srcDir/DB/PropertyDB.gdml_entity\">" >>$GeneratedFile
echo "<!ENTITY Material SYSTEM \"$srcDir/DB/MaterialDB.gdml_entity\">" >>$GeneratedFile
echo "<!ENTITY Solid SYSTEM \"$srcDir/DB/SolidDB.gdml_entity\">" >>$GeneratedFile
echo "<!ENTITY Surface SYSTEM \"$srcDir/DB/SurfaceDB.gdml_entity\">" >>$GeneratedFile
echo "<!ENTITY Surface_Setup SYSTEM \"$srcDir/Surface/Surface_DefaultSetup.gdml_entity\">" >>$GeneratedFile
echo "<!ENTITY Surface_Property SYSTEM \"$srcDir/Surface/Surface_DefaultProperty.gdml_entity\">" >>$GeneratedFile
echo "<!ENTITY Groove SYSTEM \"$srcDir/Structure/Volume_Groove.gdml_entity\">" >>$GeneratedFile
echo "<!ENTITY Detector SYSTEM \"$srcDir/Structure/Module_Scintillator.gdml_entity\">" >>$GeneratedFile
echo "]>" >>$GeneratedFile


echo "<gdml xmlns:gdml=\"http://gdml.web.cern.ch/GDML/\" " >>$GeneratedFile
echo "  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:noNamespaceSchemaLocation=\"file:///schema/gdml.xsd\">" >>$GeneratedFile
echo "" >>$GeneratedFile
echo "  <define>" >>$GeneratedFile

# cat $srcDir/ExecFolder/Part1 >>$GeneratedFile
echo >>$GeneratedFile
echo "    <!-- Groove Width -->" >>$GeneratedFile
echo "    <variable name=\"grooveWidth\" value=\"${grooveWidth}\"/>" >>$GeneratedFile
echo "    <!-- Groove Depth -->" >>$GeneratedFile
echo "    <variable name=\"grooveDepth\" value=\"${grooveDepth}\"/>" >>$GeneratedFile
echo "    <!-- omegaGrooveGap is useful for omega Groove only, represents air gap  -->" >>$GeneratedFile
echo "    <variable name=\"omegaGrooveGap\" value=\"${omegaGrooveGap}\"/>" >>$GeneratedFile
echo "    <!-- groove offset only is useful while processing 2 grooves and will be modified very often -->" >>$GeneratedFile
echo "    <variable name=\"grooveOffset\" value=\"${grooveOffset}\"/>" >>$GeneratedFile


echo "    <!-- Triangle Bar length -->" >>$GeneratedFile
echo "    <variable name=\"triangleBarL\" value=\"${triangleBarL}\" />" >>$GeneratedFile
echo "    <!-- Total Triangle bars in one detector -->" >>$GeneratedFile
echo "    <variable name=\"triangleBarN0\" value=\"${triangleBarN0}\" />" >>$GeneratedFile
echo "    <!-- Coating Thickness -->" >>$GeneratedFile
echo "    <variable name=\"coatingThickness\" value=\"${coatingThickness}\" />" >>$GeneratedFile
echo >>$GeneratedFile

echo "    <!-- Fiber Radius -->" >>$GeneratedFile
echo "    <variable name=\"fiberR\" value=\"${fiberR}\"/>" >>$GeneratedFile

echo >>$GeneratedFile

cat `dirname $0`/Part2 >>$GeneratedFile
echo >>$GeneratedFile

echo -n "        <volumeref ref=\"Module-${shape:0:3}-${coupling}" >>$GeneratedFile


echo "\" />" >>$GeneratedFile

cat `dirname $0`/Part3 >>$GeneratedFile
echo >>$GeneratedFile
