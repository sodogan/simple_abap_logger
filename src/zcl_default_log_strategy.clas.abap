class zcl_default_log_strategy definition
  public
  final
  create public .

  public section.
  interfaces zif_log_strategy.
  protected section.
  private section.
endclass.



class zcl_default_log_strategy implementation.
  method zif_log_strategy~create_log.

  endmethod.

  method zif_log_strategy~search_log_exists.

  endmethod.

endclass.
