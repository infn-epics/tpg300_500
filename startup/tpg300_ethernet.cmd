# @field DEVICENAME
# @type STRING
# Device name, should be the same as the name in CCDB

# @field IPADDR
# @type STRING
# Device IP address (Ethernet2Serial converter)

# @field PORT
# @type INTEGER
# Comms port on Ethernet2Serial converter


########## Set up comms driver ##########
#Specify the TCP endpoint and give your bus a name eg. "PLC1".
#drvAsynIPPortConfigure(portName, hostInfo, priority, noAutoConnect, noProcessEos)
#where the arguments are:
#	portName - The portName that is registered with asynManager.
#	hostInfo - The Internet host name, port number and optional IP protocol of the device (e.g.
#				"164.54.9.90:4002", "serials8n3:4002", "serials8n3:4002 TCP" or "164.54.17.43:5186 udp"). If no
#				protocol is specified, TCP will be used. Possible protocols are:
#		TCP,
#		UDP,
#		UDP* — UDP broadcasts. The address portion of the argument must be the network broadcast address
#				(e.g. "192.168.1.255:1234 UDP*").
#		HTTP — Like TCP but for servers which close the connection after each transaction.
#		COM — For Ethernet/Serial adapters which use the TELNET RFC 2217 protocol. This allows port parameters
#				(speed, parity, etc.) to be set with subsequent asynSetOption commands just as for local serial
#				ports. The default parameters are 9600-8-N-1 with no flow control.
#	priority - Priority at which the asyn I/O thread will run. If this is zero or missing, then
#	epicsThreadPriorityMedium is used.
#	noAutoConnect - Zero or missing indicates that portThread should automatically connect. Non-zero if explicit
#					connect command must be issued.
#	noProcessEos - If 0 then asynInterposeEosConfig is called specifying both processEosIn and processEosOut.
drvAsynIPPortConfigure($(DEVICENAME)-asyn-port,$(IPADDR):$(PORT))

#Load the database defining your EPICS records
#dbLoadRecords(tpg300.db, "DEVICENAME = $(DEVICENAME), ASYNPORT = $(DEVICENAME)-asyn-port")
dbLoadRecords(tpg300.db, "PREFIX = $(DEVICENAME), TPG_PORT = $(DEVICENAME)-asyn-port, SCAN_RATE = $(SCAN_RATE)")
