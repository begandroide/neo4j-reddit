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
LIMIT 3;

// Crear nodo tipo source

LOAD CSV WITH HEADERS FROM "file:///soc-redditHyperlinks-body.tsv" AS row FIELDTERMINATOR '\t'
CREATE (n:Source)
SET n = row,
n.SOURCE_SUBREDDIT = toFloat(row.SOURCE_SUBREDDIT);

LOAD CSV WITH HEADERS FROM "file:///soc-redditHyperlinks-body.tsv" AS row FIELDTERMINATOR '\t'
CREATE (n:SUBREDDIT), (m: SUBREDDIT)
SET n = row, m = row,
n.name = row.SOURCE_SUBREDDIT,
n.isSource = true,
m.name = row.TARGET_SUBREDDIT,
m.isSource = false;

LOAD CSV WITH HEADERS FROM "file:///soc-redditHyperlinks-body.tsv" AS row FIELDTERMINATOR '\t'
CREATE (n:Source)
SET n = row,
n.SOURCE_SUBREDDIT = toFloat(row.SOURCE_SUBREDDIT),
n.TARGET_SUBREDDIT = toFloat(row.TARGET_SUBREDDIT),
n.POST_ID = toInteger(row.POST_ID),
n.TIMESTAMP = datetime({ epochMillis: apoc.date.parse(row.TIMESTAMP, 'ms', 'yyyy-MM-dd HH:mm:ss')}),
n.POST_LABEL = toFloat(row.LINK_SENTIMENT),
n.PROPERTIES = split(row.PROPERTIES, ",")[1..21];