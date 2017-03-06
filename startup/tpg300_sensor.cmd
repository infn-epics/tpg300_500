# @field DEVICENAME
# @type STRING
# Device name, should be the same as the name in CCDB

# @field CONTROLLERNAME
# @type STRING
# Name of the head unit

# @field CHANNEL
# @type STRING
# Channel on the head unit where the gauge is connected to (A1, A2, B1, B2)


#Load the database defining your EPICS records
dbLoadRecords(tpg300_independent_sensor.db, "PREFIX = $(DEVICENAME), CONTROLLERNAME = $(CONTROLLERNAME), SENSOR = $(CHANNEL)")
