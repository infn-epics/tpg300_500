# Vacuum Gauge Controller Pfeiffer TPG-300 and TPG-500
# Vacuum Cold Cathode Gauge TPG

EPICS module to provide communications and read/write data from/to TPG-300 and TPG-500 vacuum gauge controller and
*   to read/write data for TPG vacuum cold cathode gauge.

IOC does not directly communicate with the gauges, the gauge is actully connected to a gauge controller. IOC communicates with the controller and controller provides gauge data. Controllers can have multiple gauges in different channels.
