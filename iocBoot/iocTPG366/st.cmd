#!../../bin/linux-x86_64/tgpioc

###############################################################################
# Startup script for Pfeiffer Vacuum TPG 366 MaxiGauge IOC
# 6-channel total pressure measurement and control unit
#
# Usage:
#   Set environment variables before running:
#     DEVICENAME - Asyn port name / device identifier
#     P          - PV prefix
#     IPADDR     - IP address of the device (or Ethernet-to-Serial converter)
#     PORT       - TCP port number (e.g. 4001 for MOXA)
###############################################################################

## Register all support components
dbLoadDatabase "../../dbd/tgpioc.dbd"
tgpioc_registerRecordDeviceDriver(pdbbase)

###############################################################################
# Configuration - edit these for your installation
###############################################################################
epicsEnvSet("DEVICENAME", "TPG366")
epicsEnvSet("P",          "VAC-TPG366")
epicsEnvSet("R",          ":")
epicsEnvSet("IPADDR",     "192.168.1.100")
epicsEnvSet("PORT",       "4001")

###############################################################################
# Set protocol file search path
###############################################################################
epicsEnvSet("STREAM_PROTOCOL_PATH", "../../db:../../TPGSup")

###############################################################################
# Configure asyn IP port
# drvAsynIPPortConfigure(portName, hostInfo, priority, noAutoConnect, noProcessEos)
###############################################################################
drvAsynIPPortConfigure("$(DEVICENAME)", "$(IPADDR):$(PORT)")

###############################################################################
# Load the TPG366 database
###############################################################################
dbLoadRecords("../../db/devTPG366.db", "P=$(P), R=$(R), PORT=$(DEVICENAME)")

###############################################################################
# Optional: Enable StreamDevice debug output (0=off, 1=on)
###############################################################################
#var streamDebug 1

###############################################################################
# Initialize IOC
###############################################################################
iocInit()
