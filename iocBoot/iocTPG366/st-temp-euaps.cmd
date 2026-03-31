#!../../bin/linux-x86_64/tgpioc
###############################################################################
# EUAPS Vacuum – Pfeiffer TPG 366 MaxiGauge IOC
# Three TPG366 6-channel gauge controllers
#
# Compatible with TPG366 standalone project PV naming convention.
#
# YAML source:
#   vgc-01  EUAPS:VAC:VGC:PRVGA01  vdflameprtpg001.lnf.infn.it:8000  zones: FP
#   vgc-02  EUAPS:VAC:VGC:FIVGA01  vdflameinftpg001.lnf.infn.it:8000 zones: FI
#   vgc-03  EUAPS:VAC:VGC:FIVGA02  vdflameinftpg002.lnf.infn.it:8000 zones: FI
###############################################################################

dbLoadDatabase "../../dbd/tgpioc.dbd"
tgpioc_registerRecordDeviceDriver(pdbbase)

###############################################################################
# Stream protocol path – pick up devPFTPG366.proto installed by TPGSup
###############################################################################
epicsEnvSet("STREAM_PROTOCOL_PATH", "../../db:../../TPGSup")

###############################################################################
# VGC-01 – FP zone – PRVGA01
#   Server : vdflameprtpg001.lnf.infn.it  port 8000
#   PV root: EUAPS:VAC:VGC:PRVGA01:
###############################################################################
epicsEnvSet("VGC01_CTR",    "EUAPS:VAC:VGC:PRVGA01")
epicsEnvSet("VGC01_PORT",   "VGC01")
epicsEnvSet("VGC01_SERVER", "vdflameprtpg001.lnf.infn.it:8000")
epicsEnvSet("VGC01_S1",     "GAUGE1")
epicsEnvSet("VGC01_S2",     "GAUGE2")
epicsEnvSet("VGC01_S3",     "GAUGE3")
epicsEnvSet("VGC01_S4",     "GAUGE4")
epicsEnvSet("VGC01_S5",     "GAUGE5")
epicsEnvSet("VGC01_S6",     "GAUGE6")

drvAsynIPPortConfigure("$(VGC01_PORT)", "$(VGC01_SERVER)", 0, 0, 0)

###############################################################################
# VGC-02 – FI zone – FIVGA01
#   Server : vdflameinftpg001.lnf.infn.it  port 8000
#   PV root: EUAPS:VAC:VGC:FIVGA01:
###############################################################################
epicsEnvSet("VGC02_CTR",    "EUAPS:VAC:VGC:FIVGA01")
epicsEnvSet("VGC02_PORT",   "VGC02")
epicsEnvSet("VGC02_SERVER", "vdflameinftpg001.lnf.infn.it:8000")
epicsEnvSet("VGC02_S1",     "GAUGE1")
epicsEnvSet("VGC02_S2",     "GAUGE2")
epicsEnvSet("VGC02_S3",     "GAUGE3")
epicsEnvSet("VGC02_S4",     "GAUGE4")
epicsEnvSet("VGC02_S5",     "GAUGE5")
epicsEnvSet("VGC02_S6",     "GAUGE6")

drvAsynIPPortConfigure("$(VGC02_PORT)", "$(VGC02_SERVER)", 0, 0, 0)

###############################################################################
# VGC-03 – FI zone – FIVGA02
#   Server : vdflameinftpg002.lnf.infn.it  port 8000
#   PV root: EUAPS:VAC:VGC:FIVGA02:
###############################################################################
epicsEnvSet("VGC03_CTR",    "EUAPS:VAC:VGC:FIVGA02")
epicsEnvSet("VGC03_PORT",   "VGC03")
epicsEnvSet("VGC03_SERVER", "vdflameinftpg002.lnf.infn.it:8000")
epicsEnvSet("VGC03_S1",     "GAUGE1")
epicsEnvSet("VGC03_S2",     "GAUGE2")
epicsEnvSet("VGC03_S3",     "GAUGE3")
epicsEnvSet("VGC03_S4",     "GAUGE4")
epicsEnvSet("VGC03_S5",     "GAUGE5")
epicsEnvSet("VGC03_S6",     "GAUGE6")

drvAsynIPPortConfigure("$(VGC03_PORT)", "$(VGC03_SERVER)", 0, 0, 0)

