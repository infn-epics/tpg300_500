# @field DEVICENAME
# @type STRING
# Device name, should be the same as the name in CCDB

# @field CONTROLLERNAME
# @type STRING
# Name of the head unit

# @field CHANNEL
# @type STRING
# Channel on the head unit where the gauge is connected to (A1, B1)

requireSnippet(vac_gauge_tpg300_vgc_$(CHANNEL).cmd, "DEVICENAME = $(DEVICENAME), CONTROLLERNAME = $(CONTROLLERNAME)")
