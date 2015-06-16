
import pprint
import sqlite3
conn = sqlite3.connect("FL_Sample")
c = conn.cursor()

c.execute("SELECT EmailAddress FROM FL_sample")

tmp = c.fetchall()

print(len(tmp))

conn.close()
