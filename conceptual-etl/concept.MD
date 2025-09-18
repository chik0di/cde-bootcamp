# Conceptual End-to-End Customer Complaint Data Pipeline for Beejan Technologies

## What is the Problem?
Every day, thousands of customers complain about issues like poor network, incorrect billing, or bad customer service. These complaints come through different channels: social media, call center log files, SMS, and website forms. The management is frustrated. Data is stored in different formats. The reporting team manually compiles spreadsheets. No single pipeline exists for this data flow. Reports are delayed. Teams work in silos. They ask you to design a solution to bring all this data together, clean it, enrich it and make it ready to provide actionable insights.


The guiding questions provided by the manager to help shape my design thinking was instrumental to the building of this conceptual pipeline.

## My Approach
### What are the Data Sources and what format will they be ingested as? (Data Sources Container)
Customer complaints will come through different channels like Social Media, Call Centre Log Files, SMS feeds to collect complaints directly from customers, and the company’s Website Forms which will very likely be structured. What else will come in structured? The Call Centre Log Files.	However, I expect semi-structured json format for data that will be ingested via API like the Twitter posts and SMS feeds - both with unstructured text fields that will contain the actual tweets and SMS, respectively. 

### Methods of Ingestion 
A Streaming API ingestion will be ideal to extract from Social Media platforms like Twitter and SMS feeds in real-time. But in reality, we’re not trying to build a monitoring system, so a millisecond-level freshness is not really the goal, we just have a data organization problem, so why not Microbatching?. That way, the risk of data loss that might come from a full batch ingestion is curbed and the cost of real-time streaming infrastructure is saved. 

Data captured in structured formats (e.g., Website Forms and Logs) is probably stored somewhere in a database after capturing, and can be ingested through database connectors. Otherwise, we can schedule a batch upload.
In addition, to reduce strain on the source systems, I can implement incremental ingestion, pulling only new or updated records since the last run, rather than re-extracting the entire dataset each time. This approach reduces network and storage costs, and speeds up the overall ETL process.

### Raw Data Storage (Storage Container)
A data lake will be useful for dumping data in their rawest form, before they can now proceed to a processing layer where they will be transformed alongside data from other sources so that in the end, they can all co-exist in a structured format in the Data Warehouse.


### How will you clean and standardize the data? (Data Transformation Container)
I’ll look into Schema Validation, as in enforcing that all data matches expected schema (this will include additional columns for data source and ingestion timestamp). Data Cleaning will then be performed to eliminate duplicate complaints, handle null values, and Data Type conversion to assign appropriate data types and ensure a consistent format for each column.
Up next is the Natural Language Processing (NLP) includes Text Normalization that will be performed on tweets and SMSs to remove emojis, hashtags, mentions, special characters and the Text Classification that will classify complaints into categories ie. billing, network, customer service. These fields are now aligned into the warehouse schema, as in Schema Mapping.

### Cleaned data storage and usage by downstream users
Cleaned and standardized data should ideally be stored in a columnar format like Parquet in the Warehouse. The reporting team can either connect BI tools directly to the warehouse for real-time dashboards, or consume periodic CSV extracts where lightweight sharing is enough. 

### How often will this pipeline run? The Pipeline Mechanics  
Knowing fully well this pipeline’s main goal is to provide clean, integrated, and structured data for those in the reporting team, not immediate incident response, I won’t need the overhead of streaming ingestion. So, it can be scheduled to run daily at off-peak hours ie. times of the day when system usage and user activity are at their lowest, That way, I’ll optimize resource utilization. It's like turning off lights in an empty room - efficient and cost-effective. 

What bothers me more is that… since yesterday’s records are already in the warehouse, reloading them daily would be wasteful, slow and costly too. I will have to implement Incremental Loading, where you only bring in records since the last loading. It’s cheaper, faster and will reduce strain on the warehouse. I just have to ensure ingestion timestamps and change logs are taken very seriously.  

### How will failures be detected or notified?
Job-level monitoring with alerting. What do I mean? Failure is detected by some tool; alerts are sent; automatic retries are run for failed task(s) before escalation. If retries fail, the data engineer, aka Me, investigates, fixes the root cause, and then reruns the failed task or the whole pipeline manually before the next reporting cycle. 

### Where will the pipeline run? 
The pipeline typically runs where the compute + storage are located, often close to the data lake / warehouse to minimize latency - the delay between data being available at the source and data being usable at the destination, whilst keeping costs under control. 

### How will you make it available in production?
The pipeline will be fully written as code and stored in version control. This ensures all  changes are tracked, tested, and automatically deployed to the compute environment through continuous integration and deployment (CI/CD). 

![Fun GIF](https://media4.giphy.com/media/v1.Y2lkPTc5MGI3NjExY2JtZ2Z5aGw4YWxxaHFnZWpzdDNvOXp2MHQ1MXBkcnJpZXc3NzV2aiZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/zZzPJn8QoMZKfSaIQs/giphy.gif)
