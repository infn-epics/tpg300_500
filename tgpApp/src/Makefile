TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS BELOW HERE
PROD_IOC = tgpioc

# Use typed rset structure (see 3.16.1 release notes)
USR_CPPFLAGS += -DUSE_TYPED_RSET

# Build an IOC support library
LIBRARY_IOC += tgpiocSupport
DBD += tgpioc.dbd

# Compile and add code to the support library
tgpiocSupport_SRCS += tpg300_500StreamFormatConverter.cpp
# tgpioc.dbd will be created and installed

tgpioc_DBD += base.dbd
tgpioc_DBD += calc.dbd      # Add for scalcout
# tgpioc_DBD += stream-scalcout.dbd
tgpioc_DBD += stream.dbd

tgpioc_DBD += asyn.dbd
tgpioc_DBD += drvAsynIPPort.dbd
tgpioc_DBD += sscan.dbd   # Add for sseq
tgpioc_DBD += parseSlots.dbd   # Add for parseSlots

tgpioc_SRCS += tgpioc_registerRecordDeviceDriver.cpp
tgpioc_SRCS_DEFAULT += tpgMain.cpp

# Link in the code from our support library
tgpioc_LIBS += tgpiocSupport
tgpiocSupport_SRCS += parseSlots.c

USR_LIBS += stream asyn calc sscan seq             # Add calc and sseq libraries


# Finally link IOC to the EPICS Base libraries
tgpioc_LIBS += $(EPICS_BASE_IOC_LIBS)

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD EXTRA GNUMAKE RULES BELOW HERE
