CLASS lhc_booking DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS earlynumbering_cba_Booksupl FOR NUMBERING
      IMPORTING entities FOR CREATE Booking\_Booksupl.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Booking RESULT result.

    METHODS validateconnection FOR VALIDATE ON SAVE
      IMPORTING keys FOR booking~validateconnection.

    METHODS validatecurrencycode FOR VALIDATE ON SAVE
      IMPORTING keys FOR booking~validatecurrencycode.

    METHODS validatecustomer FOR VALIDATE ON SAVE
      IMPORTING keys FOR booking~validatecustomer.

    METHODS validateflightprice FOR VALIDATE ON SAVE
      IMPORTING keys FOR booking~validateflightprice.

    METHODS validatestatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR booking~validatestatus.

    METHODS calculatetotalprice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR booking~calculatetotalprice.

ENDCLASS.

CLASS lhc_booking IMPLEMENTATION.

  METHOD earlynumbering_cba_Booksupl.

    DATA: max_booksupl_id TYPE /dmo/booking_supplement_id.

    READ ENTITIES OF zms80_i_travel_m IN LOCAL MODE
    ENTITY Booking BY \_BookSupl
    FROM CORRESPONDING #( entities )
    LINK DATA(booking_supplement).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<booking_group>) GROUP BY <booking_group>-%tky.

      max_booksupl_id = REDUCE #( INIT max = CONV /dmo/booking_supplement_id( '0' )

                                  FOR booksupl IN booking_supplement USING KEY entity
                                  WHERE ( source-TravelId = <booking_group>-TravelId
                                  AND     source-BookingId = <booking_group>-BookingId )

                                  NEXT max = COND /dmo/booking_supplement_id( WHEN booksupl-target-BookingSupplementId > max
                                                                              THEN booksupl-target-BookingSupplementId
                                                                              ELSE max ) ).

      max_booksupl_id = REDUCE #( INIT max = max_booksupl_id

                                  FOR entity IN entities USING KEY entity
                                  WHERE ( TravelId = <booking_group>-TravelId
                                  AND     BookingId = <booking_group>-BookingId )

                                  FOR target IN entity-%target
                                  NEXT max = COND /dmo/booking_supplement_id( WHEN target-BookingSupplementId > max
                                                                              THEN target-BookingSupplementId
                                                                              ELSE max ) ).

      LOOP AT entities ASSIGNING FIELD-SYMBOL(<booking>) USING KEY entity WHERE TravelId = <booking_group>-TravelId
                                                                          AND   BookingId = <booking_group>-BookingId.

        LOOP AT <booking>-%target ASSIGNING FIELD-SYMBOL(<booksupl_wo_number>).
          APPEND CORRESPONDING #( <booksupl_wo_number> ) TO mapped-booksupl ASSIGNING FIELD-SYMBOL(<mapped_booksuppl>).
          IF <booksupl_wo_number>-BookingSupplementId IS INITIAL.
            max_booksupl_id += 1.
            <mapped_booksuppl>-BookingSupplementId = max_booksupl_id.
          ENDIF.
        ENDLOOP.

      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.

  METHOD get_instance_features.

    READ ENTITIES OF zms80_i_travel_m IN LOCAL MODE
      ENTITY Travel BY \_booking
      FIELDS ( TravelId BookingStatus )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_booking).

    result = VALUE #( FOR ls_booking IN lt_booking
                    ( %tky = ls_booking-%tky
                      %features-%assoc-_BookSupl = COND #( WHEN ls_booking-BookingStatus = 'A'
                                                               THEN if_abap_behv=>fc-o-disabled
                                                               ELSE if_abap_behv=>fc-o-enabled ) ) ).

  ENDMETHOD.

  METHOD ValidateConnection.
  ENDMETHOD.

  METHOD ValidateCurrencyCode.
  ENDMETHOD.

  METHOD ValidateCustomer.
  ENDMETHOD.

  METHOD ValidateFlightPrice.
  ENDMETHOD.

  METHOD ValidateStatus.
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
