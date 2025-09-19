# Documentation

First things first, I created a remote repository on github, then I cloned it from my home path in the shell. 

`git clone https://github.com/chik0di/cde-bootcamp  cde`

I also learned that `git fetch` contacts the remote repo and downloads all the new commits but does not change your working files until you explicitly update it with `git merge`

I went ahead to `mkdir bash-ql` right under `cde` as this directory will hold all the files associated with the solutions to the [Git/Linux tasks](https://github.com/Idowuilekura/cde_linux_git_assignment-/blob/master/README.md)

I started by creating separate folders including `etl` to store folders that will harbor files generated from the pipeline process, there's also `scripts` to store both `shell` and `sql` scripts that contain pipeline code and Manager Ayoola's queries, respecitvely. 

## Extraction and Transformation
### Extraction
For [this task](https://github.com/chik0di/cde-bootcamp/blob/main/bash-ql/etl/raw/task.txt), I downloaded a csv file via `curl` alongside the `-o` flag to output download to some path I had already defined and stored in a variable `RAW_FILE`

### Roadblock I 
In the bash script, I wrote:
```
RAW_DIR="~/cde/bash-ql/raw"
```
but in bash, `~` expands to your home directory only when typed directly in the shell. But when you put it inside quotes, it's read as literal string and creates a directory named `~` with sub-paths `cde` and so on. 

So it's either I remove the path from quotes, or quite preferrably, resort to the `$HOME` default variable.
```
"$HOME/cde/bash-ql/etl/raw"
```

### Transformation

In the [transformation](https://github.com/chik0di/cde-bootcamp/blob/main/bash-ql/etl/transformed/task.txt) of the data pipline, data extracted and stored in `RAW_FILE` which originally had over 10 fields was transformed in the following defined transformation tasks:

1. Rename `Variable_code` column to `variable_code`
2. Select only the `year`, `value`, `Units`, `variable_code`

#### Task 1

I executed task 1 via the `sed` command
- first extract only the column names
- look for a `Variable_code` and change to `variable_code`
```
head -n 1 $RAW_FILE | sed 's/Variable_code/variable_code/'
```
#### Task 2:
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

#### finally 
combine the header and the filtered rows and redirect the output to the `transformed` csv I'd created earlier:
```
{
  head -n 1 $RAW_FILE | sed 's/Variable_code/variable_code/' | cut -d',' -f${year_col},${value_col},${units_col},${var_col}
  tail -n +2 $RAW_FILE | cut -d',' -f${year_col},${value_col},${units_col},${var_col}
} > $TRANSFORMED_FILE
```

### Loading
load the `transformed` csv to the `gold` layer
```
cp $TRANSFORMED_FILE $GOLD_FILE
```

## Working with Databases
- Install postgres along with its clients

```
sudo apt install postgresql postgresql-client
```
- Verify installation
```
psql --version
createdb --version
```
You should see something like psql (PostgreSQL) 16.3.
### Create posey database
- method 1 (from bash)

By default, it uses your Linux username as the PostgreSQL role. If you’re logged in as root, it will try to connect as the Postgres role root.

That’s why it's best practice to run it as the postgres user. 
```
sudo -u postgres createdb posey
```
- method 2
```
# Connect as the postgres system user

sudo -u postgres psql

# Run queries directly inside the the local PostgreSQL server

CREATE DATABASE posey;
```


### Load into `posey` db by summoning the Dump file

Dump files are the most straightforward way to load a postgres database, especially for test purposes. The tasks provided csv on github but `curl` could not access raw github content on my device. 
```
 sudo -u postgres psql -d "$DB_NAME" -f "$DUMP_FILE"
```
The above line:

- Connects to database `posey`
- Executes all SQL commands inside [posey.sql]() 
- Rebuilds the tables, data, and other available db objects.

### Roadblock II    
Ran the [sql script]() that creates the db and loads the [dump file]() and here's the shell output: 
```
Database 'posey' already exists. 

Skipping creation. Loading SQL dump into ... 

psql: error: /root/cde/bash-ql/scripts/sql/parch-posey-dump.sql: Permission denied 

Data loaded into 'posey'.
```
#### problems
- Permission denied when loading the SQL file.

 `psql` (which is running as the `postgres` system user via `sudo -u postgres`) cannot read the `.sql` dump file, because that file lives in root’s home directory and only `root` has access by default, `postgres` doesn't.

- Success message prints even if loading failed. 

Still got the `Data loaded into 'posey'` message 

#### solutions 
1.  move dump file out of `root` user directory `OR` run sql script entirely as `postgres`
```
sudo -i -u postgres
```
I moved the dump file - outside of the root directory. 

Thinking about it now, I should've switched to user `postgres` with the above line instead of using `sudo -u postgres` anytime I wanted to use psql.

Although it will be useful to run queries and `.sql` files, it might not be so ideal to live in it continuously. 

2.  Adjusted the logic to surround the loading process in a conditional statement so it only prints success message if loading happens
```
echo "Loading SQL dump into $DATABASE ..."
if sudo -u postgres psql -d "$DATABASE" -f "$DUMP"; then
    echo "Data successfully loaded into '$DATABASE'."
else
    echo "Failed to load data into '$DATABASE'."
    exit 1
fi
```

## Running SQL Queries in the shell
All queries were written into separate `.sql` files and executed from the shell using psql.

1. Find a list of order IDs where either gloss_qty or poster_qty is greater than 4000. Only include the id field in the resulting table.  

Query: [qty-gt4000.sql](https://github.com/chik0di/cde-bootcamp/blob/main/bash-ql/scripts/sql/qty-gt4000.sql)

2. Write a query that returns a list of orders where the standard_qty is zero and either the gloss_qty or poster_qty is over 1000.

Query: [qty-gt1000.sql](https://github.com/chik0di/cde-bootcamp/blob/main/bash-ql/scripts/sql/qty-gt1000.sql)

3. Provide a table that shows the region for each sales rep along with their associated accounts. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) by account name.

Query: [sales-rep-obs.sql](https://github.com/chik0di/cde-bootcamp/blob/main/bash-ql/scripts/sql/sales-rep-obs.sql)

4. Find all the company names that start with a 'C' or 'W', and where the primary contact contains 'ana' or 'Ana', but does not contain 'eana'. 

Query:
[comp-wldcrd.sql](https://github.com/chik0di/cde-bootcamp/blob/main/bash-ql/scripts/sql/comp-wldcrd.sql)