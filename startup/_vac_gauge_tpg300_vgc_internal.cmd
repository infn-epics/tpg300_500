# @field DEVICENAME
# @type STRING
# Device name, should be the same as the name in CCDB

# @field CONTROLLERNAME
# @type STRING
# Name of the head unit

# @field CHANNEL
# @type STRING
# Channel on the head unit where the gauge is connected to (A1, B1)

# @field SOURCE
# @type STRING
# The calcout field this channel belongs to (A, C)

# @field RELAY1
# @type INTEGER
# Number of the first relay mapped to this gauge

# @field RELAY2
# @type INTEGER
# Number of the second relay mapped to this gauge

dbLoadRecords(vac_gauge_tpg300.db, "P = $(DEVICENAME), R = :, CONTROLLERNAME = $(CONTROLLERNAME), SENSOR = $(CHANNEL), SOURCE = $(SOURCE), ASYNPORT = $(CONTROLLERNAME), BOARD = PE, GAUGE = CC, EGU = mBar")
dbLoadRecords(vac_gauge_tpg300_relay.db, "P = $(DEVICENAME), R = :, CONTROLLERNAME = $(CONTROLLERNAME), CHANNEL = $(CHANNEL), SOURCE = $(SOURCE), RELAY = $(RELAY1), ASYNPORT = $(CONTROLLERNAME), n = 1, EGU = mBar")
dbLoadRecords(vac_gauge_tpg300_relay.db, "P = $(DEVICENAME), R = :, CONTROLLERNAME = $(CONTROLLERNAME), CHANNEL = $(CHANNEL), SOURCE = $(SOURCE), RELAY = $(RELAY2), ASYNPORT = $(CONTROLLERNAME), n = 2, EGU = mBar")
