// Crear Constraints
CREATE CONSTRAINT ON (s:SourceSubreddit) ASSERT s.name IS UNIQUE;
CREATE CONSTRAINT ON (s:TargetSubreddit) ASSERT s.name IS UNIQUE;

// Cargar solo fuentes
LOAD CSV WITH HEADERS FROM "file:///soc-redditHyperlinks-body.tsv" AS row FIELDTERMINATOR '\t'
WITH DISTINCT row.SOURCE_SUBREDDIT as source
CREATE (n:SourceSubreddit { name: source, type: 'Source' });

// Cargar solo targets
LOAD CSV WITH HEADERS FROM "file:///soc-redditHyperlinks-body.tsv" AS row FIELDTERMINATOR '\t'
WITH DISTINCT row.TARGET_SUBREDDIT as target
CREATE (n:TargetSubreddit { name: target, type: 'Target' });

// Crear relación positive report
LOAD CSV WITH HEADERS FROM "file:///soc-redditHyperlinks-body.tsv" as row FIELDTERMINATOR "\t"
WITH row, split(row.PROPERTIES, ",")[1..21] as n WHERE row.LINK_SENTIMENT = '1'
MERGE (s:SourceSubreddit {name:row.SOURCE_SUBREDDIT, type: 'Source'})
MERGE (t:TargetSubreddit {name:row.TARGET_SUBREDDIT, type: 'Target'})
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

// Crear relación negative report
LOAD CSV WITH HEADERS FROM "file:///soc-redditHyperlinks-body.tsv" as row FIELDTERMINATOR "\t"
WITH row, split(row.PROPERTIES, ",")[1..21] as n WHERE row.LINK_SENTIMENT = '-1'
MERGE (s:SourceSubreddit {name:row.SOURCE_SUBREDDIT, type: 'Source'})
MERGE (t:TargetSubreddit {name:row.TARGET_SUBREDDIT, type: 'Target'})
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

