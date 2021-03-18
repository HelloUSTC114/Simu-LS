#!/bin/bash

for yield in 25 30 35 40 45 50 55 60 65 70 75 80
do
    cp Test.gdml Yield-$yield.gdml
done

for absLength in 100 130 160 200 250 300 400 500 700 900 1200 1500
do
    cp Test.gdml AbsLength-$absLength.gdml
done