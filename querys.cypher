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
