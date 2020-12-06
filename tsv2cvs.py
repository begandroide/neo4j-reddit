import sys
import re

if len(sys.argv) == 1:
    print("ERROR: At least one arg (file path)")
    exit(1)

file_name = sys.argv[1]
print(file_name.split("."))
with open(file_name, 'r') as tsv:
   with open(file_name.split(".")[1].replace('\\','') + ".csv", 'w') as csv_file:
     for line in tsv:
       fileContent = re.sub("\t", ",", line)
       csv_file.write(fileContent)

print("Done!")