#!/usr/bin/python 
## 
# dashsimu Configuration File 
### 
# Buffer size in seconds 
INITIAL_BUFFER_SECONDS = 2 
TOTAL_BUFFER_SECONDS = 2 
# Adaptation on/off 
# Options: True, False 
ADAPTATION = False 
# Preferred representation id 
# Options: Representation id, Off (selects smallest bitrate) 
REPRESENTATIONID = "2" 
# Bitrate limitation 
# Options: 0 (off), bits/s e.g 1Mbit/s: 1000000 
MAXBITRATE = 0 
# Logging level 
# Options: CRITICAL: 50, ERROR: 40, WARNING: 30, INFO: 20, 
# DEBUG: 10, NOTSET: 0 
LOGLEVEL = 20 
# Trace to play.log file on/off 
# Options: True, False 
TRACE = True 
