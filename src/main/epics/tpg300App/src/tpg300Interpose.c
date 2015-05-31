/**
 * Pfeiffer Vacuum TPG300 EPICS module
 * Copyright (C) 2015 Cosylab
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

/*
 * Interpose layer for EPICS support for the Pfeiffer Vacuum TPG300 controller
 * that corrects the exponential number format from what StreamDevice provides
 * to what the device expects.
 *
 * StreamDevice formats numbers in exponent notation (%E or $e format specifier)
 * with at least two digits for the exponent (as specified by printf family
 * of functions). The controller expects a variable number of exponent digits
 * depending on the actual value of the exponent (even only one digit).
 *
 * Author: Klemen Strnisa
 */

#include <stddef.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>

#include <cantProceed.h>
#include <epicsAssert.h>
#include <epicsStdio.h>
#include <epicsString.h>
#include <epicsExport.h>
#include <iocsh.h>

#include "asynDriver.h"
#include "asynOctet.h"
#include "tpg300Interpose.h"


#define START_BUFFER_SIZE	    2048

#define MESSAGE_STATE_NONE      0
#define MESSAGE_STATE_EXP       1


typedef struct tpg300Pvt {
    char            *portName;
    asynInterface   tpg300Interface;
    asynOctet       *poctet;
    void            *octetPvt;
    asynUser        *pasynUser;
    size_t          outBufSize;
    char            *outBuf;
    size_t          inBufSize;
    char            *inBuf;
    unsigned int    inBufHead;
    unsigned int    inBufTail;
    int             messageState;
    int             inEom;
} tpg300Pvt;


static asynStatus writeTpg300(void *ppvt, asynUser *pasynUser,
    const char *data, size_t numchars, size_t *nbytesTransfered);
static asynStatus readTpg300(void *ppvt, asynUser *pasynUser,
    char *data, size_t maxchars, size_t *nbytesTransfered, int *eomReason);
static asynStatus flushTpg300(void *ppvt,asynUser *pasynUser);
static asynStatus registerInterruptUser(void *ppvt, asynUser *pasynUser,
    interruptCallbackOctet callback, void *userPvt, void **registrarPvt);
static asynStatus cancelInterruptUser(void *drvPvt, asynUser *pasynUser,
    void *registrarPvt);
static asynStatus setInputEos(void *ppvt, asynUser *pasynUser,
    const char *eos, int eoslen);
static asynStatus getInputEos(void *ppvt, asynUser *pasynUser,
    char *eos, int eossize, int *eoslen);
static asynStatus setOutputEos(void *ppvt, asynUser *pasynUser,
    const char *eos, int eoslen);
static asynStatus getOutputEos(void *ppvt, asynUser *pasynUser,
    char *eos, int eossize, int *eoslen);
static asynOctet octet = {
    writeTpg300, readTpg300, flushTpg300,
    registerInterruptUser, cancelInterruptUser,
    setInputEos, getInputEos, setOutputEos, getOutputEos
};


epicsShareFunc int tpg300InterposeConfig(const char *portName) {
	tpg300Pvt     *ptpg300Pvt;
    asynInterface *plowerLevelInterface;
    asynStatus    status;
    asynUser      *pasynUser;
    size_t        len;

    const char *functionName = "tpg300InterposeConfig";

    len = sizeof(tpg300Pvt) + strlen(portName) + 1;
    ptpg300Pvt = callocMustSucceed(1, len, functionName);
    ptpg300Pvt->portName = (char *)(ptpg300Pvt + 1);
    strcpy(ptpg300Pvt->portName, portName);
    ptpg300Pvt->tpg300Interface.interfaceType = asynOctetType;
    ptpg300Pvt->tpg300Interface.pinterface = &octet;
    ptpg300Pvt->tpg300Interface.drvPvt = ptpg300Pvt;
    pasynUser = pasynManager->createAsynUser(0, 0);
    ptpg300Pvt->pasynUser = pasynUser;
    ptpg300Pvt->pasynUser->userPvt = ptpg300Pvt;
    status = pasynManager->connectDevice(pasynUser, portName, 0);
    if (status != asynSuccess) {
        printf("%s:%s connectDevice failed\n", portName, functionName);
        pasynManager->freeAsynUser(pasynUser);
        free(ptpg300Pvt);
        return -1;
    }
    status = pasynManager->interposeInterface(portName, 0,
       &ptpg300Pvt->tpg300Interface, &plowerLevelInterface);
    if (status != asynSuccess) {
        printf("%s:%s interposeInterface failed\n", portName, functionName);
        pasynManager->exceptionCallbackRemove(pasynUser);
        pasynManager->freeAsynUser(pasynUser);
        free(ptpg300Pvt);
        return -1;
    }
    ptpg300Pvt->poctet = (asynOctet *)plowerLevelInterface->pinterface;
    ptpg300Pvt->octetPvt = plowerLevelInterface->drvPvt;

    ptpg300Pvt->outBuf = pasynManager->memMalloc(START_BUFFER_SIZE);
    ptpg300Pvt->outBufSize = START_BUFFER_SIZE;

    ptpg300Pvt->inBuf = pasynManager->memMalloc(START_BUFFER_SIZE);
    ptpg300Pvt->inBufSize = START_BUFFER_SIZE;

    return 0;
}


