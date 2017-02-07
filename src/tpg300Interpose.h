/* tpg300Interpose.h */

/*
 * Interpose layer for EPICS support for the Pfeiffer Vacuum TPG300 controller
 * that corrects the exponential number format from what StreamDevice provides
 * to what the device expects.
 *
 * Author: Klemen Strnisa
 */

#ifndef tpg300Interpose_H
#define tpg300Interpose_H

#include <shareLib.h>
#include <epicsExport.h>

#ifdef __cplusplus
extern "C" {
#endif  /* __cplusplus */

epicsShareFunc int tpg300InterposeConfig(const char *portName);

#ifdef __cplusplus
}
#endif  /* __cplusplus */

#endif /* tpg300Interpose_H */
