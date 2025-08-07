CLASS zcl_ms80_read_practice DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ms80_read_practice IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

* Option 1 - Display Travel fields
*    READ ENTITY zms80_i_travel_m
*    FROM VALUE #( ( %key-TravelId = '00000001'
*                    %control = VALUE #( AgencyId = if_abap_behv=>mk-on
*                                        BeginDate = if_abap_behv=>mk-on
*                                        CustomerId = if_abap_behv=>mk-on
*                                        BookingFee = if_abap_behv=>mk-on ) ) )

* Option 2 - Display Travel fields
*    READ ENTITY zms80_i_travel_m
*    FIELDS ( AgencyId BeginDate CustomerId BookingFee )
*    WITH VALUE #( ( %key-TravelId = '00000001' ) )

** Option 3 - Display Booking fields via Association
*    READ ENTITY zms80_i_travel_m
*    by \_booking
*    ALL FIELDS
*    WITH VALUE #( ( %key-TravelId = '00000002' ) )

** Option 4 - Display Booking fields
*    READ ENTITY zms80_i_travel_m
*    by \_Booking
*    ALL FIELDS
*    WITH VALUE #( ( %key-TravelId = '00000001' )
*                  ( %key-TravelId = '00000002' ) )

** Option 5 - Display Booking Supplement fields via Association
*    READ ENTITY zms80_i_booking_m
*    BY \_Booksupl
*    ALL FIELDS
*    WITH VALUE #( ( %key-TravelId = '00000002'
*                    %key-BookingId = '0013' ) )

** Option 6 - Display Booking Supplement fields
*    READ ENTITY zms80_i_booksupl_m
*    ALL FIELDS
*    WITH VALUE #( ( %key-TravelId = '00000002'
*                    %key-BookingId = '0013'
*                    %key-BookingSupplementId = '10' ) )
*
*    RESULT DATA(lt_result_short)
*    FAILED DATA(lt_result_failed) .
*
*    IF lt_result_failed IS NOT INITIAL.
*      out->write( 'Read Failed' ).
*    ELSE.
*      out->write( lt_result_short ).
*    ENDIF.

*-------------------------Access Multiple Entities at a time--------------

*    READ ENTITIES OF zms80_i_travel_m
*
*        ENTITY Travel
*        ALL FIELDS WITH VALUE #( ( %key-TravelId  = '00000002' ) )
*        RESULT DATA(lt_result_travel)
*
*        ENTITY Booking
*        ALL FIELDS WITH VALUE #( ( %key-TravelId = '00009296'
*                                   %key-BookingId = '0031' ) )
*        RESULT DATA(lt_result_booking)
*
*        ENTITY BookSupl
*        ALL FIELDS WITH VALUE #( ( %key-TravelId  = '00000002'
*                                   %key-BookingId = '2002'
*                                   %key-BookingSupplementId = '31' ) )
*
*        RESULT DATA(lt_result_booksupl)
*        FAILED DATA(lt_result_failed).
*
*    IF lt_result_failed IS NOT INITIAL.
*      out->write( 'Read Failed' ).
*      out->write( lt_result_failed ).
*    ELSE.
*      out->write( lt_result_travel ).
*      out->write( lt_result_booking ).
*      out->write( lt_result_booksupl ).
*    ENDIF.
**---------Dynamic Call of Entities & Assocaitions - 3 levels-----------
*
*    DATA: it_optab           TYPE abp_behv_retrievals_tab,
*          it_travel          TYPE TABLE FOR READ IMPORT zms80_i_travel_m,
*          it_travel_result   TYPE TABLE FOR READ RESULT zms80_i_travel_m,
*          it_booking         TYPE TABLE FOR READ IMPORT zms80_i_travel_m\_Booking,
*          it_booking_reuslt  TYPE TABLE FOR READ RESULT zms80_i_travel_m\_Booking,
*          it_booksupl        TYPE TABLE FOR READ IMPORT zms80_i_booking_m\_BookSupl,
*          it_booksupl_reuslt TYPE TABLE FOR READ RESULT zms80_i_booking_m\_BookSupl.
*
*    it_travel = VALUE #( ( %key-TravelId = '00000002'
*                           %control = VALUE #( AgencyId = if_abap_behv=>mk-on
*                                               CustomerId = if_abap_behv=>mk-on
*                                               BeginDate = if_abap_behv=>mk-on ) ) ).
*
*    it_booking = VALUE #( ( %key-TravelId = '00000002'
*                            %control = VALUE #( BookingId = if_abap_behv=>mk-on
*                                                CustomerId = if_abap_behv=>mk-on
*                                                CarrierId = if_abap_behv=>mk-on ) ) ).
*
*    it_booksupl = VALUE #( ( %key-TravelId = '00000002'
*                             %key-BookingId = '2002'
*                            %control = VALUE #( BookingId = if_abap_behv=>mk-on
*                                                BookingSupplementId = if_abap_behv=>mk-on
*                                                Price = if_abap_behv=>mk-on ) ) ).
*
*    it_optab = VALUE #( ( op = if_abap_behv=>op-r-read
*                          entity_name = 'ZMS80_I_TRAVEL_M'
*                          instances = REF #( it_travel )
*                          results = REF #( it_travel_result ) )
*                        ( op = if_abap_behv=>op-r-read_ba
*                          entity_name = 'ZMS80_I_TRAVEL_M'
*                          sub_name = '_BOOKING'
*                          instances = REF #( it_booking )
*                          results = REF #( it_booking_reuslt ) )
*                        ( op = if_abap_behv=>op-r-read_ba
*                          entity_name = 'ZMS80_I_BOOKING_M'
*                          sub_name = '_BOOKSUPL'
*                          instances = REF #( it_booksupl )
*                          results = REF #( it_booksupl_reuslt ) )
*                      ).
*
*    READ ENTITIES
*    OPERATIONS it_optab
*    FAILED DATA(lt_fail_dynamic).
*
*    IF lt_fail_dynamic IS NOT INITIAL.
*      out->write( 'Read is failed' ).
*    ELSE.
*      out->write( 'Dynamic Travel Entity Data' ).a
*      out->write( it_travel_result ).
*      out->write( it_booking_reuslt ).
*      out->write( it_booksupl_reuslt ).
*    ENDIF.

  ENDMETHOD.

ENDCLASS.
