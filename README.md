# Vacuum Gauge Controller Pfeiffer TPG-300 and TPG-500
# Vacuum Cold Cathode Gauge TPG

EPICS module to provide communications and read/write data from/to **TPG-300 and TPG-500 vacuum gauge controller** and
*   to read/write data for **TPG vacuum cold cathode gauge**.

The IOC does not directly communicate with the gauges; the gauge is actually connected to a gauge controller and the IOC communicates with the controller and the controller communicates with the gauges. Controllers can have multiple gauges connected to different channels.

**Please note that the gauges have to be configured together with the controller i.e. in the same IOC**

There are separate `.iocsh` scripts for the controller and the gauges themselves; this allows for any combination of controller and gauges to be built using this module.

## IOCSH files

*   Controller: [vac_ctrl_tpg300_500_moxa.iocsh](iocsh/README.md#vac_ctrl_tpg300_500_moxa)
*   Cold cathode gauge: [vac_gauge_tpg300_500_vgc.iocsh](iocsh/README.md#vac_gauge_tpg300_500_vgc)

## MOXA configuration

#### Operation Modes / Operating settings

```
Application: Socket
Mode: TCP Server
```

OR

```
Operation mode: TCP Server mode
```

```
.
.
.
Packing length: 0
Delimiter 1: 00 / Disabled
Delimiter 2: 00 / Disabled
Delimiter process: Do Nothing
Force transmit: 0
```

#### Communication Parameters / Serial Settings

````
Baud rate: 9600
Data bits: 8
Stop bits: 1
Parity: None
Flow control: None
Interface: RS-232
```

