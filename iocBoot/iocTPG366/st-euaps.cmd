#!../../bin/linux-x86_64/tgpioc
###############################################################################
# EUAPS Vacuum – Pfeiffer TPG 366 MaxiGauge IOC
# Three TPG366 6-channel gauge controllers
#
# YAML source:
#   vgc-01  EUAPS:VAC:VGC:PRVGA01  vdflameprtpg001.lnf.infn.it:8000  zones: FP
#   vgc-02  EUAPS:VAC:VGC:FIVGA01  vdflameinftpg001.lnf.infn.it:8000 zones: FI
#   vgc-03  EUAPS:VAC:VGC:FIVGA02  vdflameinftpg002.lnf.infn.it:8000 zones: FI
#
# Channel mapping: YAML channel "A1" = TPG366 measuring channel 1 (CH1)
###############################################################################

dbLoadDatabase "../../dbd/tgpioc.dbd"
tgpioc_registerRecordDeviceDriver(pdbbase)

###############################################################################
# Stream protocol path – pick up devTPG366.proto installed by TPGSup
###############################################################################
epicsEnvSet("STREAM_PROTOCOL_PATH", "../../db:../../TPGSup")

###############################################################################
# VGC-01 – FP zone – PRVGA01
#   Server : vdflameprtpg001.lnf.infn.it  port 8000
#   PV root: EUAPS:VAC:VGC:PRVGA01:
###############################################################################
epicsEnvSet("VGC01_PORT",   "VGC01")
epicsEnvSet("VGC01_SERVER", "vdflameprtpg001.lnf.infn.it:8000")
epicsEnvSet("VGC01_P",      "EUAPS:VAC:VGC:PRVGA01")

drvAsynIPPortConfigure("$(VGC01_PORT)", "$(VGC01_SERVER)")

dbLoadRecords("../../db/devTPG366.db", "P=$(VGC01_P), R=:, PORT=$(VGC01_PORT)")

###############################################################################
# VGC-02 – FI zone – FIVGA01
#   Server : vdflameinftpg001.lnf.infn.it  port 8000
#   PV root: EUAPS:VAC:VGC:FIVGA01:
###############################################################################
epicsEnvSet("VGC02_PORT",   "VGC02")
epicsEnvSet("VGC02_SERVER", "vdflameinftpg001.lnf.infn.it:8000")
epicsEnvSet("VGC02_P",      "EUAPS:VAC:VGC:FIVGA01")

drvAsynIPPortConfigure("$(VGC02_PORT)", "$(VGC02_SERVER)")

dbLoadRecords("../../db/devTPG366.db", "P=$(VGC02_P), R=:, PORT=$(VGC02_PORT)")

###############################################################################
# VGC-03 – FI zone – FIVGA02
#   Server : vdflameinftpg002.lnf.infn.it  port 8000
#   PV root: EUAPS:VAC:VGC:FIVGA02:
###############################################################################
epicsEnvSet("VGC03_PORT",   "VGC03")
epicsEnvSet("VGC03_SERVER", "vdflameinftpg002.lnf.infn.it:8000")
epicsEnvSet("VGC03_P",      "EUAPS:VAC:VGC:FIVGA02")

drvAsynIPPortConfigure("$(VGC03_PORT)", "$(VGC03_SERVER)")

dbLoadRecords("../../db/devTPG366.db", "P=$(VGC03_P), R=:, PORT=$(VGC03_PORT)")

###############################################################################
# Optional: StreamDevice debug (uncomment for commissioning)
###############################################################################
#var streamDebug 1

iocInit()
