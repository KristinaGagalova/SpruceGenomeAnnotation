from BeautifulSoup import BeautifulSoup
import csv
import sys
reload(sys)
sys.setdefaultencoding('utf8')

filename = sys.argv[2]
fin      = open(filename,'r')

print "Opening file"
fin  = fin.read()

print "Parsing file"
soup = BeautifulSoup(fin,convertEntities=BeautifulSoup.HTML_ENTITIES)

print "Preemptively removing unnecessary tags"
[s.extract() for s in soup('script')]

print "CSVing file"
tablecount = -1
for table in soup.findAll("table"):
  tablecount += 1
  print "Processing Table #%d" % (tablecount)
  with open(sys.argv[1]+str(tablecount)+'.csv', 'wb') as csvfile:
    fout = csv.writer(csvfile, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
    for row in table.findAll('tr'):
      cols = row.findAll(['td','th'])
      if cols:
        cols = [x.text for x in cols]
        fout.writerow(cols)
