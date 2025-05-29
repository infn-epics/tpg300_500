#!../bin/linux-x86_64/vac_ctrl_tpg300_500
dbLoadDatabase "../dbd/vac_ctrl_tpg300_500.dbd"
vac_ctrl_tpg300_500_registerRecordDeviceDriver(pdbbase)
epicsEnvSet("DEVICENAME","TEST:TPG")
epicsEnvSet("IPADDR","192.168.197.168")
epicsEnvSet("PORT","4001")
epicsEnvSet("vac_ctrl_tpg300_500_DIR",".")
epicsEnvSet("EPICS_DB_INCLUDE_PATH", "../db")
iocshLoad(vac_ctrl_tpg300_500_moxa.iocsh)

epicsEnvSet("STREAM_PROTOCOL_PATH", "../db")
iocInit()
# epicsEnvSet("CONTROLLERNAME","TPGCTROLLER")
# epicsEnvSet("CHANNEL","A1")
# epicsEnvSet("RELAY1_DESC","RELAY1")
# epicsEnvSet("RELAY2_DESC","RELAY2")

# iocshLoad(vac_gauge_tpg300_500_vgc.iocsh)
