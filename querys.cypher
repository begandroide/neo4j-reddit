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
