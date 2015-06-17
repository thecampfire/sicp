
import sqlite3
import re


# regexr.com @[\w-_]+(\.\w+){1,}$
# gets hostname from email address
def strip_email (email):
  return email.split('@')[-1]

# strips spaces and special characters from company names and converts to uppercase
def name_cleanup (name):
  result = re.sub("[^a-zA-Z]+", "", name).upper()
  return result

def name_cleanup_inc (name):
  #TODO Inc|inc|LLC|Llc|llc

conn = sqlite3.connect("FLDATA")
c = conn.cursor()

c.execute("SELECT Email FROM FL_Bought")

florida = c.fetchall()

c.execute("SELECT EmailAddress FROM FL_SAMPLE")

sample = c.fetchall()

print(len(sample))
print(len(florida))

result = set(sample).intersection(florida)
print(len(result))

match = len(result)/len(sample)*100
print('%f %%' % match)

conn.close()
