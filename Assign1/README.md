CS1XA3 ASSIGNMENT 1
This file documents the work done on the assignment. 

1-For the first function we are asked to make a feature that informs whether the local repo is up to date with remote repo. I used the function "git fetch origin" alongwith "git rev-parse master" for local repo and "git rev-parse remote/master" for remote repo. These commands print SHA1 hashes(used stack overflow to find the commands). If both the local and remote repo output hashes are equal then the repos are up to date and my function echoes that.

2- For the second function I simply used git diff command.

3- For the third function I used the grep feature.

4- For the fourth function I used the command which was hinted by the course instructor in our assignment guidelines.

