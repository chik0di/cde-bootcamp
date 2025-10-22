"""
This Python script performs the transformation step of the Wikipedia Pageviews ETL pipeline.

It reads the unzipped Wikipedia pageviews text file for a specific hour, 
filters the rows to keep only the pageviews for selected companies 
(Apple, Amazon, Google, Microsoft, and Facebook), 
and then pushes the filtered results to XCom for downstream tasks in Airflow.

This step ensures that only relevant data is passed to the next stage (loading into the database),
making the pipeline more efficient and focused on the project’s sentiment analysis goals.
"""
import os
import logging

input_path="/opt/airflow/dags/wikimedia/viewzone/pageviews-20251011-180000"
target_companies=['Amazon', 'Apple', 'Facebook', 'Google', 'Microsoft']
output_file=input_path+"_filtered.txt"

def select_companies():
    if not os.path.exists(output_file):
        filtered_rows=[]
        with open(input_path, 'r', encoding='utf-8', errors='ignore') as f:
            for row in f:
                parts = row.strip().split()
                if len(parts)>=2:
                    title = parts[1]
                    if title in target_companies:
                        filtered_rows.append(row.strip())
        
        with open(output_file, "w") as x:
            x.write("\n".join(filtered_rows))
        logging.info(f"Filtered data saved to: {output_file}")
    else:
        logging.info(f"File already exists: {output_file}")