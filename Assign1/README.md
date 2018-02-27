CS1XA3 Assignment 1
PURPOSE
To create a bash script that does the following-
•	Informs whether the local repo is up to date with the remote repo.
•	Puts all uncommitted changes in a file changes.log
•	Puts each line from every file of your project with the #TODO into a file todo.log
•	Checks all Haskell errors and puts the result into a file todo.log
•	One feature of your own making.

PART 1
For the first part I referenced ( https://github.com/deleeuwj1) but made the changes on the commands that I used. 
I used the rev-parse master and rev-parse remote/master to print the SHA1 hashes. I found this information on (https://stackoverflow.com/questions/15798862/what-does-git-rev-parse-do) stack overflow.
My function echoes whether the local repo is up to date with the remote repo.

PART 2
For the 2nd part I used git diff and (>>) to put the uncommitted changes into the file changes.log
The additional feature that I included asks the user whether they want view the file.

PART 3
For the 3rd I used the grep function to search for the tag #TODO.
The additional feature asks the viewer whether they want to view the file.

PART 4
For the 4th part I used the hint that the instructor provided us in the assignment info.

PART 5
The feature that I included in the file lets the user know how many executable and non executable commands are in the path.
for this feature I referenced the textbook Wicked Cool Shell Scripts (https://nostarch.com/wcss2) Chapter 2- Improving User's commands.
The IFS command was refernced from (http://mindspill.net/computing/linux-notes/using-the-bash-ifs-variable-to-make-for-loops-split-with-non-whitespace-characters/)
The parameters used in the feature were refernced from (http://mywiki.wooledge.org/BashSheet#Parameter_Operations)

ADDITIONAL 
The concept for viewing the files created was refernced from (https://github.com/elwazana)