static asynStatus writeTpg300(void *ppvt,asynUser *pasynUser,
    const char *data, size_t numchars, size_t *nbytesTransfered) {

    tpg300Pvt     	*ptpg300Pvt = (tpg300Pvt *)ppvt;
    size_t      	i, numremoved, numwritten;
    asynStatus      status;

    const char *functionName = "writeTpg300";

    asynPrint(pasynUser, ASYN_TRACE_FLOW,
            "%s:%s: Original message (size %zu): %.*s",
            ptpg300Pvt->portName, functionName, numchars,
            (int)numchars, data);

    if (ptpg300Pvt->outBufSize < numchars) {
        pasynManager->memFree(ptpg300Pvt->outBuf, ptpg300Pvt->outBufSize);
        ptpg300Pvt->outBufSize = numchars;
        ptpg300Pvt->outBuf = pasynManager->memMalloc(ptpg300Pvt->outBufSize);
    }

    numremoved = 0;

    for (i = 0; i < numchars; i++) {
        switch (data[i]) {
            case '-': /* Fall through. */
            case '+':
                ptpg300Pvt->messageState = MESSAGE_STATE_EXP;
                break;
            case '0': /* Always remove first zero in exponent. */
                if (ptpg300Pvt->messageState == MESSAGE_STATE_EXP) {
                    numremoved++;
                    ptpg300Pvt->messageState = MESSAGE_STATE_NONE;
                    continue;
                }
                break;
            default: /* The exponent part is over. */
                ptpg300Pvt->messageState = MESSAGE_STATE_NONE;
                break;
        }
        ptpg300Pvt->outBuf[i - numremoved] = data[i];
    }

    asynPrint(pasynUser, ASYN_TRACE_FLOW,
            "%s:%s: Removed %zu zeros from message\n",
            ptpg300Pvt->portName, functionName, numremoved);

    asynPrint(pasynUser, ASYN_TRACE_FLOW,
            "%s:%s: Processed message (size %zu): %.*s",
            ptpg300Pvt->portName, functionName, numchars - numremoved,
            (int)(numchars - numremoved), ptpg300Pvt->outBuf);

    numwritten = 0;
    do {
        status = ptpg300Pvt->poctet->write(ptpg300Pvt->octetPvt, pasynUser,
                &ptpg300Pvt->outBuf[numwritten], numchars - numremoved - numwritten, nbytesTransfered);
        numwritten += *nbytesTransfered;
    } while (status == asynSuccess && numwritten < numchars - numremoved);

    *nbytesTransfered = numwritten + numremoved;

    return status;
}


static asynStatus readTpg300(void *ppvt, asynUser *pasynUser,
    char *data, size_t maxchars, size_t *nbytesTransfered, int *eomReason) {

    tpg300Pvt   *ptpg300Pvt = (tpg300Pvt *)ppvt;
    size_t      thisRead, nRead;
    asynStatus  status;
    char        c;
    int         eom;

    const char *functionName = "readTpg300";

    nRead = 0;
    eom = 0;
    ptpg300Pvt->messageState = MESSAGE_STATE_NONE;

    for (;;) {
        if (ptpg300Pvt->inBufTail != ptpg300Pvt->inBufHead) {
            /* If there is a number in exponential notation we might need to
             * insert a zero. */
            if (ptpg300Pvt->messageState == MESSAGE_STATE_EXP) {

                ptpg300Pvt->messageState = MESSAGE_STATE_NONE;

                /* If the first char of the exponent is not a digit then
                 * this isn't an exponent at all (version string maybe). */
                if (!isdigit(ptpg300Pvt->inBuf[ptpg300Pvt->inBufTail])) {
                    continue;
                }

                /* if there is only one digit in the exponent we add a zero. */
                if (ptpg300Pvt->inBufTail + 1 == ptpg300Pvt->inBufHead ||
                        !isdigit(ptpg300Pvt->inBuf[ptpg300Pvt->inBufTail + 1])) {
                    /* This happens if the second char of the exponent is
                     * either not a digit (in case of setpoints it's a comma
                     * or the end of the message that was read (pressure rbv).*/
                    asynPrint(pasynUser, ASYN_TRACE_FLOW,
                            "%s:%s: insert  char 0 at %zu with maxchars %zu\n",
                            ptpg300Pvt->portName, functionName, nRead, maxchars);
                    *data++ = '0';
                    nRead++;
                }
                if (nRead >= maxchars)  {
                    eom = ASYN_EOM_CNT;
                    break;
                }
                continue;
            }

            c = ptpg300Pvt->inBuf[ptpg300Pvt->inBufTail++];

            asynPrint(pasynUser, ASYN_TRACE_FLOW,
                    "%s:%s: process char %c at %zu with maxchars %zu\n",
                    ptpg300Pvt->portName, functionName, c, nRead, maxchars);

            *data++ = c;
            nRead++;

            /* This means we found a number in exponential notation that we
             * need to check. */
            if (c == '-' || c == '+') {
                ptpg300Pvt->messageState = MESSAGE_STATE_EXP;
            }

            if (nRead >= maxchars)  {
                eom = ASYN_EOM_CNT;
                break;
            }
            continue;
        }

        if (ptpg300Pvt->inEom & (ASYN_EOM_END | ASYN_EOM_EOS)) {
            eom = ptpg300Pvt->inEom;
            ptpg300Pvt->inEom = 0;
            break;
        }

        status = ptpg300Pvt->poctet->read(ptpg300Pvt->octetPvt, pasynUser,
                ptpg300Pvt->inBuf, ptpg300Pvt->inBufSize, &thisRead, &ptpg300Pvt->inEom);
        asynPrint(pasynUser, ASYN_TRACE_FLOW,
                "%s:%s: read status %d nbytes %zu and eom %d\n", ptpg300Pvt->portName,
                functionName, status, thisRead, ptpg300Pvt->inEom);

        if (status != asynSuccess || thisRead == 0) {
            eom = ptpg300Pvt->inEom;
            ptpg300Pvt->inEom = 0;
            break;
        }
        ptpg300Pvt->inBufTail = 0;
        ptpg300Pvt->inBufHead = (int)thisRead;
    }

    if (nRead < maxchars) {
        *data = 0;
    }
    if (eomReason) {
        *eomReason = eom;
    }
    *nbytesTransfered = nRead;

    asynPrint(pasynUser, ASYN_TRACE_FLOW,
            "%s:%s: returning with status %d, nbytes %zu and eom %d\n",
            ptpg300Pvt->portName, functionName, status, *nbytesTransfered, *eomReason);

    return status;
}


