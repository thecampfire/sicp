#############################################################################
#
#  TODO: use fuzzpy to do fuzzy set intersection in fuzzy company name matcher
#        - will only work on Python 2.7.10
#
#
#
#############################################################################

import sqlite3
import re
from difflib import SequenceMatcher as SM
from fuzzywuzzy import fuzz



# regexr.com @[\w-_]+(\.\w+){1,}$
# gets hostname from email address
def strip_email (email):
    return email.split('@')[-1].upper()



def webmail_to_none (url):
  uppercase_url = url.upper()
  webmail_urls = "GMAIL.COM|MSN.COM|HOTMAIL.COM|ME.COM|COMCAST.NET|YAHOO.COM"
  if (re.fullmatch(webmail_urls, uppercase_url) is None):
    return uppercase_url
  else:
    return None

def url_from_email (email_list):
  clean_urls = []
  for em in email_list:
    clean_urls.append(webmail_to_none(strip_email(em)))
  result = list(filter(None.__ne__, clean_urls))
  return result


# strips spaces and special characters from company names and converts to uppercase
def name_cleanup (name):
  result = re.sub("[^0-9a-zA-Z]+", "", name).upper()
  return result



def name_cleanup_inc (name):
  #TODO INC|LTD|LLC|SAB
  return name

def company_list_cleanup (company_list):
  clean_comps = []
  for c in company_list:
    clean_comps.append(name_cleanup(c))
#  result = list(filter(None.__ne__, clean_urls))
  return clean_comps




def match_by_email (db_connection):
  c = db_connection.cursor()
  c.execute("SELECT Email FROM FL_Bought")
  florida_emails = c.fetchall()

  c.execute("SELECT EmailAddress FROM FL_SAMPLE")
  sample_emails = c.fetchall()

  print("%d emails in Sample" % len(sample_emails))
  print("%d emails in Florida" % len(florida_emails))

  result = set(sample_emails).intersection(florida_emails)

  return result



def match_by_url (db_connection):
  florida_urls = []
  sample_urls = []

  c = db_connection.cursor()
  c.execute("SELECT Email FROM FL_Bought")
  #this is a list of tuples
  florida_emails = c.fetchall()
  florida_emails = [x[0] for x in florida_emails]

  c.execute("SELECT EmailAddress FROM FL_SAMPLE")
  #another list of tuples
  sample_emails = c.fetchall()
  sample_emails = [s[0] for s in sample_emails]

  print("%d emails in Sample" % len(sample_emails))
  print("%d emails in Florida" % len(florida_emails))


  florida_urls = url_from_email(florida_emails)
  sample_urls = url_from_email(sample_emails)

  result = set(sample_urls).intersection(florida_urls)

  return result



def match_by_company (db_connection):
  florida_companies = []
  sample_companies = []

  c = db_connection.cursor()
  c.execute("SELECT CompanyName FROM FL_Bought")
  #this is a list of tuples
  florida_comps = c.fetchall()
  florida_comps = [x[0] for x in florida_comps]

  c.execute("SELECT CompanyName FROM FL_SAMPLE")
  #another list of tuples
  sample_comps = c.fetchall()
  sample_comps = [s[0] for s in sample_comps]

  print("%d companies in Sample" % len(sample_comps))
  print("%d companies in Florida" % len(florida_comps))


  florida_companies = company_list_cleanup(florida_comps)
  sample_companies = company_list_cleanup(sample_comps)

  result = set(sample_companies).intersection(florida_companies)

  return result




def match_by_company_fuzzy (db_connection):
  florida_companies = []
  sample_companies = []

  c = db_connection.cursor()
  c.execute("SELECT CompanyName FROM FL_Bought")
  #this is a list of tuples
  florida_comps = c.fetchall()
  florida_comps = [x[0] for x in florida_comps]

  c.execute("SELECT CompanyName FROM FL_SAMPLE")
  #another list of tuples
  sample_comps = c.fetchall()
  sample_comps = [s[0] for s in sample_comps]

  print("%d companies in Sample" % len(sample_comps))
  print("%d companies in Florida" % len(florida_comps))


  florida_companies = company_list_cleanup(florida_comps)
  sample_companies = company_list_cleanup(sample_comps)
  result = []

  result = [x for x in sample_companies for y in florida_companies if fuzz.ratio(x, y) > 70]

  return result


#####

print("************* RESTARTING **********************")

conn = sqlite3.connect("FLDATA")

#email_matches = match_by_email(conn)
#print("Email matches: %d" % len(email_matches))

#test_email_list = ["dragos.ilinca@spacecademy.com", "test@msn.com", "whoever.it.is@me.com"]

#url_matches = match_by_url(conn)
#print(url_matches)
#print("URL matches: %d" % len(url_matches))

company_matches = match_by_company(conn)
print(company_matches)
print("Company Name matches: %d" % len(company_matches))

company_matches_fuzzy = match_by_company_fuzzy(conn)
print(company_matches_fuzzy)
print("Fuzzy matches: %d" % len(company_matches_fuzzy))

conn.close()
