CLASS zcl_ms80_modify_practice DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ms80_modify_practice IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

*    out->write( 'Method Execution started' ).
*--------------------------------------Travel + Booking Addition
*    DATA lt_book TYPE TABLE FOR CREATE zms80_i_travel_m\_booking.
*
*    Add entry in Travel
*    MODIFY ENTITY zms80_i_travel_m
*    CREATE FROM VALUE #( ( %cid = 'CID1'
*                         %data-BeginDate = '20250629'
*                         %control-BeginDate = if_abap_behv=>mk-on
*                       ) )
**   Add entry in Association Booking
*    CREATE BY \_booking
*    FROM VALUE #( ( %cid_ref = 'CID1'
*                    %target = VALUE #( ( %cid = 'CID11'         "Different from Travel
*                                         %data-BookingDate = '20250629'
*                                         %control-BookingDate = if_abap_behv=>mk-on
*                                     ) )
*                ) )
*
*    FAILED FINAL(lt_failed)
*    MAPPED FINAL(lt_mapped)
*    REPORTED FINAL(lt_final).
*
*
*    IF lt_failed IS NOT INITIAL.
*      out->write( 'Travel + Booking entry addition failed' ).
*      out->write( lt_failed ).
*    ELSE.
*      out->write( 'Travel + Booking entry added' ).
*      out->write( lt_final ).
*      out->write( lt_mapped ).
*      COMMIT ENTITIES.
*    ENDIF.

**   Add entry in Travel + Bookiing + Booking Supplement-------

**    Add entry in Travel
*    MODIFY ENTITIES OF zms80_i_travel_m
*    ENTITY Travel
*    CREATE FROM VALUE #( ( %cid = 'CID1'
*                         %data-BeginDate = '20250629'
*                         %control-BeginDate = if_abap_behv=>mk-on
*                       ) )
**   Add entry in Association Booking
*    CREATE BY \_booking
*    FROM VALUE #( ( %cid_ref = 'CID1'
*                    %target = VALUE #( ( %cid = 'CID11'         "Different from Travel
*                                         %data-BookingDate = '20250629'
*                                         %control-BookingDate = if_abap_behv=>mk-on
*                                     ) )
*                ) )
*    ENTITY Booking
*    CREATE BY \_BookSupl
*    FROM VALUE #( ( %cid_ref = 'CID11'
*                    %target = VALUE #( ( %cid = 'CID111'
*                                       %data-Price = '21'
*                                       %control-Price = if_abap_behv=>mk-on
*                                     ) )
*                ) )
*    FAILED FINAL(lt_failed)
*    MAPPED FINAL(lt_mapped)
*    REPORTED FINAL(lt_final).
*
*    IF lt_failed IS NOT INITIAL.
*      out->write( 'Travel + Booking + Booking Supplement Addition failed' ).
*      out->write( lt_failed ).
*    ELSE.
*      out->write( 'Travel + Booking + Booking Supplement Addition successfull' ).
*      out->write( lt_final ).
*      out->write( lt_mapped ).
*      COMMIT ENTITIES.
*    ENDIF.

**----------------------------Delete Travel & Booking--------
*    MODIFY ENTITY zms80_i_travel_m
*    DELETE FROM VALUE #( ( %key-TravelId = '00009394' ) )
*    FAILED FINAL(lt_failed1)
*    MAPPED FINAL(lt_mapped1)
*    REPORTED FINAL(lt_final1).
*
*    IF lt_failed1 IS NOT INITIAL.
*      out->write( 'Travel Deletion Failed' ).
*    ELSE.
*      out->write( 'Travel Deletion Successfull' ).
*      out->write( lt_mapped1 ).
*      out->write( lt_final1 ).
*      COMMIT ENTITIES.
*    ENDIF.

