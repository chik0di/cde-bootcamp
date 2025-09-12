## This documentation exists primarily so I don't forget my sweat and tears

First things first, I created a remote repository on github, then I cloned it from my ome path in the shell. 

`git clone https://github.com/chik0di/cde-bootcamp  cde`

I also learned that `git fetch` contacts the remote repo and downloads all the new commits but does not change your working files until you explicitly update it with `git merge`

I went ahead to `mkdir bash-ql` right under `cde` as this directory will hold all the files associated with the solutions to the [Git/Linux tasks](https://github.com/Idowuilekura/cde_linux_git_assignment-/blob/master/README.md)

I started by creating separate folders including `etl` to store folders that will harbor files generated from the pipeline process, there's also `scripts` to store both `shell` and `sql` scripts that contain pipeline code and Manager Ayoola's queries, respecitvely. 

## Stage One
For [stage one](https://github.com/chik0di/cde-bootcamp/blob/main/bash-ql/etl/raw/task.txt), I downloaded a csv file via `curl` alongside the `-o` flag to output download to some path I had already defined and stored in a variable `RAW_FILE`

#### Encounter - mistakenly created funny directories
In the bash script, I wrote:
```
RAW_DIR="~/cde/bash-ql/raw"
```
but in bash `~` expands to your home directory only when typed directly in the shell.
When you put it inside quotes ("~/cde/bash-ql/raw"), it becomes a literal string (~/cde/...) instead of expanding. 

## Stage Two

In the [second stage](https://github.com/chik0di/cde-bootcamp/blob/main/bash-ql/etl/transformed/task.txt) of the data pipline, data extracted and stored in `RAW_FILE` which originally had over 10 fields was transformed in the following defined transformation tasks:

1. Rename `Variable_code` column to `variable_code`
2. Select only the `year`, `value`, `Units`, `variable_code`

I executed task 1 via the `sed` command
```
head -n 1 $RAW_FILE | sed 's/Variable_code/variable_code/'
```