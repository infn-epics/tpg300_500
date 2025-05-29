TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS BELOW HERE
PROD_IOC = vac_ctrl_tpg300_500

# Use typed rset structure (see 3.16.1 release notes)
USR_CPPFLAGS += -DUSE_TYPED_RSET

# Build an IOC support library
LIBRARY_IOC += vac_ctrl_tpg300_500Support
DBD += vac_ctrl_tpg300_500.dbd

# Compile and add code to the support library
vac_ctrl_tpg300_500Support_SRCS += tpg300_500StreamFormatConverter.cpp
# vac_ctrl_tpg300_500.dbd will be created and installed
#DBD += vac_ctrl_tpg300_500.dbd

# vac_ctrl_tp300_500.dbd will include these files:
vac_ctrl_tpg300_500_DBD += base.dbd
vac_ctrl_tpg300_500_DBD += calc.dbd      # Add for scalcout
# vac_ctrl_tpg300_500_DBD += stream-scalcout.dbd
vac_ctrl_tpg300_500_DBD += stream.dbd

vac_ctrl_tpg300_500_DBD += asyn.dbd
vac_ctrl_tpg300_500_DBD += drvAsynIPPort.dbd
vac_ctrl_tpg300_500_DBD += sscan.dbd       # Add for sseq

#vac_ctrl_tpg300_500_DBD += xxxSupport.dbd
#vac_ctrl_tpg300_500_DBD += dbSubExample.dbd
#vac_ctrl_tpg300_500_DBD += devvac_ctrl_tpg300_500Version.dbd
#vac_ctrl_tpg300_500_DBD += vac_ctrl_tpg300_500Hello.dbd
#vac_ctrl_tpg300_500_DBD += initTrace.dbd
vac_ctrl_tpg300_500_SRCS += vac_ctrl_tpg300_500_registerRecordDeviceDriver.cpp
vac_ctrl_tpg300_500_SRCS_DEFAULT += tpgMain.cpp

# Link in the code from our support library
vac_ctrl_tpg300_500_LIBS += vac_ctrl_tpg300_500Support

USR_LIBS += stream asyn calc sscan seq             # Add calc and sseq libraries


# Finally link IOC to the EPICS Base libraries
vac_ctrl_tpg300_500_LIBS += $(EPICS_BASE_IOC_LIBS)

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD EXTRA GNUMAKE RULES BELOW HERE

# Explicit dependency needed for generated header file
devvac_ctrl_tcp350Version$(DEP): $(COMMON_DIR)/$(GENVERSION)
