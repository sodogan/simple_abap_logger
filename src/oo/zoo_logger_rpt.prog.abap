*&---------------------------------------------------------------------*
*& Report ZTEST_BAL_LOGS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT  zoo_logger_rpt.



*Begin of Selection Screen
SELECTION-SCREEN: BEGIN OF SCREEN 100.
PARAMETERS: p_obj TYPE bal_s_log-object DEFAULT 'ZMIG'.
PARAMETERS: psub_obj TYPE bal_s_log-subobject DEFAULT 'ARUN'.
PARAMETERS: p_table TYPE tabname DEFAULT 'SCARR'.
SELECTION-SCREEN:END OF SCREEN 100.
*End of Selection Screen



*/*
* Basic Report to test the Logger Functionality
* Notice the use of the log object
* You can specify your own log strategy otherwise will use the default
*/
CLASS lcl_main DEFINITION  FINAL.
  PUBLIC SECTION.
    CONSTANTS: gc_log_object_zmig TYPE string VALUE `ZMIG` ##NO_TEXT.
    CONSTANTS: gc_log_subobject_arun TYPE string VALUE `ARUN` ##NO_TEXT.
    METHODS: main.
  PRIVATE SECTION.
    DATA:mo_logger TYPE REF TO zcl_simple_logger.
    DATA: mt_scarr TYPE STANDARD TABLE OF scarr WITH DEFAULT KEY.
    METHODS: init.
    METHODS: get_data.
    METHODS: apply_business_rules.
    METHODS: display.
ENDCLASS.
CLASS lcl_main IMPLEMENTATION.

  METHOD init.
    mo_logger = NEW #( i_log_header = VALUE #( object = |{ gc_log_object_zmig }| subobject = |{ gc_log_subobject_arun }| ) ).
  ENDMETHOD.


  METHOD get_data.

*   Try to add a basic error message
    MESSAGE i000(oo) WITH 'Before the getdata method: ' 'Fetching data' INTO DATA(dummy).
    mo_logger->add_sy_msg( i_log_level = zcl_abstract_logger=>info ).
**   Try to add  a text to the log!
    SELECT * FROM scarr
      INTO TABLE @mt_scarr
      UP TO 200 ROWS
      .
    IF sy-subrc NE 0.
      MESSAGE e000(oo) WITH 'No data has been found: ' 'Failed fetching' INTO dummy.
      mo_logger->add_sy_msg( i_log_level = zcl_abstract_logger=>info ).
    ENDIF.


  ENDMETHOD.

  METHOD apply_business_rules.
    MESSAGE i000(oo) WITH 'Inside the getdata method: ' 'Fetching data' INTO DATA(dummy).
    mo_logger->add_msg( i_log_level = zcl_abstract_logger=>info i_text = |Inside the apply business rules method: | && |apply business rules| ).

  ENDMETHOD.


  METHOD display.

    TRY .
*   SALV-Table
        DATA: o_salv TYPE REF TO cl_salv_table.

        cl_salv_table=>factory( IMPORTING
                                  r_salv_table   = o_salv
                                CHANGING
                                  t_table        = mt_scarr ).

*   Grundeinstellungen
*... §3.1 activate ALV generic Functions
        DATA(lr_functions) = o_salv->get_functions( ).
        o_salv->get_functions( )->set_all( abap_true ).

*... §3.2 include own functions by setting own status
*        TRY.
*            lr_functions->add_function(
*              name     = 'GET_SEL'
*              icon     = space
*              text     = |{ TEXT-b01 }|
*              tooltip  = |{ TEXT-b01 }|
*              position = if_salv_c_function_position=>right_of_salv_functions ).
*          CATCH cx_salv_wrong_call cx_salv_existing.
*        ENDTRY.


        o_salv->get_columns( )->set_optimize( abap_true ).
        o_salv->get_display_settings( )->set_list_header( |The data found for table: { p_table }| ).
        o_salv->get_display_settings( )->set_striped_pattern( abap_true ).
        o_salv->get_selections( )->set_selection_mode( if_salv_c_selection_mode=>row_column ).

*   Spaltenüberschriften: technischer Name und Beschreibungstexte
        LOOP AT o_salv->get_columns( )->get( ) ASSIGNING FIELD-SYMBOL(<c>).
          DATA(o_col) = <c>-r_column.
          o_col->set_short_text( || ).
          o_col->set_medium_text( || ).
          o_col->set_long_text( |{ o_col->get_columnname( ) } [{ o_col->get_long_text( ) }]| ).
        ENDLOOP.

        o_salv->display( ).
* Display the Log here
        mo_logger->display_log( ).

      CATCH cx_root INTO DATA(lo_exception) .
        BREAK-POINT.
    ENDTRY.

  ENDMETHOD.

  METHOD main.

    CALL SELECTION-SCREEN 100.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.


    init( ).
    get_data( ).
    apply_business_rules( ).
    display( ).
  ENDMETHOD.


ENDCLASS.


START-OF-SELECTION.
***Run the test code here!
  NEW lcl_main( )->main( ).
