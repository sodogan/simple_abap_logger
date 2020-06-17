CLASS zcl_abstract_logger DEFINITION
  PUBLIC
  CREATE PUBLIC ABSTRACT.

  PUBLIC SECTION.
    TYPES: ty_log_level TYPE symsgty.
    "Currently levels are only E,W or I
    CONSTANTS:
      error   TYPE ty_log_level VALUE 'E',
      warning TYPE ty_log_level VALUE 'W',
      info    TYPE ty_log_level VALUE 'I'
      .

    "Required for the BAL_LOG Functions in SAP
    TYPES: ty_log_handle TYPE balloghndl,
           ty_log_number TYPE balognr,
           ty_log_header TYPE bal_s_log
           .

    METHODS: constructor IMPORTING  !i_if_log_strategy TYPE REF TO zif_log_strategy.
    METHODS: add_sy_msg ABSTRACT IMPORTING i_log_level   TYPE ty_log_level
                                 RETURNING VALUE(ro_log) TYPE REF TO zcl_abstract_logger .
    METHODS: add_msg   ABSTRACT IMPORTING i_log_level   TYPE ty_log_level
                                          i_text        TYPE c
                                RETURNING VALUE(ro_log) TYPE REF TO zcl_abstract_logger.
    METHODS: display_log ABSTRACT .
    METHODS: save  ABSTRACT RETURNING VALUE(ro_log) TYPE REF TO zcl_abstract_logger.
    METHODS: is_empty ABSTRACT RETURNING VALUE(ro_log) TYPE REF TO zcl_abstract_logger.
    METHODS: has_errors ABSTRACT RETURNING VALUE(ro_log) TYPE REF TO zcl_abstract_logger.
    METHODS: has_warnings ABSTRACT RETURNING VALUE(ro_log) TYPE REF TO zcl_abstract_logger.
    METHODS: has_info ABSTRACT RETURNING VALUE(ro_log) TYPE REF TO zcl_abstract_logger.
  PROTECTED SECTION.
    DATA: mo_log_strategy TYPE REF TO zif_log_strategy.

  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ABSTRACT_LOGGER IMPLEMENTATION.


  METHOD constructor.
    mo_log_strategy = i_if_log_strategy.
  ENDMETHOD.
ENDCLASS.
