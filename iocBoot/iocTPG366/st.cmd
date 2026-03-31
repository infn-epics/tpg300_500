#!../../bin/linux-x86_64/tgpioc

###############################################################################
# Startup script for Pfeiffer Vacuum TPG 366 MaxiGauge IOC
# 6-channel total pressure measurement and control unit
#
# Compatible with TPG366 standalone project PV naming convention.
#
# Usage:
#   Set environment variables before running:
#     CTR        - Controller name / PV prefix (e.g. "tpg366")
#     ASYN_PORT  - Asyn port name
#     TCP_IP     - IP address of the device
#     TCP_PORT   - TCP port number (default 8000)
#     GAUGE-1..6 - Sensor names (default: SENSOR1..SENSOR6)
###############################################################################

## Register all support components
dbLoadDatabase "../../dbd/tgpioc.dbd"
tgpioc_registerRecordDeviceDriver(pdbbase)

###############################################################################
# Configuration - edit these for your installation
###############################################################################
epicsEnvSet("CTR",       "tpg366")
epicsEnvSet("ASYN_PORT", "tpg366-01")
epicsEnvSet("TCP_IP",    "192.168.1.100")
epicsEnvSet("TCP_PORT",  "8000")
epicsEnvSet("GAUGE-1",   "SENSOR1")
epicsEnvSet("GAUGE-2",   "SENSOR2")
epicsEnvSet("GAUGE-3",   "SENSOR3")
epicsEnvSet("GAUGE-4",   "SENSOR4")
epicsEnvSet("GAUGE-5",   "SENSOR5")
epicsEnvSet("GAUGE-6",   "SENSOR6")

###############################################################################
# Set protocol file search path
###############################################################################
epicsEnvSet("STREAM_PROTOCOL_PATH", "../../db:../../TPGSup")

###############################################################################
# Configure asyn IP port
###############################################################################
drvAsynIPPortConfigure("${ASYN_PORT}", "${TCP_IP}:${TCP_PORT}", 0, 0, 0)

###############################################################################
# Load the TPG366 database
###############################################################################
dbLoadRecords("../../db/TPG366.db", "CONTROLLER=${CTR}, PORT=${ASYN_PORT}, S1=${GAUGE-1}, S2=${GAUGE-2}, S3=${GAUGE-3}, S4=${GAUGE-4}, S5=${GAUGE-5}, S6=${GAUGE-6}")

###############################################################################
# Optional: Enable StreamDevice debug output (0=off, 1=on)
###############################################################################
#var streamDebug 1

###############################################################################
# Initialize IOC
###############################################################################
iocInit()
