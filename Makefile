include ${EPICS_ENV_PATH}/module.Makefile

USR_DEPENDENCIES = streamdevice,2.7.1-ESS0
MISCS = $(AUTOMISCS)
MISCS += tools/tpg300sim.sh
