TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

#==================================================
# build a support library

LIBRARY_IOC += tpg300

# install midiStream.dbd into <top>/dbd
DBD += tpg300.dbd

# specify all source files to be compiled and added to the library
tpg300_SRCS += tpg300Interpose.c

tpg300_LIBS += $(EPICS_BASE_IOC_LIBS)

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

