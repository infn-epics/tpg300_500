
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <registryFunction.h>
#include <aSubRecord.h>
#include <epicsExport.h>

int mySubDebug=1;

static long initParseSlots(aSubRecord *prec) {
    // Nothing to initialize for now
    if (mySubDebug)
        printf("Record %s called mySubInit(%p)\n",
               prec->name, (void*) prec);
    return 0;
}
static long parseSlots(aSubRecord *prec) {
    char *input = (char *)prec->a;
    char *out1 = (char *)prec->vala;
    char *out2 = (char *)prec->valb;
    char *out3 = (char *)prec->valc;
    char *out4 = (char *)prec->vald;
    char *out5 = (char *)prec->vale;

    if (!input ) {
        return -1;
    }

    // Tokenize the CSV input
    char *token;
    char buffer[256];
    strncpy(buffer, input, sizeof(buffer));
    buffer[sizeof(buffer)-1] = '\0';

    token = strtok(buffer, ",");
    if (token && out1) strncpy(out1, token, prec->nova);

    token = strtok(NULL, ",");
    if (token && out2) strncpy(out2, token, prec->novb);

    token = strtok(NULL, ",");
    if (token && out3) strncpy(out3, token, prec->novc);

    token = strtok(NULL, ",");
    if (token && out4) strncpy(out4, token, prec->novd);

    token = strtok(NULL, ",");
    if (token && out5) strncpy(out5, token, prec->nove);

    if (mySubDebug)
        printf("Record %s called myAsubProcess(%p) in %s outs %s %s %s\n",
               prec->name, (void*) prec,input,out1,out2,out3);
    return 0;
}

static long parsePressures(aSubRecord *prec) {
    char *input = (char *)prec->a;
    long *out1 = (long *)prec->vala;
    double *out2 = (double *)prec->valb;
    long *out3 = (long *)prec->valc;
    double *out4 = (double *)prec->vald;
    long *out5 = (long *)prec->vale;
    double *out6 = (double *)prec->valf;
    long *out7 = (long *)prec->valg;
    double *out8 = (double *)prec->valh;


    if (!input || out1 == NULL || out2 == NULL || out3 == NULL ||
        out4 == NULL || out5 == NULL || out6 == NULL || out7 == NULL || out8 == NULL) {
        printf("## Error Record %s called NO DEFINE ALL OUTPUTS \n",prec->name);

        return -1;
    }
    *out1= 5; // no harware
    *out2= -1; // no harware
    *out3= 5; // no harware
    *out4= -1; // no harware
    *out5= 5; // no harware
    *out6= -1; // no harware
    *out7= 5; // no harware
    *out8= -1; // no harware

    // Tokenize the CSV input
    char *token;
    char buffer[256];
    strncpy(buffer, input, sizeof(buffer));
    buffer[sizeof(buffer)-1] = '\0';

    token = strtok(buffer, ",");
    if (token && out1) {
        *out1= atoi(token);
    }

    token = strtok(NULL, ",");
    if (token && out2) {
        *out2= atof(token);
    }
    token = strtok(NULL, ",");
    if (token && out3) {
        *out3= atoi(token);
    }
    token = strtok(NULL, ",");
    if (token && out4) {
        *out4= atof(token);
    }
    token = strtok(NULL, ",");
    if (token && out5) {
        *out5= atoi(token);
    }
    token = strtok(NULL, ",");
    if (token && out6) {
        *out6= atof(token);
    }
    token = strtok(NULL, ",");
    if (token && out7) {
        *out7= atoi(token);
    }
    token = strtok(NULL, ",");
    if (token && out8) {
        *out8= atof(token);
    }
    
    if (mySubDebug)
        printf("Record %s called ParsePressiores(%p) in '%s' outs %ld %f %ld %f %ld %f %ld %f \n",
               prec->name, (void*) prec,input,*out1,*out2,*out3,*out4,*out5,*out6,*out7,*out8);
    return 0;
}
epicsExportAddress(int, mySubDebug);
epicsRegisterFunction(initParseSlots);

epicsRegisterFunction(parsePressures);
epicsRegisterFunction(parseSlots);
