import psycopg2

conn = psycopg2.connect("dbname=news")

cur = conn.cursor()

class ViewReporter:
    """Write simple formatted output from view to file"""

    def __init__(self, viewName, destFile):
        self.viewName = viewName
        self.destFile = destFile

    def run(self):
        print('Running query for view '+self.viewName)
        cur.execute("select txt from " + self.viewName)
        print('Writing data to '+self.destFile)
        f = open(self.destFile, 'w')
        row = cur.fetchone()
        while row:
            f.write(row[0] + '\n')
            row = cur.fetchone()
        f.close()


ViewReporter("report1", "results1.txt").run()
ViewReporter("report2", "results2.txt").run()
ViewReporter("report3", "results3.txt").run()

cur.close()
conn.close()
