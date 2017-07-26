###First Version to create Neo4j database.
library(RNeo4j)

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
constraints <- c("CREATE CONSTRAINT ON (hppd:HydroPowerPlantDataset) ASSERT hppd.name IS UNIQUE",
                 "CREATE CONSTRAINT ON (sd:SpacialData) ASSERT sd.name IS UNIQUE",
                 "CREATE CONSTRAINT ON (ut:UNIT) ASSERT ut.name IS UNIQUE")

lapply(constraints, cypher, graph = graph)

#Create Nodes.
n100100 = createNode(graph, "HydroPowerPlantDataset", name = "100100")
n101900 = createNode(graph, "HydroPowerPlantDataset", name = "101900")
n102000 = createNode(graph, "HydroPowerPlantDataset", name = "102000")
n102100 = createNode(graph, "HydroPowerPlantDataset", name = "102100")

vg = createNode(graph, "SpacialData", name = "Val Giuf")
f1 = createNode(graph, "SpacialData", name = "Ferrera 1")
f2 = createNode(graph, "SpacialData", name = "Ferrera 2")
bb = createNode(graph, "SpacialData", name = "Baerenburg")

l = createNode(graph, "TemporalDataType", name = "L")
sp = createNode(graph, "TemporalDataType", name = "S/P")
s = createNode(graph, "TemporalDataType", name = "S")

p63 = createNode(graph, "TemporalDataPumpPower", value = "63")

m6.1 = createNode(graph, "TemporalDataMidPdct", value = "6.1")
m215.6 = createNode(graph, "TemporalDataMidPdct", value = "215.6")
m2.5 = createNode(graph, "TemporalDataMidPdct", value = "2.5")
m491 = createNode(graph, "TemporalDataMidPdct", value = "491")

y1979 = createNode(graph, "TemporalDataInitOpe", yeartime = "1979")
y1962 = createNode(graph, "TemporalDataInitOpe", yeartime = "1962")
y1963 = createNode(graph, "TemporalDataInitOpe", yeartime = "1963")

basic = createNode(graph, "TemporalDataLabel", name = "basic")

rhein = createNode(graph, "TemporalDataRiver", name = "Rhein")

mw = createNode(graph, "Unit", name = "MW" )

#Create relationships. 
reln_s = createRel(n100100, "HAS_LOCATION",vg, color = "Blue")
reln_s2 = createRel(n102000, "HAS_LOCATION", f2)
reln_s3 = createRel(n102100, "HAS_LOCATION", bb)

reln_t1 = lapply(list(n100100, n102000), function(g) createRel(g, "HAS_PROPERTY",l, color = "Green"))
reln_t2 = createRel(n101900, "HAS_PROPERTY", sp)
reln_t3 = createRel(n102100, "HAS_PROPERTY", s)

reln_p = createRel(n101900, "HAS_PROPERTY", p63)

reln_m1 = createRel(n100100, "HAS_PROPERTY", m6.1)
reln_m2 = createRel(n101900, "HAS_PROPERTY", m215.6)

reln_y1 = lapply(list(n101900, n102100), function(g) createRel(g, "HAS_PROPERTY",y1962))
reln_y2 = createRel(n102000, "HAS_PROPERTY", y1963)

reln_l = lapply(list(n101900, n102000, n102100), function(g) createRel(g, "HAS_PROPERTY",basic, color = "Orange"))

all_hppd = getNodes(graph, "MATCH (n) WHERE n:HydroPowerPlantDataset RETURN n")
reln_r = lapply(all_hppd, function(g) createRel(g, "HAS_PROPERTY",rhein, color = "Red"))

all_units = getNodes(graph, "MATCH (n) WHERE n:Unit RETURN n")
relp_u = lapply(all_units, function(g) createRel(p63, "HAS_UNIT",g, color = "Yellow"))

#Open the browser.
browse(graph)

