#!/bin/bash

# remove the line containing the current user's open repo
grep -vE "($UID)" currently-open-repo.txt > .temp.txt
mv .temp.txt currently-open-repo.txt