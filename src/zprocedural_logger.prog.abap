*&---------------------------------------------------------------------*
*& Report ZTEST_BAL_LOGS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT  zprocedural_logger.


DATA: gt_scarr TYPE STANDARD TABLE OF scarr WITH DEFAULT KEY.

*/*
* Basic Report to test the Logger Functionality
* Notice the use of the log object
* You can specify your own log strategy otherwise will use the default
*/

INCLUDE: zprocedural_logger_inc.

*Begin of Selection Screen
SELECTION-SCREEN: BEGIN OF BLOCK main WITH FRAME TITLE title.
PARAMETERS: p_obj TYPE bal_s_log-object DEFAULT 'ZMIG'.
PARAMETERS: p_subobj TYPE bal_s_log-subobject DEFAULT 'ARUN'.
PARAMETERS: p_table TYPE tabname DEFAULT 'SCARR' OBLIGATORY.

SELECTION-SCREEN:END OF BLOCK main.
*End of Selection Screen



START-OF-SELECTION.
***Run the test code here!
  PERFORM init.
  PERFORM get_data.
  PERFORM apply_business_rules.
  PERFORM display.


FORM init.
  PERFORM create_log USING p_obj p_subobj.
ENDFORM.


FORM get_data.
**   Try to add  a text to the log!
    SELECT * FROM scarr
      INTO TABLE @gt_scarr
      UP TO 200 ROWS
      .
    IF sy-subrc NE 0.
     PERFORM add_message USING 'E' 'ZABAP_MSG' '002' 'No data has been found:'  space space space '1'.
    ENDIF.
ENDFORM.

FORM apply_business_rules.
  PERFORM add_message USING 'I' 'ZABAP_MSG' '001' 'Applying business rules on the data:'  space space space '1'.
ENDFORM.

FORM display.
* Save and show all the collected messages.
  TRY .
*   SALV-Table
        DATA: o_salv TYPE REF TO cl_salv_table.

        cl_salv_table=>factory( IMPORTING
                                  r_salv_table   = o_salv
                                CHANGING
                                  t_table        = gt_scarr ).

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

      CATCH cx_root INTO DATA(lo_exception) .
        BREAK-POINT.
    ENDTRY.

*  PERFORM save_and_show_messages.
ENDFORM.