***----------------------------Delete Booking--------
*    MODIFY ENTITY zms80_i_booking_m
*    DELETE FROM VALUE #( ( %key-TravelId = '00009392'
*                           %key-BookingId = '0002' ) )
*    FAILED FINAL(lt_failed1)
*    MAPPED FINAL(lt_mapped1)
*    REPORTED FINAL(lt_final1).
*
*    IF lt_failed1 IS NOT INITIAL.
*      out->write( 'Booking Deletion Failed' ).
*    ELSE.
*      out->write( 'Booking Deletion Successfull' ).
*      out->write( lt_mapped1 ).
*      out->write( lt_final1 ).
*      COMMIT ENTITIES.
*    ENDIF.
*-----------------------------------Auto Fill CID
*    out->write( 'Auto Fill CID Execution started' ).
*    DATA lt_book TYPE TABLE FOR CREATE zms80_i_travel_m\_booking.
*
**    Add entry in Travel
*    MODIFY ENTITY zms80_i_travel_m
*    CREATE AUTO FILL CID WITH VALUE #( (
*                         %data-BeginDate = '20250628'
*                         %control-BeginDate = if_abap_behv=>mk-on
*                                     ) )
**   Add entry in Association Booking
*    CREATE BY \_booking
*    AUTO FILL CID WITH VALUE #( ( %cid_ref = '%ABAP_EML_CID__1'
*                    %target = VALUE #( (
*                                         %data-BookingDate = '20250628'
*                                         %control-BookingDate = if_abap_behv=>mk-on
*                                     ) )
*                              ) )
*
*
*
*    FAILED FINAL(lt_failed)
*    MAPPED FINAL(lt_mapped)
*    REPORTED FINAL(lt_final).
*
*
*    IF lt_failed IS NOT INITIAL.
*      out->write( 'Travel + Booking entry addition failed' ).
*      out->write( lt_failed ).
*    ELSE.
*      out->write( 'Travel + Booking entry added' ).
*      out->write( lt_final ).
*      out->write( lt_mapped ).
*      COMMIT ENTITIES.
*    ENDIF.
**---------------------------------Update
*    out->write( 'Travel + Booking Update Execution started' ).
*
**    Add entry in Travel
*    MODIFY ENTITIES OF zms80_i_travel_m
*    ENTITY Travel
*    UPDATE FIELDS ( BeginDate )
*    WITH VALUE #( ( %key-TravelId = '00009410'
*                         %data-BeginDate = '20250622'
*                                     ) )
***   Add entry in Association Booking
*    ENTITY Booking
*    UPDATE FIELDS ( BookingDate )
*    WITH VALUE #( ( %key-TravelId = '00009410'
*                    %key-BookingId = '0002'
*                    %data-BookingDate = '20250622'
*                ) )
*
*    FAILED FINAL(lt_failed)
*    MAPPED FINAL(lt_mapped)
*    REPORTED FINAL(lt_final).
*
*
*    IF lt_failed IS NOT INITIAL.
*      out->write( 'Travel entry Modification failed' ).
*      out->write( lt_failed ).
*    ELSE.
*      out->write( 'Travel entry Modification Successful' ).
*      out->write( lt_final ).
*      out->write( lt_mapped ).
*      COMMIT ENTITIES.
*    ENDIF.
***---------------------------------Update + Delete
*    out->write( 'Travel + Booking - Update + Deletion started' ).
*
**    Add entry in Travel
*    MODIFY ENTITIES OF zms80_i_travel_m
*    ENTITY Travel
*    UPDATE FIELDS ( BeginDate )
*    WITH VALUE #( ( %key-TravelId = '00009410'
*                         %data-BeginDate = '20250624' ) )
*
*    ENTITY Travel
*    DELETE FROM VALUE #( ( %key-TravelId = '00009392' ) ).
*
*    IF sy-subrc IS NOT INITIAL.
*      out->write( 'Update + Delete failed' ).
*    ELSE.
*      out->write( 'Update + Delete Successful' ).
*      COMMIT ENTITIES.
*    ENDIF.
*----------------------------Update Set of Values----
    MODIFY ENTITY zms80_i_travel_m
    UPDATE SET FIELDS WITH VALUE #( ( %key-TravelId = '00009406'
                                      %data-AgencyId = '0000014' ) ).
    IF sy-subrc = 0.
      out->write( 'Update set of values Successful' ).
      COMMIT ENTITIES.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
