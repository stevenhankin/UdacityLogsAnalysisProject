# Log Analysis
A reporting tool that demonstrates how to report on a Postgres "news" database that contains information on website usage for a newspaper.
The application will generate 3 report files in text format:
1. results1.txt - Most popular three articles of all time
2. results2.txt - Most popular article authors of all time
3. results3.txt - Days where more than 1% of requests lead to errors

# Pre-requisites
The folllowing is assumed to already be installed
* Postgres + installed "news" schema
* Python 3
* psycopg2

# Installation
The following will setup the program, create a "news" database and populate with data:
```
$ git clone https://github.com/stevenhankin/UdacityLogsAnalysisProject.git
$ cd UdacityLogsAnalysisProject
$ unzip newsdata.zip
$ psql -f logAnalysis.sql
```

# Views
The additional views required are installed using the **psql** command in the previous installation section

# Usage
Launch the application as follows:
```
$ python3 logAnalysis.py
```
The reports will be generated as results1.txt, results2.txt and results3.txt