static asynStatus flushTpg300(void *ppvt,asynUser *pasynUser) {

    tpg300Pvt *ptpg300Pvt = (tpg300Pvt *)ppvt;

    return ptpg300Pvt->poctet->flush(ptpg300Pvt->octetPvt, pasynUser);
}


static asynStatus registerInterruptUser(void *ppvt, asynUser *pasynUser,
    interruptCallbackOctet callback, void *userPvt, void **registrarPvt) {

    tpg300Pvt *ptpg300Pvt = (tpg300Pvt *)ppvt;

    return ptpg300Pvt->poctet->registerInterruptUser(ptpg300Pvt->octetPvt,
            pasynUser, callback, userPvt, registrarPvt);
}

static asynStatus cancelInterruptUser(void *drvPvt, asynUser *pasynUser,
     void *registrarPvt) {
    tpg300Pvt *ptpg300Pvt = (tpg300Pvt *)drvPvt;

    return ptpg300Pvt->poctet->cancelInterruptUser(ptpg300Pvt->octetPvt,
            pasynUser, registrarPvt);
}


static asynStatus setInputEos(void *ppvt,asynUser *pasynUser,
    const char *eos, int eoslen) {

    tpg300Pvt *ptpg300Pvt = (tpg300Pvt *)ppvt;

    return ptpg300Pvt->poctet->setInputEos(ptpg300Pvt->octetPvt,
            pasynUser, eos, eoslen);
}


static asynStatus getInputEos(void *ppvt,asynUser *pasynUser,
    char *eos, int eossize, int *eoslen) {

    tpg300Pvt *ptpg300Pvt = (tpg300Pvt *)ppvt;

    return ptpg300Pvt->poctet->getInputEos(ptpg300Pvt->octetPvt,
            pasynUser, eos, eossize, eoslen);
}


static asynStatus setOutputEos(void *ppvt,asynUser *pasynUser,
    const char *eos, int eoslen) {

    tpg300Pvt *ptpg300Pvt = (tpg300Pvt *)ppvt;

    return ptpg300Pvt->poctet->setOutputEos(ptpg300Pvt->octetPvt,
            pasynUser, eos, eoslen);
}


static asynStatus getOutputEos(void *ppvt,asynUser *pasynUser,
    char *eos, int eossize, int *eoslen) {

    tpg300Pvt *ptpg300Pvt = (tpg300Pvt *)ppvt;

    return ptpg300Pvt->poctet->getOutputEos(ptpg300Pvt->octetPvt,
            pasynUser, eos, eossize, eoslen);
}


static const iocshArg tpg300InterposeConfigArg0 =
    { "portName", iocshArgString };
static const iocshArg *tpg300InterposeConfigArgs[] =
    { &tpg300InterposeConfigArg0 };
static const iocshFuncDef tpg300InterposeConfigFuncDef =
    {"tpg300InterposeConfig", 1, tpg300InterposeConfigArgs};
static void tpg300InterposeConfigCallFunc(const iocshArgBuf *args) {
	tpg300InterposeConfig(args[0].sval);
}

static void tpg300InterposeRegister(void) {
    static int firstTime = 1;
    if (firstTime) {
        firstTime = 0;
        iocshRegister(&tpg300InterposeConfigFuncDef,
                tpg300InterposeConfigCallFunc);
    }
}

epicsExportRegistrar(tpg300InterposeRegister);
