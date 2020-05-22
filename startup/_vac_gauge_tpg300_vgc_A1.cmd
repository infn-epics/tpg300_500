# @field DEVICENAME
# @type STRING
# Device name, should be the same as the name in CCDB

# @field CONTROLLERNAME
# @type STRING
# Name of the head unit

requireSnippet(_vac_gauge_tpg300_vgc_internal.cmd, "DEVICENAME = $(DEVICENAME), CONTROLLERNAME = $(CONTROLLERNAME), CHANNEL = A1, SOURCE = A, RELAY1 = 1, RELAY2 = 2")
