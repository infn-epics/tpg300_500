# @field DEVICENAME
# @type STRING
# Device name, should be the same as the name in CCDB

# @field CONTROLLERNAME
# @type STRING
# Name of the head unit

# @field RELAY
# @type STRING
# The switching function "mapped" to this relay

#Load the database defining your EPICS records
dbLoadRecords(tpg300_independent_relay.db, "PREFIX = $(DEVICENAME), CONTROLLERNAME = $(CONTROLLERNAME), RELAY = $(RELAY)")
