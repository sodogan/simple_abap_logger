*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section
class lcx_missing_parameter definition inheriting from cx_static_check.

endclass.

interface lif_log_creator.
  methods: create_log IMPORTING  VALUE(is_log_header) type zif_log=>ty_log_header
                       EXPORTING VALUE(er_log_handle) type zif_log=>ty_log_handle.
 .
endinterface.

class lcl_log_creator definition.
  public section.
    interfaces lif_log_creator.
    aliases: create_log for lif_log_creator~create_log.
endclass.
