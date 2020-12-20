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

LOAD CSV WITH HEADERS FROM "file:///soc-redditHyperlinks-body.tsv" AS row FIELDTERMINATOR '\t'
WITH DISTINCT row.SOURCE_SUBREDDIT as line
return line
LIMIT 10;

LOAD CSV WITH HEADERS FROM "file:///soc-redditHyperlinks-body.tsv" as row FIELDTERMINATOR "\t"
MERGE (s:Subreddit{name:row.SOURCE_SUBREDDIT})
MERGE (t:Subreddit{name:row.TARGET_SUBREDDIT})
CREATE (s)-[:LINK{post_id:row.POST_ID,
   link_sentiment:toInteger(row.LINK_SENTIMENT),
   date:localDateTime(replace(row['TIMESTAMP'],' ','T'))}]->(t);

CREATE CONSTRAINT ON (s:Subreddit) ASSERT s.name IS UNIQUE;

CREATE CONSTRAINT ON (s:Subreddit) ASSERT (s.id, s.isSource) IS NODE KEY;

LOAD CSV WITH HEADERS FROM "file:///soc-redditHyperlinks-body.tsv" as row FIELDTERMINATOR "\t"
WITH row
WHERE row.SOURCE_SUBREDDIT IS NULL OR row.TARGET_SUBREDDIT IS NULL
RETURN *;

LOAD CSV WITH HEADERS FROM "file:///soc-redditHyperlinks-body.tsv" as row FIELDTERMINATOR "\t"
WITH row LIMIT 100
return DISTINCT row.SOURCE_SUBREDDIT;

// coherencia
MATCH (n:Subreddit {id: 'leagueoflegends'})
return n;

MATCH (n)-[r]-(m) return n,r,m LIMIT 20;


// -----CARGA negative report on----- //
LOAD CSV WITH HEADERS FROM "file:///soc-redditHyperlinks-body.tsv" as row FIELDTERMINATOR "\t"
WITH row, split(row.PROPERTIES, ",")[1..21] as n WHERE row.LINK_SENTIMENT = '-1'
MERGE (s:Subreddit{id:row.SOURCE_SUBREDDIT, type: 'Source'})
MERGE (t:Subreddit{id:row.TARGET_SUBREDDIT, type: 'Target'})
CREATE (s)-[:negative_report_on {
        post_id:row.POST_ID,
        timestamp:datetime({ epochMillis: apoc.date.parse(row.TIMESTAMP, 'ms', 'yyyy-MM-dd HH:mm:ss')}),
        numCharacters:toFloat(n[0]),
        numCharactersWithoutCountingSpace:toFloat(n[1]),
        fractionOfAlphaCharacters:toFloat(n[2]),
        fractionOfDigits:toFloat(n[3]),
        fractionOfUppercaseCharacters:toFloat(n[4]),
        fractionOfWhiteSpaces:toFloat(n[5]),
        fractionOfSpecialCharacters:toFloat(n[6]),
        numberOfWords:toFloat(n[7]),
        numberOfUniqueWords:toFloat(n[8]),
        numberOfLongWords:toFloat(n[9]),
        averageWordLength:toFloat(n[10]),
        numberOfUniqueStopwords:toFloat(n[11]),
        fractionOfStopwords:toFloat(n[12]),
        numberOfSentences:toFloat(n[13]),
        numberOfLongSentences:toFloat(n[14]),
        averageNumberCharactersPerSentence:toFloat(n[15]),
        averageNumberWordsPerSentence:toFloat(n[16]),
        automatedReadabilityIndex:toFloat(n[17]),
        positiveSentiment:toFloat(n[18]),
        negativeSentiment:toFloat(n[19]),
        compoundSentiment:toFloat(n[20])
    }]->(t)


