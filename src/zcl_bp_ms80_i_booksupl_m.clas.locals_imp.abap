CLASS lhc_booksupl DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS ValidateCurrencyCode FOR VALIDATE ON SAVE
      IMPORTING keys FOR BookSupl~ValidateCurrencyCode.

    METHODS ValidatePrice FOR VALIDATE ON SAVE
      IMPORTING keys FOR BookSupl~ValidatePrice.

    METHODS ValidateSupplement FOR VALIDATE ON SAVE
      IMPORTING keys FOR BookSupl~ValidateSupplement.
    METHODS calculateTotalPrice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR BookSupl~calculateTotalPrice.

ENDCLASS.

CLASS lhc_booksupl IMPLEMENTATION.

  METHOD ValidateCurrencyCode.
  ENDMETHOD.

  METHOD ValidatePrice.
  ENDMETHOD.

  METHOD ValidateSupplement.
  ENDMETHOD.

  METHOD calculateTotalPrice.

    DATA it_travel TYPE STANDARD TABLE OF zms80_travel_m WITH UNIQUE HASHED KEY key COMPONENTS travel_id.

    it_travel = CORRESPONDING #( keys DISCARDING DUPLICATES MAPPING travel_id = TravelId ).
    MODIFY ENTITIES OF zms80_i_travel_m IN LOCAL MODE
      ENTITY Travel
      EXECUTE recalcTotPrice
      FROM CORRESPONDING #( it_travel ).

  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
