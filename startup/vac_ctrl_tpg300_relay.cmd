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
dbLoadRecords(vac_ctrl_tpg300_standalone_relay.db, "DEVICENAME = $(DEVICENAME), CONTROLLERNAME = $(CONTROLLERNAME), RELAY = $(RELAY)")
