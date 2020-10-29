#!/bin/bash

FILENAME=environment_airq_measurand.csv
DESTPATH=$1

wget -O $FILENAME https://gist.githubusercontent.com/jvillarf/040c91397d779d4da02fff54708ca935/raw/f1dbbcbfbc4e3daace7d907a3cc5b716ef808014/environment_airq_measurand.csv

sed -i '1d' $FILENAME

if [ ! -z $DESTPATH ]; then
  mkdir -p $DESTPATH
  mv $FILENAME $DESTPATH
fi

