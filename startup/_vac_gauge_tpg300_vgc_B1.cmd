# @field DEVICENAME
# @type STRING
# Device name, should be the same as the name in CCDB

# @field CONTROLLERNAME
# @type STRING
# Name of the head unit

requireSnippet(_vac_gauge_tpg300_vgc_internal.cmd, "DEVICENAME = $(DEVICENAME), CONTROLLERNAME = $(CONTROLLERNAME), CHANNEL = B1, SOURCE = C, RELAY1 = 3, RELAY1_SOURCE = C, RELAY2 = 4, RELAY2_SOURCE = D")
