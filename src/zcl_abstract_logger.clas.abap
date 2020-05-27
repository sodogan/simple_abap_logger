class zcl_abstract_logger definition
  public
  create public abstract.

  public section.
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

    methods: constructor IMPORTING  !I_IF_LOG_STRATEGY type ref to ZIF_LOG_STRATEGY.
    methods: add_sy_msg abstract importing i_log_level   type ty_log_level
                                 returning value(ro_log) type ref to zcl_abstract_logger .
    methods: add_msg   abstract importing i_log_level   type ty_log_level
                                          i_text        type c
                                returning value(ro_log) type ref to zcl_abstract_logger.

    methods: save  abstract returning value(ro_log) type ref to zcl_abstract_logger.
    methods: is_empty abstract returning value(ro_log) type ref to zcl_abstract_logger.
    methods: has_errors abstract returning value(ro_log) type ref to zcl_abstract_logger.
    methods: has_warnings abstract returning value(ro_log) type ref to zcl_abstract_logger.
    methods: has_info abstract returning value(ro_log) type ref to zcl_abstract_logger.
  protected section.
    data: mo_log_strategy type ref to zif_log_strategy.

  private section.
ENDCLASS.



CLASS ZCL_ABSTRACT_LOGGER IMPLEMENTATION.


  method constructor.
  mo_log_strategy = i_if_log_strategy.
  endmethod.
ENDCLASS.
