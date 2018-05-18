#!/usr/bin/env wolframscript
(* ::Package:: *)

SetDirectory["/Users/maryam/Google Drive/Research/RF_improvment"]
<<NumberTheoryFunctions.m
<< numberth.m

init[]
U = ReadList[
   "/Users/maryam/Google Drive/Research/RF_improvment/testNTT.txt", 
   Number, RecordLists -> True];
A = U[[1]];
B = U[[2]];
t1 = fnt[A]*fnt[B];
c1 = ifnt[t1];
c1;
Export["/Users/maryam/Google Drive/Research/RF_improvment/outNTT.txt",c1]
