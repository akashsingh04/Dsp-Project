#!/bin/bash

FileList="../../scripts/FileList.txt"
TextFile="../../scripts/HarvardList.dat"

DirI="../../ORIG/"
DirO="../"

DBID="48k"

ProcText="\
recording_conditions: Anechoic room, Sony ECM-909A microphone,\\
Sony TCD-D2 DAT recorder"

#==========
function ProcFile ()
{
  local FileI
  local FileO
  local Info
  local CFile

# Change the input file extension to .au
  FileI=`expr "$1" : '\(.*\)\.'`.au
  FileO=$2

  mkdir -p `dirname $FileO`

  mean=`CompAudio "$FileI" | sed -n '7p' | sed -n 's/.*Mean = //p'` 
  rmean=`printf "%.0f" $mean`
  offs=`expr -1 \* $rmean`
  if [ $offs -ge 0 ]; then
    offs="+$offs"
  fi

  FileDate=`InfoAudio -i1 $FileI | sed -n 's/.*Number of .*)  //p'`
  if [ "$FileDate" = "" ]; then
    echo "Error: no date information found" 1>&2
    exit 1
  fi
  FileDate=`date -d "$FileDate" '+%Y-%m-%d %H:%M:%S UTC'` # Date, standard form

  GenInfoString "$FileI" "$TextFile" "$FileDate"

  CopyAudio $FileI -cA "A$offs" -I "$Info" -D integer16 $FileO
  touch -r $FileI $FileO   # Set the output file date

  InfoAudio -i5 "$FileO"
}

# functions
. ../../scripts/FAF.sh
