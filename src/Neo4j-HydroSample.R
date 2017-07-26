###First Version to create Neo4j database.
library(RNeo4j)
library(xlsx)

#Connect to the graph.
graph <- startGraph("http://localhost:7474/db/data/", username = "neo4j", password= "NEO4J")

# import excel file
#build_import <- read.xlsx("/Users/CAO/Desktop/GSoC/project/SummerDocs/data2017/Wasser-sample1.xlsx", 
#       sheetIndex = 1)

## clear the entire database
clear(graph)

# query = "
# load csv with headers from "file:"/Users/CAO/Desktop/GSoC/project/SummerDocs/data2017/Wasser-sample1.csv" as centers"

# cypher(graph, query)






#Add uniqueness constraint.
constraints <- c("CREATE CONSTRAINT ON (ds:DataSource) ASSERT ds.name IS UNIQUE",
                 "CREATE CONSTRAINT ON (ppds:PowerPlantDataset) ASSERT ppds.name IS UNIQUE",
                 "CREATE CONSTRAINT ON (sd:SpacialData) ASSERT sd.name IS UNIQUE",
                 "CREATE CONSTRAINT ON (tp:TemporalData) ASSERT tp.datetime IS UNIQUE",
                 "CREATE CONSTRAINT ON (ut:Unit) ASSERT ut.name IS UNIQUE")
lapply(constraints, cypher, graph = graph)

#addConstraint(graph,"DataSource","name")

#addConstraint(graph,"PowerPlantDataset","name")

#addConstraint(graph,"SpacialData","name")
#addConstraint(graph,"TemporalData","datetime")

#addConstraint(graph,"Unit","name")

#Create Nodes.
swissgrid = createNode(graph, "DataSource", name = "Data Set Swissgrid")

nuclear = createNode(graph, "PowerPlantDataset", name = "Nuclear Power Plant")
hydro = createNode(graph, "PowerPlantDataset", name = "Hydro Power Plant")

ch = createNode(graph, "SpacialData", name = "CH")
de = createNode(graph, "SpacialData", name = "DE")
fr = createNode(graph, "SpacialData", name = "FR")

d01012017 = createNode(graph, "TemporalData", datetime = "01-01-2017")
d01022017 = createNode(graph, "TemporalData", datetime = "01-02-2017")

mw = createNode(graph, "Unit", name = "MW" )
kwh = createNode(graph, "Unit", name = "kWh")

#Create relationships.
#all_datasources = getNodes(graph, "MATCH (n) WHERE n:DataSource RETURN n")
rels_n = createRel(nuclear, "SOURCED_FROM",swissgrid, color = "Blue")
rels_h = createRel(hydro, "SOURCED_FROM", swissgrid)

rels_n1 = lapply(list(ch, de), function(g) createRel(nuclear, "HAS_LOCATION",g, color = "Green"))
all_locations = getNodes(graph, "MATCH (n) WHERE n:SpatialData RETURN n")
rels_h1 = lapply(all_locations, function(g) createRel(hydro, "HAS_LOCATION",g))

all_datetimes = getNodes(graph, "MATCH (n) WHERE n:TemporalData RETURN n")
rels_n2 = lapply(all_datetimes, function(g) createRel(nuclear, "HAS_PROPERTY",g, color = "Red"))
rels_h2 = lapply(all_datetimes, function(g) createRel(hydro, "HAS_PROPERTY",g))

all_units = getNodes(graph, "MATCH (n) WHERE n:Unit RETURN n")
rels_n3 = lapply(all_units, function(g) createRel(hydro, "HAS_UNIT",g, color = "Gray"))

#Open the browser.
browse(graph)

