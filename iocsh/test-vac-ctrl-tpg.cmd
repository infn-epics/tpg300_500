#!../bin/linux-x86_64/vac_ctrl_tpg300_500
dbLoadDatabase "../dbd/vac_ctrl_tpg300_500.dbd"
vac_ctrl_tpg300_500_registerRecordDeviceDriver(pdbbase)
epicsEnvSet("DEVICENAME","TESTTPG")
epicsEnvSet("P","TEST")
epicsEnvSet("R","TPG")

epicsEnvSet("IPADDR","192.168.197.168")
epicsEnvSet("PORT","4001")
epicsEnvSet("vac_ctrl_tpg300_500_DIR",".")
epicsEnvSet("EPICS_DB_INCLUDE_PATH", "../db")

drvAsynIPPortConfigure($(DEVICENAME),$(IPADDR):$(PORT))

#-Load the database defining your EPICS records
dbLoadRecords("../db/vac_ctrl_tpg300_500.db", "P=$(P), R=$(R), ASYNPORT = $(DEVICENAME)")

epicsEnvSet("STREAM_PROTOCOL_PATH", "../db")
var streamDebug 1
iocInit()
# epicsEnvSet("CONTROLLERNAME","TPGCTROLLER")
# epicsEnvSet("CHANNEL","A1")
# epicsEnvSet("RELAY1_DESC","RELAY1")
# epicsEnvSet("RELAY2_DESC","RELAY2")

# iocshLoad(vac_gauge_tpg300_500_vgc.iocsh)
