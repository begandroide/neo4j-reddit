// Cual es el subreddit fuente <SourceSubreddit> que produce más post positivos?
MATCH (n:SourceSubreddit {type: 'Source'})-[r:positive_report_on]->(m: TargetSubreddit {type: 'Target'})
WITH n AS n_fuente, COUNT(r) AS cuenta_relaciones
return n_fuente, cuenta_relaciones AS count
ORDER BY cuenta_relaciones DESC;
// id: subredditdrama con 3228 


// Cual es el subreddit fuente que produce más post negativos?
MATCH (n:SourceSubreddit {type: 'Source'})-[r:negative_report_on]->(m:TargetSubreddit {type: 'Target'})
WITH n AS n_fuente, COUNT(r) as cuenta_relaciones
return n_fuente, cuenta_relaciones AS count
ORDER BY cuenta_relaciones DESC;
// id: subredditdrama con 1437


// cual es el subreddit que más post positivos recibe?
MATCH (n:TargetSubreddit {type: 'Target'})<-[r:positive_report_on]-(m:SourceSubreddit {type: 'Source'})
WITH n as n_fuente, COUNT(r) as cuenta_relaciones
return n_fuente, cuenta_relaciones AS count
ORDER BY cuenta_relaciones DESC;
// id: askreddit 6437


// cual es el subreddit que más post negativos recibe?
MATCH (n:TargetSubreddit {type: 'Target'})<-[r:negative_report_on]-(m:SourceSubreddit {type: 'Source'})
WITH n as n_fuente, COUNT(r) as cuenta_relaciones
return n_fuente, cuenta_relaciones AS count
ORDER BY cuenta_relaciones DESC;
// id: askreddit con 892

// detectar ciclos en el grafo
MATCH p=(n)-[*]-(n) RETURN nodes(p);
// no pueden existir ciclos por la naturaleza de las relaciones y los nodos,
// Solo de un nodo tipo SourceSubreddit saldrá una relación, la cual SIEMPRE 
// apunta a un nodo de tipo TargetSubreddit, la cual sabemos que gracias al 
// proceso de carga no saldrán relaciones por lo que no podrá volver al nodo target.

// los 200 links con más número de sentencias
MATCH (n)-[r]->(m)
RETURN n,r,m,r.numberOfSentences AS numberOfSent
ORDER BY r.numberOfSentences DESC
LIMIT 200;

/// determinando polaridad
MATCH (n)-[r]->(m)
WITH type(r) AS tipo, r ORDER BY r.numberOfSentences DESC LIMIT 200
RETURN tipo, Count(tipo) AS link_sentiment;
// positive: 190, negative: 10


// los 200 links con más número de stopwords
MATCH (n)-[r]->(m)
RETURN n,r,m,r.fractionOfStopwords AS fractionStopWords
ORDER BY r.fractionOfStopwords DESC
LIMIT 200;
// 1373

// determinando polaridad
MATCH (n)-[r]->(m)
WITH type(r) AS tipo, r ORDER BY r.fractionOfStopwords DESC LIMIT 200
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


// ¿detectar si un source es un bot?
MATCH (n)-[r]-(m) return n,r,m ORDER BY r.timestamp DESC LIMIT 25;

// fecha y hora en que hubieron más reportes positivos
MATCH ()-[r:positive_report_on]->() 
RETURN r.timestamp as year,count(*) as count
ORDER BY count DESC;

MATCH ()-[r:negative_report_on]->() 
RETURN r.timestamp as year,count(*) as count
ORDER BY count DESC;

// por año y tipo
MATCH ()-[r]->() 
RETURN r.timestamp.year as year, type(r), count(*) as count
ORDER BY year DESC

// día de la semana en que los usuarios están mas activos por tipo de reporte
MATCH ()-[r]->() 
RETURN r.timestamp.dayofWeek as day, type(r), count(*) as count
ORDER BY count DESC;
// 2 -> 1 -> 3 -> 4 -> 5 -> 7 -> 6

// Día de la semana en que los usuarios están mas activos
MATCH ()-[r]->() 
RETURN r.timestamp.dayofWeek as day, count(*) as count
ORDER BY count DESC;
// 2 -> 1 -> 3 -> 4 -> 5 -> 7 -> 6

// hora del día en qe los usuarios están mas activos
MATCH ()-[r]->() 
RETURN r.timestamp.hour as hour, count(*) as count
ORDER BY count DESC;

// pagerank? puede ser algo weno

CALL gds.pageRank.stream({
	nodeProjection: "*",
    relationshipProjection: "*"
})
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).name AS page,gds.util.asNode(nodeId).type, score
ORDER BY score DESC;

// detectando comunidades 
CALL gds.louvain.stream({
	nodeProjection: '*',
    relationshipProjection: '*',
    includeIntermediateCommunities: false
})
YIELD nodeId, communityId
WITH gds.util.asNode(nodeId).name as Name, communityId as commId
RETURN DISTINCT commId, collect(Name);

CALL gds.louvain.write({
	nodeProjection: '*',
    relationshipProjection: '*',
    includeIntermediateCommunities: false,
    writeProperty: 'finalCommunity'
})

MATCH (n)
WITH n.finalCommunity AS community, collect(n.name) as communities
RETURN community, communities, size(communities) as Size
ORDER BY Size DESC;