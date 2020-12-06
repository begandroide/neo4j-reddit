# neo4j-reddit

Debemos tener Java instalado, ojalá en su última versión.

## Neo4j on EC2 aws

Una vez instalado Neo4j, podemos acceder a través del browser consultando la ip con el 
puerto 7474.

Para instalar nuevos plugins sin Neo4j para escritorio podemos descargar los plugins 
directamente sobre el directorio `$NEO4J_HOME/plugins` utilizando por ejemplo:

```bash
wget https://github.com/neo4j-contrib/neo4j-apoc-procedures/releases/download/3.5.0.12/apoc-3.5.0.12-all.jar
```

## Archivo de configuración de Neo4j

Está en el directorio `$NEO4J_HOME/conf`, aquí podemos setear ip's determinadas, redireccionar
puertos y también podemos añadir configuraciones de los plugins.