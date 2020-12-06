LOAD CSV WITH HEADERS FROM "file:///soc-reddit.csv" AS row
return datetime({ epochMillis: apoc.date.parse(row.TIMESTAMP, 'ms', 'yyyy-MM-dd HH:mm:ss')});

LOAD CSV WITH HEADERS FROM "file:///soc-redditHyperlinks-body.tsv" AS row FIELDTERMINATOR '\t'
return row
LIMIT 3;

LOAD CSV WITH HEADERS FROM "file:///soc-redditHyperlinks-body.tsv" AS row FIELDTERMINATOR '\t'
return split(row.PROPERTIES, ",")
LIMIT 3;

LOAD CSV WITH HEADERS FROM "file:///soc-redditHyperlinks-body.tsv" AS row FIELDTERMINATOR '\t'
return split(row.PROPERTIES, ",")[1..21]
LIMIT 3