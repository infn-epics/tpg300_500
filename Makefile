include ${EPICS_ENV_PATH}/module.Makefile

DOC = $(wildcard doc/*)
MISCS = $(AUTOMISCS)
MISCS += tools/tpg300sim.sh
