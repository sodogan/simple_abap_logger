FUNCTION-POOL ZFG_ABAP_LOGGER.              "MESSAGE-ID ..

 TYPES ty_log_level TYPE symsgty .
    "Required for the BAL_LOG Functions in SAP
    TYPES ty_log_handle TYPE balloghndl .
    TYPES ty_log_number TYPE balognr .
    TYPES ty_log_header TYPE bal_s_log .

    TYPES: BEGIN OF ty_log_data,
             log_handle TYPE REF TO ty_log_handle,
             log_number TYPE ty_log_number,
             log_header TYPE ty_log_header,
           END OF ty_log_data.

   DATA: mo_log_data TYPE ty_log_data.

* INCLUDE LZFG_ABAP_LOGGERD...               " Local class definition