// -----CARGA positive report on----- //
LOAD CSV WITH HEADERS FROM "file:///soc-redditHyperlinks-body.tsv" as row FIELDTERMINATOR "\t"
WITH row, split(row.PROPERTIES, ",")[1..21] as n WHERE row.LINK_SENTIMENT = '1'
MERGE (s:Subreddit{id:row.SOURCE_SUBREDDIT, type: 'Source'})
MERGE (t:Subreddit{id:row.TARGET_SUBREDDIT, type: 'Target'})
CREATE (s)-[:positive_report_on {
        post_id:row.POST_ID,
        timestamp:datetime({ epochMillis: apoc.date.parse(row.TIMESTAMP, 'ms', 'yyyy-MM-dd HH:mm:ss')}),
        numCharacters:toFloat(n[0]),
        numCharactersWithoutCountingSpace:toFloat(n[1]),
        fractionOfAlphaCharacters:toFloat(n[2]),
        fractionOfDigits:toFloat(n[3]),
        fractionOfUppercaseCharacters:toFloat(n[4]),
        fractionOfWhiteSpaces:toFloat(n[5]),
        fractionOfSpecialCharacters:toFloat(n[6]),
        numberOfWords:toFloat(n[7]),
        numberOfUniqueWords:toFloat(n[8]),
        numberOfLongWords:toFloat(n[9]),
        averageWordLength:toFloat(n[10]),
        numberOfUniqueStopwords:toFloat(n[11]),
        fractionOfStopwords:toFloat(n[12]),
        numberOfSentences:toFloat(n[13]),
        numberOfLongSentences:toFloat(n[14]),
        averageNumberCharactersPerSentence:toFloat(n[15]),
        averageNumberWordsPerSentence:toFloat(n[16]),
        automatedReadabilityIndex:toFloat(n[17]),
        positiveSentiment:toFloat(n[18]),
        negativeSentiment:toFloat(n[19]),
        compoundSentiment:toFloat(n[20])
    }]->(t)

// Cual es el subreddit fuente que produce más post positivos?
MATCH (n:Subreddit {type: 'Source'})-[r:positive_report_on]->(m)
WITH n, COUNT(r) as cuenta
return n, cuenta AS count
ORDER BY cuenta DESC;
// id: subredditdrama

// Cual es el subreddit fuente que produce más post negativos?
MATCH (n:Subreddit {type: 'Source'})-[r:negative_report_on]->(m)
WITH n, COUNT(r) as cuenta
return n, cuenta AS count
ORDER BY cuenta DESC;
// id: subredditdrama

// cual es el subreddit que más post positivos recibe?
MATCH (n:Subreddit {type: 'Target'})<-[r:positive_report_on]-(m)
WITH n, COUNT(r) as cuenta
return n, cuenta AS count
ORDER BY cuenta DESC;
// id: askreddit 6437

// cual es el subreddit que más post negativos recibe?
MATCH (n:Subreddit {type: 'Target'})<-[r:negative_report_on]-(m)
WITH n, COUNT(r) as cuenta
return n, cuenta AS count
ORDER BY cuenta DESC;
// id: askreddit con 892

// detectar ciclos en el grafo
MATCH p=(n)-[*1..15]-(n) RETURN nodes(p);
MATCH p=(n)-[*1..30]->(m)-[*1..20]->(n) RETURN nodes(p)

// los 200 links con más número de sentencias
MATCH (n)-[r]->(m)
RETURN n,r,m,r.numberOfSentences AS numberOfSent
ORDER BY r.numberOfSentences DESC
LIMIT 200;

/// determinando polaridad
MATCH (n)-[r]->(m)
WITH type(r) AS tipo, r ORDER BY r.numberOfSentences DESC LIMIT 200
RETURN tipo, Count(tipo) AS link_sentiment;
// positive: 191, negative: 9

// los 200 links con más número de stopwords
MATCH (n)-[r]->(m)
RETURN n,r,m,r.fractionOfStopwords AS fractionStopWords
ORDER BY r.fractionOfStopwords DESC
LIMIT 200;
// 1373

// determinando polaridad
MATCH (n)-[r]->(m)
WITH type(r) AS tipo, r ORDER BY r.numberOfSentences DESC LIMIT 200
RETURN tipo, Count(tipo) AS link_sentiment;
// positive: 195, negative: 5

// los 200 links con mayor uso de mayusc
MATCH (n)-[r]->(m)
RETURN n,r,m,r.fractionOfUppercaseCharacters AS uppercaseCharacters
ORDER BY r.fractionOfUppercaseCharacters DESC
LIMIT 200;
// 0.76

// determinando polaridad
MATCH (n)-[r]->(m)
WITH type(r) AS tipo, r ORDER BY r.fractionOfUppercaseCharacters DESC LIMIT 200
RETURN tipo, Count(tipo) AS link_sentiment;
// positive: 200, negative: 0


