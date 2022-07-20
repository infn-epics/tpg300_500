# IOCSH files for TPG vacuum gauge controller and its gauges

## vac_ctrl_tpg300_500_moxa

`.iocsh` file for the controller.

#### Required macros:

*   **DEVICENAME**
    *   ESS name, the same as in Naming service/CCDB
    *   string
*   **IPADDR**
    *   The IP address or fully qualified domain name of the Moxa serial ethernet controller the gauge controller is connected to
    *   string
*   **PORT**
    *   The TCP port number of the serial port on the Moxa where the gauge controller is connected to (serial port 1 is usually TCP port 4001, serial port 2 is TCP port 4002, and so on)
    *   integer


## vac_gauge_tpg300_500_vgc

`.iocsh` file for the Cold cathode gauge

#### Required macros:

*   **DEVICENAME**
    *   ESS name, the same as in Naming service/CCDB
    *   string
*   **CONTROLLERNAME**
    *   The ESS name of the gauge controller the gauge is connected to
    *   string
*   **CHANNEL**
    *   The channel this gauge is connected to on the controller. Valid values:
        *   A1
        *   B1
    *   string

#### Optional macros:

*   **RELAY_1_DESC**
    *   A description of what Relay 1 controls / represents (to be displayed on the OPI)
    *   default is empty string
    *   string
*   **RELAY_2_DESC**
    *   A description of what Relay 2 controls / represents (to be displayed on the OPI)
    *   default is empty string
    *   string
