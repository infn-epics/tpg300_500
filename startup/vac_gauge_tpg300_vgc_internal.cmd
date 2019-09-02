# @field DEVICENAME
# @type STRING
# Device name, should be the same as the name in CCDB

# @field CONTROLLERNAME
# @type STRING
# Name of the head unit

# @field CHANNEL
# @type STRING
# Channel on the head unit where the gauge is connected to (A1, B1)

# @field RELAY1
# @type INTEGER
# Number of the first relay mapped to this gauge

# @field RELAY2
# @type INTEGER
# Number of the second relay mapped to this gauge

dbLoadRecords(vac_ctrl_tpg300_standalone_sensor.db, "DEVICENAME = $(DEVICENAME), CONTROLLERNAME = $(CONTROLLERNAME), SENSOR = $(CHANNEL), BOARD = PE")
dbLoadRecords(vac_ctrl_tpg300_standalone_relay.db, "DEVICENAME = $(DEVICENAME), CONTROLLERNAME = $(CONTROLLERNAME), CHANNEL = $(CHANNEL), RELAY = $(RELAY1), n = 1")
dbLoadRecords(vac_ctrl_tpg300_standalone_relay.db, "DEVICENAME = $(DEVICENAME), CONTROLLERNAME = $(CONTROLLERNAME), CHANNEL = $(CHANNEL), RELAY = $(RELAY2), n = 2")
