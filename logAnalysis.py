#!/usr/bin/env python3

import psycopg2


class ViewReporter:
    """Write simple formatted output from view to file"""

    def __init__(self, viewName, destFile):
        """The actual view name and output file are stored in the object.
        Also a connection is opened when the class is instantiated
        """
        self.conn = psycopg2.connect("dbname=news")
        self.viewName = viewName
        self.destFile = destFile

    def run(self):
        """Run the configured view and write to the specified file
        Convention here is for each view to return a single string
        column called 'txt'. This is to make the Python processing
        as simple as possible as per the Rubric
        """
        cur = self.conn.cursor()
        print('Running query for view '+self.viewName, end='...', flush=True)
        # Almost all the runtime occurs during the cursor execution
        cur.execute("select txt from " + self.viewName)
        f = open(self.destFile, 'w')
        # Need to get the first row which also acts
        # as a sentinel value for the while loop
        row = cur.fetchone()
        # All rows to be written to the output file
        while row:
            f.write(row[0] + '\n')
            row = cur.fetchone()
        print('wrote data to '+self.destFile)
        # Tidy up connections, etc
        f.close()
        cur.close()
        self.conn.close()

# Create the report/output pairings as separate objects and run them
# These could also be run in parallel since they are self contained
ViewReporter("report1", "results1.txt").run()
ViewReporter("report2", "results2.txt").run()
ViewReporter("report3", "results3.txt").run()
