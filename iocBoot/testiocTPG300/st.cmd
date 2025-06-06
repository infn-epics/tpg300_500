#!../../bin/linux-x86_64/tgpioc
epicsEnvSet("TPG", "../../")

dbLoadDatabase "$(TPG)/dbd/tgpioc.dbd"
tgpioc_registerRecordDeviceDriver(pdbbase)

epicsEnvSet("DEVICE","TEST:TPG")
epicsEnvSet("IPADDR","192.168.197.168")
epicsEnvSet("PORT","4001")
epicsEnvSet("EPICS_DB_INCLUDE_PATH", "../db")

epicsEnvSet("IF300", "Y")
epicsEnvSet("IFNOT300", "N")

drvAsynIPPortConfigure("L0",$(IPADDR):$(PORT))

#-Load the database defining your EPICS records
epicsEnvSet("STREAM_PROTOCOL_PATH", "../../TPGSup/")


#dbLoadRecords("$(TPG)/db/test.db","P=$(DEVICE), PORT=L0,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0)")

dbLoadRecords("$(TPG)/db/TPG300_base.db","P=$(DEVICE), PORT=L0,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),TPG_UNDERRANGE_ALARM_SEVERITY_CHAN1=$(TPG_UNDERRANGE_ALARM_SEVERITY_CHAN1=MINOR),TPG_UNDERRANGE_ALARM_SEVERITY_CHAN2=$(TPG_UNDERRANGE_ALARM_SEVERITY_CHAN2=MINOR)")
dbLoadRecords("$(TPG)/db/TPG300_channels.db","P=$(DEVICE), PORT=L0,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),TPG_UNDERRANGE_ALARM_SEVERITY_CHAN1=$(TPG_UNDERRANGE_ALARM_SEVERITY_CHAN1=MINOR),TPG_UNDERRANGE_ALARM_SEVERITY_CHAN2=$(TPG_UNDERRANGE_ALARM_SEVERITY_CHAN2=MINOR)")

# dbLoadRecords("$(TPG)/db/devTPG3xx.db","P=$(DEVICE), PORT=L0,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0)")

# dbLoadRecords("$(TPG)/db/TPG300_channels.db","P=$(DEVICE), PORT=L0,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),TPG_UNDERRANGE_ALARM_SEVERITY_CHAN1=$(TPG_UNDERRANGE_ALARM_SEVERITY_CHAN1=MINOR),TPG_UNDERRANGE_ALARM_SEVERITY_CHAN2=$(TPG_UNDERRANGE_ALARM_SEVERITY_CHAN2=MINOR)")
#dbLoadRecords("$(TPG)/db/TPG300_switching_functions.db","P=$(DEVICE),PORT=L0,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0)")

# dbLoadRecords("$(TPG)/db/unit_setter.db","P=$(DEVICE)")
# dbLoadRecords("$(TPG)/db/TPG300_switching_functions_rb.db","P=$(DEVICE),PORT=L0,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0)")
# dbLoadRecords("$(TPG)/db/TPG300_switching_functions_rb_AB.db","P=$(DEVICE),PORT=L0,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0)")
# dbLoadRecords("$(TPG)/db/TPG300_function_statuses.db","P=$(DEVICE),PORT=L0,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0)")
# dbLoadRecords("$(TPG)/db/TPG300_switching_functions_rb_error_setter.db","P=$(DEVICE),PORT=L0,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0)")
# dbLoadRecords("$(TPG)/db/TPG300_function_statuses_error_setter.db","P=$(DEVICE),PORT=L0,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0)")

var streamDebug 0
iocInit()

