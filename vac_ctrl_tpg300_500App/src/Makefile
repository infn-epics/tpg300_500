TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS BELOW HERE

# Use typed rset structure (see 3.16.1 release notes)
USR_CPPFLAGS += -DUSE_TYPED_RSET

# Build an IOC support library
LIBRARY_IOC += vac_ctrl_tpg300_500Support

# Compile and add code to the support library
vac_ctrl_tpg300_500Support_SRCS += tpg300_500StreamFormatConverter.cpp
# vac_ctrl_tpg300_500.dbd will be created and installed
#DBD += vac_ctrl_tpg300_500.dbd

# vac_ctrl_tp300_500.dbd will include these files:
#vac_ctrl_tpg300_500_DBD += base.dbd
#vac_ctrl_tpg300_500_DBD += xxxSupport.dbd
#vac_ctrl_tpg300_500_DBD += dbSubExample.dbd
#vac_ctrl_tpg300_500_DBD += devvac_ctrl_tpg300_500Version.dbd
#vac_ctrl_tpg300_500_DBD += vac_ctrl_tpg300_500Hello.dbd
#vac_ctrl_tpg300_500_DBD += initTrace.dbd

# Link in the code from our support library
vac_ctrl_tpg300_500_LIBS += vac_ctrl_tpg300_500Support

PROD_LIBS += stream


# Finally link IOC to the EPICS Base libraries
vac_ctrl_tpg300_500_LIBS += $(EPICS_BASE_IOC_LIBS)

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD EXTRA GNUMAKE RULES BELOW HERE

# Explicit dependency needed for generated header file
devvac_ctrl_tcp350Version$(DEP): $(COMMON_DIR)/$(GENVERSION)
