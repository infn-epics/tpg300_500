EXCLUDE_ARCHS += eldk
EXCLUDE_VERSIONS = 3.15.2


include ${EPICS_ENV_PATH}/module.Makefile
#PROJECT = tpg300_freia
LIBVERSION = freia_1_3_1

#USR_DEPENDENCIES += asyn

HEADERS += $(wildcard src/main/epics/tpg300App/src/*.h)
SOURCES += $(wildcard src/main/epics/tpg300App/src/*.c)
SOURCES += $(wildcard src/main/epics/tpg300App/src/*.cpp)


