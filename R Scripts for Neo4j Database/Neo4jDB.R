###First Version to create Neo4j database.
library(RNeo4j)

#Connect to the graph.
graph <- startGraph("http://localhost:7474/db/data/")

#Add uniqueness constraint.
addConstraint(graph,"DataSource","name")

addConstraint(graph,"PowerPlantDataset","name")

addConstraint(graph,"SpacialData","name")
addConstraint(graph,"TemporalData","datetime")

addConstraint(graph,"Unit","name")

#Create Nodes.
swissgrid = createNode(graph, "DataSource", name = "Data Set Swissgrid")

nuclear = createNode(graph, "PowerPlantDataset", name = "Nuclear Power Plant")
hydro = createNode(graph, "PowerPlantDataset", name = "Hydro Power Plant")

ch = createNode(graph, "SpacialData", name = "CH")
de = createNode(graph, "SpacialData", name = "DE")
fr = createNode(graph, "SpacialData", name = "FR")

01012017 = createNode(graph, "TemporalData", datetime = "01-01-2017")
01022017 = createNode(graph, "TemporalData", datetime = "01-01-2017")

mw = createNode(graph, "Unit", name = "MW" )
kwh = createNode(graph, "Unit", name = "kWh")

#Create relationships.
all_datasets = getNodes(graph, "MATECH n WHERE n:PowerPlantDataset RETURN n")
rels_n = lapply(all_datasets, function(g) createRel(nuclear, "SOURCED_FROM",g))
rels_h = lapply(all_datasets, function(g) createRel(hydro, "SOURCED_FROM",g))

rels_n1 = lapply(list(ch, de), function(g) createRel(nuclear, "HAS_LOCATION",g, color = "Green"))
all_locations = getNodes(graph, "MATECH n WHERE n:SpatialData RETURN n")
rels_h1 = lapply(all_locations, function(g) createRel(hydro, "HAS_LOCATION",g))

all_datetimes = getNodes(graph, "MATECH n WHERE n:TemporalData RETURN n")
rels_n2 = lapply(all_datetimes, function(g) createRel(nuclear, "HAS_PROPERTY",g, color = "Red"))
rels_h2 = lapply(all_datetimes, function(g) createRel(hydro, "HAS_PROPERTY",g))

all_unit = getNodes(graph, "MATECH n WHERE n:Unit RETURN n")
rels_n3 = lapply(all_units, function(g) createRel(hydro, "HAS_UNIT",g, color = "Gray"))

#Open the browser.
browse(graph)

