interface zif_log
  public .
  types: ty_log_level type symsgty.
  "Currently levels are only E,W or I
  constants:
    error   type ty_log_level value 'E',
    warning type ty_log_level value 'W',
    info    type ty_log_level value 'I'
    .

  "Required for the BAL_LOG Functions in SAP
  types: ty_log_handle type balloghndl,
         ty_log_number type balognr,
         ty_log_header type bal_s_log
         .


  methods: add  importing i_log_level   type ty_log_level
                returning value(ro_log) type ref to zif_log.
  methods: save returning value(ro_log) type ref to zif_log.
  methods: is_empty returning value(ro_log) type ref to zif_log.

  methods: has_errors returning value(ro_log) type ref to zif_log.
  methods: has_warnings returning value(ro_log) type ref to zif_log.
  methods: has_info returning value(ro_log) type ref to zif_log.

endinterface.