###############################################################################
# Load sensor template directly
###############################################################################
dbLoadRecords("../../tgpApp/Db/PFTPG366-Sensor.template", "CONTROLLER=$(VGC01_CTR),PORT=$(VGC01_PORT),CH=1,SENSOR=$(VGC01_CTR)-$(VGC01_S1)")
dbLoadRecords("../../tgpApp/Db/PFTPG366-Sensor.template", "CONTROLLER=$(VGC01_CTR),PORT=$(VGC01_PORT),CH=2,SENSOR=$(VGC01_CTR)-$(VGC01_S2)")
dbLoadRecords("../../tgpApp/Db/PFTPG366-Sensor.template", "CONTROLLER=$(VGC01_CTR),PORT=$(VGC01_PORT),CH=3,SENSOR=$(VGC01_CTR)-$(VGC01_S3)")
dbLoadRecords("../../tgpApp/Db/PFTPG366-Sensor.template", "CONTROLLER=$(VGC01_CTR),PORT=$(VGC01_PORT),CH=4,SENSOR=$(VGC01_CTR)-$(VGC01_S4)")
dbLoadRecords("../../tgpApp/Db/PFTPG366-Sensor.template", "CONTROLLER=$(VGC01_CTR),PORT=$(VGC01_PORT),CH=5,SENSOR=$(VGC01_CTR)-$(VGC01_S5)")
dbLoadRecords("../../tgpApp/Db/PFTPG366-Sensor.template", "CONTROLLER=$(VGC01_CTR),PORT=$(VGC01_PORT),CH=6,SENSOR=$(VGC01_CTR)-$(VGC01_S6)")

dbLoadRecords("../../tgpApp/Db/PFTPG366-Sensor.template", "CONTROLLER=$(VGC02_CTR),PORT=$(VGC02_PORT),CH=1,SENSOR=$(VGC02_CTR)-$(VGC02_S1)")
dbLoadRecords("../../tgpApp/Db/PFTPG366-Sensor.template", "CONTROLLER=$(VGC02_CTR),PORT=$(VGC02_PORT),CH=2,SENSOR=$(VGC02_CTR)-$(VGC02_S2)")
dbLoadRecords("../../tgpApp/Db/PFTPG366-Sensor.template", "CONTROLLER=$(VGC02_CTR),PORT=$(VGC02_PORT),CH=3,SENSOR=$(VGC02_CTR)-$(VGC02_S3)")
dbLoadRecords("../../tgpApp/Db/PFTPG366-Sensor.template", "CONTROLLER=$(VGC02_CTR),PORT=$(VGC02_PORT),CH=4,SENSOR=$(VGC02_CTR)-$(VGC02_S4)")
dbLoadRecords("../../tgpApp/Db/PFTPG366-Sensor.template", "CONTROLLER=$(VGC02_CTR),PORT=$(VGC02_PORT),CH=5,SENSOR=$(VGC02_CTR)-$(VGC02_S5)")
dbLoadRecords("../../tgpApp/Db/PFTPG366-Sensor.template", "CONTROLLER=$(VGC02_CTR),PORT=$(VGC02_PORT),CH=6,SENSOR=$(VGC02_CTR)-$(VGC02_S6)")

dbLoadRecords("../../tgpApp/Db/PFTPG366-Sensor.template", "CONTROLLER=$(VGC03_CTR),PORT=$(VGC03_PORT),CH=1,SENSOR=$(VGC03_CTR)-$(VGC03_S1)")
dbLoadRecords("../../tgpApp/Db/PFTPG366-Sensor.template", "CONTROLLER=$(VGC03_CTR),PORT=$(VGC03_PORT),CH=2,SENSOR=$(VGC03_CTR)-$(VGC03_S2)")
dbLoadRecords("../../tgpApp/Db/PFTPG366-Sensor.template", "CONTROLLER=$(VGC03_CTR),PORT=$(VGC03_PORT),CH=3,SENSOR=$(VGC03_CTR)-$(VGC03_S3)")
dbLoadRecords("../../tgpApp/Db/PFTPG366-Sensor.template", "CONTROLLER=$(VGC03_CTR),PORT=$(VGC03_PORT),CH=4,SENSOR=$(VGC03_CTR)-$(VGC03_S4)")
dbLoadRecords("../../tgpApp/Db/PFTPG366-Sensor.template", "CONTROLLER=$(VGC03_CTR),PORT=$(VGC03_PORT),CH=5,SENSOR=$(VGC03_CTR)-$(VGC03_S5)")
dbLoadRecords("../../tgpApp/Db/PFTPG366-Sensor.template", "CONTROLLER=$(VGC03_CTR),PORT=$(VGC03_PORT),CH=6,SENSOR=$(VGC03_CTR)-$(VGC03_S6)")

###############################################################################
# Optional: StreamDevice debug (uncomment for commissioning)
###############################################################################
#var streamDebug 1

iocInit()
