#!/bin/bash
#Part 1
# Check if Repo is up to date
$(git fetch origin)
localRepo=(git rev-parse master)  #gives an output
remoteRepo=(git rev-parse remote/master)  #gives an output
if [ $localRepo == $remoteRepo ]  #if the outputs are same then the repos are up to date with each other
then
    echo "Local Repo is up to date with Remote Repo"
else
    echo "Local Repo is not up to date with Remote Repo"
fi

#Part 2
#Put all uncommitted changes in a file changes.log
git diff $1 >> changes.log 

#Part 3
# Puts each line from every file of your project with the tag #TODO into a file todo.log
grep -r "#TODO" $1 >> todo.log  # grep function searches for PATTERN in each file or standard input

#Part 4
#Check all haskell files for syntax errors and puts the result into error.log
ghc -fno-code *.hs $1 >> error.log  # ghc -fno-code.hs hint given on the course website

#Part 5
#Make your own feature

