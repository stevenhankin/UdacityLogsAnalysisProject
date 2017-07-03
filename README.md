# Log Analysis
A reporting tool that creates report files for answering the following 3 questions:
1. What are the most popular three articles of all time? 
2. Who are the most popular article authors of all time? 
3. On which days did more than 1% of requests lead to errors?

# Pre-requisites
The folllowing is assumed to already be installed
* Postgres
* Python 3
* psycopg2

# Installation
```
$ git clone https://github.com/stevenhankin/UdacityLogsAnalysisProject.git
$ cd UdacityLogsAnalysisProject
$ psql -d news -f logAnalysis.sql
```

# Views
The additional views required are installed using the **psql** command in the previous installation section

# Usage
Launch the application as follows:
```
$ python3 logAnalysis.py
```
The reports will be generated as results1.txt, results2.txt and results3.txt

