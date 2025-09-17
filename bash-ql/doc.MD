## This documentation exists primarily so I don't forget my sweat and tears

First things first, I created a remote repository on github, then I cloned it from my home path in the shell. 

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

So it's either I remove the path from quotes, or quite preferrably, resort to the `$HOME` default variable.
```
"$HOME/cde/bash-ql/etl/raw"
```

## Stage Two

In the [second stage](https://github.com/chik0di/cde-bootcamp/blob/main/bash-ql/etl/transformed/task.txt) of the data pipline, data extracted and stored in `RAW_FILE` which originally had over 10 fields was transformed in the following defined transformation tasks:

1. Rename `Variable_code` column to `variable_code`
2. Select only the `year`, `value`, `Units`, `variable_code`

### for task 1

I executed task 1 via the `sed` command
- first extract only the column names
- look for a `Variable_code` and change to `variable_code`
```
head -n 1 $RAW_FILE | sed 's/Variable_code/variable_code/'
```
### for task 2:
- extract the headers
- replace the commas with a new line
- collect the line number of the fields we want (returns as 1:Year, 4:Value)
- split() it with a colon as the delimiter and collect the item before the delimiter. 
- goal is to store the position of the columns and use it to locate the content of the columns we want to extract
```
year_col=$(head -1 $RAW_FILE | tr ',' '\n' | grep -n -w "Year" | cut -d: -f1)
value_col=$(head -1 $RAW_FILE | tr ',' '\n' | grep -n -w "Value" | cut -d: -f1)
units_col=$(head -1 $RAW_FILE | tr ',' '\n' | grep -n -w "Units" | cut -d: -f1)
var_col=$(head -1 $RAW_FILE | tr ',' '\n' | grep -n -w "Variable_code" | cut -d: -f1)
```

### finally 
combine the header and the filtered rows and redirect the output to the `transformed` csv I'd created earlier:
```
{
  head -n 1 $RAW_FILE | sed 's/Variable_code/variable_code/' | cut -d',' -f${year_col},${value_col},${units_col},${var_col}
  tail -n +2 $RAW_FILE | cut -d',' -f${year_col},${value_col},${units_col},${var_col}
} > $TRANSFORMED_FILE
```

### finally finally 
load the `transformed` csv to the `gold` layer
```
cp $TRANSFORMED_FILE $GOLD_FILE
```

# Working with Databases
up next.. 