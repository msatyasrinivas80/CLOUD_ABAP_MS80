CLASS lsc_zms80_i_travel_m DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zms80_i_travel_m IMPLEMENTATION.

  METHOD save_modified.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Travel RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Travel RESULT result.

    METHODS acceptTravel FOR MODIFY
      IMPORTING keys FOR ACTION Travel~acceptTravel RESULT result.

    METHODS copyTravel FOR MODIFY
      IMPORTING keys FOR ACTION Travel~copyTravel.

    METHODS recalcTotPrice FOR MODIFY
      IMPORTING keys FOR ACTION Travel~recalcTotPrice.

    METHODS rejectTravel FOR MODIFY
      IMPORTING keys FOR ACTION Travel~rejectTravel RESULT result.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Travel RESULT result.

    METHODS validatecustomer FOR VALIDATE ON SAVE
      IMPORTING keys FOR travel~validatecustomer.

    METHODS validatebookingfee FOR VALIDATE ON SAVE
      IMPORTING keys FOR travel~validatebookingfee.

    METHODS validatecurrencycode FOR VALIDATE ON SAVE
      IMPORTING keys FOR travel~validatecurrencycode.

    METHODS validatedates FOR VALIDATE ON SAVE
      IMPORTING keys FOR travel~validatedates.

    METHODS validatestatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR travel~validatestatus.
    METHODS calculatetotalprice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR travel~calculatetotalprice.

    METHODS earlynumbering_cba_Booking FOR NUMBERING
      IMPORTING entities FOR CREATE Travel\_Booking.

    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE Travel.

ENDCLASS.

CLASS lhc_Travel IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create.
    DATA(lt_entities) = entities.
    DELETE lt_entities WHERE TravelId IS NOT INITIAL.

    TRY.
        cl_numberrange_runtime=>number_get(
          EXPORTING
*        ignore_buffer     =
            nr_range_nr       = '01'
            object            = '/DMO/TRV_M'
            quantity          = CONV #( lines( lt_entities ) )
*        subobject         =
*        toyear            =
          IMPORTING
            number            = DATA(LV_latest_num)
            returncode        = DATA(lv_code)
            returned_quantity = DATA(lv_qty)
        ).

      CATCH cx_nr_object_not_found.
      CATCH cx_number_ranges INTO DATA(lo_error).

        LOOP AT lt_entities INTO DATA(ls_entities).

          APPEND VALUE #( %cid = ls_entities-%cid
                          %key = ls_entities-%key )
                     TO failed-travel.

          APPEND VALUE #( %cid = ls_entities-%cid
                          %key = ls_entities-%key
                          %msg = lo_error )
                     TO reported-travel.
        ENDLOOP.
        EXIT.
    ENDTRY.

    ASSERT lv_qty = lines( lt_entities ).

    DATA(lv_curr_num) = lv_latest_num - lv_qty.

*    DATA: lt_travel TYPE TABLE FOR MAPPED EARLY zms80_i_travel_m,
*          ls_travel LIKE LINE OF lt_travel.

    LOOP AT lt_entities INTO ls_entities.

      lv_curr_num += lv_curr_num.

*      ls_travel = VALUE #( %cid = ls_entities-%cid
*                           TravelId = lv_curr_num ).
*
*      APPEND ls_travel TO mapped-travel.
*----------------OR----------------------
      APPEND VALUE #( %cid = ls_entities-%cid
                      TravelID = lv_curr_num )
                 TO mapped-travel.

    ENDLOOP.

  ENDMETHOD.

  METHOD earlynumbering_cba_Booking.
    DATA lv_max_booking TYPE /dmo/booking_id.

    READ ENTITIES OF zms80_i_travel_m IN LOCAL MODE
    ENTITY Travel BY \_booking
    FROM CORRESPONDING #( entities )
    LINK DATA(lt_link_data).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_group_entity>)
                            GROUP BY <ls_group_entity>-TravelId.

      lv_max_booking = REDUCE #( INIT lv_max = CONV /dmo/booking_id( '0' )
                                 FOR ls_link IN lt_link_data
                                 WHERE ( source-TravelId = <ls_group_entity>-TravelId )
                                 NEXT lv_max = COND /dmo/booking_id( WHEN lv_max < ls_link-target-BookingId
                                                                     THEN ls_link-target-BookingId
                                                                     ELSE lv_max ) ).

      lv_max_booking = REDUCE #( INIT lv_max = lv_max_booking
                                 FOR ls_entity IN entities USING KEY entity
                                 WHERE ( TravelId = <ls_group_entity>-TravelId )
                                 FOR ls_booking IN ls_entity-%target
                                 NEXT lv_max = COND /dmo/booking_id( WHEN lv_max < ls_booking-BookingId
                                                                     THEN ls_booking-BookingId
                                                                     ELSE lv_max ) ).

      LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_entities>)
                      USING KEY entity
                      WHERE TravelId = <ls_group_entity>-TravelId.

        LOOP AT <ls_entities>-%target ASSIGNING FIELD-SYMBOL(<ls_booking>).
          APPEND CORRESPONDING #( <ls_booking> ) TO mapped-booking
          ASSIGNING FIELD-SYMBOL(<ls_new_map_booking>).
          IF <ls_booking>-BookingId IS INITIAL.
            lv_max_booking += 2.
            <ls_new_map_booking>-BookingId = lv_max_booking.
          ENDIF.
        ENDLOOP.

      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.

  METHOD acceptTravel.

    MODIFY ENTITIES OF zms80_i_travel_m IN LOCAL MODE
    ENTITY Travel
    UPDATE FIELDS ( OverallStatus )
    WITH VALUE #( FOR ls_keys IN keys ( %tky = ls_keys-%tky
                                        OverallStatus = 'A' ) )
    REPORTED DATA(lt_travel).

    READ ENTITIES OF zms80_i_travel_m IN LOCAL MODE
    ENTITY Travel
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).

    result = VALUE #( FOR ls_result IN lt_result ( %tky = ls_result-%tky
                                               %param = ls_result ) ).

  ENDMETHOD.

  METHOD copyTravel.

    DATA: lt_travel       TYPE TABLE FOR CREATE zms80_i_travel_m,
          lt_booking_cba  TYPE TABLE FOR CREATE zms80_i_travel_m\_booking,
          lt_booksupl_cba TYPE TABLE FOR CREATE zms80_i_booking_m\_BookSupl.

    READ TABLE keys ASSIGNING FIELD-SYMBOL(<fs_without_cid>) WITH KEY %cid = ''.
    ASSERT <fs_without_cid> IS NOT ASSIGNED.

    READ ENTITIES OF zms80_i_travel_m IN LOCAL MODE
    ENTITY Travel
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel_r)
    FAILED DATA(lt_failed).

    READ ENTITIES OF zms80_i_travel_m IN LOCAL MODE
    ENTITY Travel BY \_Booking
    ALL FIELDS WITH CORRESPONDING #( lt_travel_r )
    RESULT DATA(lt_booking_r).

    READ ENTITIES OF zms80_i_travel_m IN LOCAL MODE
    ENTITY Booking BY \_BookSupl
    ALL FIELDS WITH CORRESPONDING #( lt_booking_r )
    RESULT DATA(lt_booksupl_r).

    LOOP AT lt_travel_r ASSIGNING FIELD-SYMBOL(<ls_travel_r>).

*-----------------------------------------------
*      APPEND INITIAL LINE TO lt_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).
*      <ls_travel>-%cid = keys[ KEY entity TravelId = <ls_travel_r>-TravelId ]-%cid.
*      <ls_travel>-%data = CORRESPONDING #( <ls_travel_r> EXCEPT TravelId ).
*---------------------------------------------OR
      APPEND VALUE #( %cid = keys[ KEY entity TravelId = <ls_travel_r>-TravelId ]-%cid
                      %data =  CORRESPONDING #( <ls_travel_r> EXCEPT TravelId ) )
                      TO lt_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).
*-----------------------------------------------

      <ls_travel>-BeginDate = cl_abap_context_info=>get_system_date(  ).
      <ls_travel>-EndDate = cl_abap_context_info=>get_system_date(  ) + 30.
      <ls_travel>-OverallStatus = '0'.

      APPEND VALUE #( %cid_ref = <ls_travel>-%cid )
      TO lt_booking_cba ASSIGNING FIELD-SYMBOL(<lt_booking>).

      LOOP AT lt_booking_r ASSIGNING FIELD-SYMBOL(<ls_booking_r>)
                           USING KEY entity
                           WHERE TravelId = <ls_travel_r>-TravelId.
        APPEND VALUE #( %cid = <ls_travel>-%cid && <ls_booking_r>-BookingId
                        %data = CORRESPONDING #( <ls_booking_r> EXCEPT TravelID ) )
                      TO <lt_booking>-%target ASSIGNING FIELD-SYMBOL(<ls_booking_n>).

        <ls_booking_n>-BookingStatus = 'N'.

        APPEND VALUE #( %cid_ref = <ls_booking_n>-%cid )
        TO lt_booksupl_cba ASSIGNING FIELD-SYMBOL(<ls_booksupl>).

        LOOP AT lt_booksupl_r ASSIGNING FIELD-SYMBOL(<ls_booksupl_r>)
                    USING KEY entity
                    WHERE TravelId = <ls_travel_r>-TravelId
                    AND   BookingId = <ls_booking_r>-BookingId.

          APPEND VALUE #( %cid = <ls_travel>-%cid && <ls_booking_r>-BookingId && <ls_booksupl_r>-BookingSupplementId
                          %data = CORRESPONDING #( <ls_booksupl_r> EXCEPT TravelID BookingId ) )
                          TO <ls_booksupl>-%target.

        ENDLOOP.

      ENDLOOP.

    ENDLOOP.

    MODIFY ENTITIES OF zms80_i_travel_m IN LOCAL MODE
    ENTITY Travel
    CREATE FIELDS ( AgencyId CustomerId BeginDate EndDate BookingFee TotalPrice CurrencyCode OverallStatus Description )
    WITH lt_travel

    ENTITY Travel CREATE BY \_booking
    FIELDS ( BookingId BookingDate CustomerId CarrierId ConnectionId FlightDate FlightPrice CurrencyCode BookingStatus )
    WITH lt_booking_cba

    ENTITY Booking CREATE BY \_BookSupl
    FIELDS ( BookingSupplementId SupplementId Price CurrencyCode )
    WITH lt_booksupl_cba

    MAPPED DATA(lt_mapped).

    mapped-travel = lt_mapped-travel.


  ENDMETHOD.

  METHOD recalcTotPrice.

    TYPES: BEGIN OF ty_total,
             price TYPE /dmo/total_price,
             curr  TYPE /dmo/currency_code,
           END OF ty_total.

    DATA: lt_total      TYPE TABLE OF ty_total,
          lv_conv_price TYPE ty_total-price.

    READ ENTITIES OF zms80_i_travel_m IN LOCAL MODE
    ENTITY Travel
    FIELDS ( BookingFee CurrencyCode )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel).

    DELETE lt_travel WHERE CurrencyCode IS INITIAL.

    READ ENTITIES OF zms80_i_travel_m IN LOCAL MODE
    ENTITY Travel BY \_booking
    FIELDS ( FlightPrice CurrencyCode )
    WITH CORRESPONDING #( lt_travel )
    RESULT DATA(lt_ba_booking).

    READ ENTITIES OF zms80_i_travel_m IN LOCAL MODE
    ENTITY Booking BY \_BookSupl
    FIELDS ( Price CurrencyCode )
    WITH CORRESPONDING #( lt_ba_booking )
    RESULT DATA(lt_ba_booksupl).

    LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).
      lt_total = VALUE #( ( price = <ls_travel>-BookingFee curr = <ls_travel>-CurrencyCode ) ).

      LOOP AT lt_ba_booking ASSIGNING FIELD-SYMBOL(<ls_booking>)
                                      USING KEY entity
                                      WHERE TravelId = <ls_travel>-TravelId
                                      AND CurrencyCode IS NOT INITIAL.

        APPEND VALUE #( price = <ls_booking>-FlightPrice curr = <ls_booking>-CurrencyCode )
        TO lt_total.

        LOOP AT lt_ba_booksupl ASSIGNING FIELD-SYMBOL(<ls_booksupl>)
                                        USING KEY entity
                                        WHERE TravelId = <ls_travel>-TravelId
                                        AND   BookingId = <ls_booking>-BookingId
                                        AND   CurrencyCode IS NOT INITIAL.
          APPEND VALUE #( price = <ls_booksupl>-Price curr = <ls_booksupl>-CurrencyCode )
          TO lt_total.
        ENDLOOP.
      ENDLOOP.

      LOOP AT lt_total ASSIGNING FIELD-SYMBOL(<ls_total>).

        IF  <ls_total>-curr = <ls_travel>-CurrencyCode.
          lv_conv_price = <ls_total>-price.
        ELSE.
          /dmo/cl_flight_amdp=>convert_currency(
            EXPORTING
              iv_amount               = <ls_total>-price
              iv_currency_code_source = <ls_total>-curr
              iv_currency_code_target = <ls_travel>-CurrencyCode
              iv_exchange_rate_date   = cl_abap_context_info=>get_system_date(  )
            IMPORTING
              ev_amount               = lv_conv_price
          ).
        ENDIF.

        <ls_travel>-TotalPrice += lv_conv_price.

      ENDLOOP.

    ENDLOOP.

    MODIFY ENTITIES OF zms80_i_travel_m IN LOCAL MODE
    ENTITY Travel
    UPDATE FIELDS ( TotalPrice )
    WITH CORRESPONDING #( lt_travel ).

  ENDMETHOD.

  METHOD rejectTravel.

    MODIFY ENTITIES OF zms80_i_travel_m IN LOCAL MODE
      ENTITY Travel
      UPDATE FIELDS ( OverallStatus )
      WITH VALUE #( FOR ls_keys IN keys ( %tky = ls_keys-%tky
                                      OverallStatus = 'X' ) )
  REPORTED DATA(lt_travel).

    READ ENTITIES OF zms80_i_travel_m IN LOCAL MODE
    ENTITY Travel
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).

    result = VALUE #( FOR ls_result IN lt_result ( %tky = ls_result-%tky
                                               %param = ls_result ) ).

  ENDMETHOD.

  METHOD get_instance_features.

    READ ENTITIES OF zms80_i_travel_m IN LOCAL MODE
    ENTITY Travel
    FIELDS ( TravelId OverallStatus )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel).

    result = VALUE #( FOR ls_travel IN lt_travel
                    ( %tky = ls_travel-%tky
                      %features-%action-acceptTravel = COND #( WHEN ls_travel-OverallStatus = 'A'
                                                               THEN if_abap_behv=>fc-o-disabled
                                                               ELSE if_abap_behv=>fc-o-enabled )
                      %features-%action-rejectTravel = COND #( WHEN ls_travel-OverallStatus = 'X'
                                                               THEN if_abap_behv=>fc-o-disabled
                                                               ELSE if_abap_behv=>fc-o-enabled )
                     %features-%assoc-_booking = COND #( WHEN ls_travel-OverallStatus = 'A'
                                                               THEN if_abap_behv=>fc-o-disabled
                                                               ELSE if_abap_behv=>fc-o-enabled ) ) ).

  ENDMETHOD.

  METHOD validateCustomer.

    READ ENTITY IN LOCAL MODE zms80_i_travel_m
    FIELDS ( CustomerId )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel).

    DATA: lt_cust TYPE SORTED TABLE OF /dmo/customer WITH UNIQUE KEY customer_id.

    lt_cust = CORRESPONDING #( lt_travel DISCARDING DUPLICATES MAPPING customer_id = CustomerId ).
    DELETE lt_cust WHERE customer_id IS INITIAL.
    IF lt_travel IS NOT INITIAL.
      SELECT FROM /dmo/customer
      FIELDS customer_id
      FOR ALL ENTRIES IN @lt_travel
      WHERE customer_id = @lt_travel-CustomerId
      INTO TABLE @DATA(lt_cust_db).

      IF sy-subrc = 0.

      ENDIF.
    ENDIF.
    LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).

      IF <ls_travel>-CustomerId IS INITIAL
      OR NOT line_exists( lt_cust_db[ customer_id = <ls_travel>-CustomerId ] ).

        APPEND VALUE #( %tky = <ls_travel>-%tky )
                     TO failed-travel.
        APPEND VALUE #( %tky = <ls_travel>-%tky
                        %msg = NEW /dmo/cm_flight_messages(
          textid                = /dmo/cm_flight_messages=>customer_unkown
*              attr1                 =
*              attr2                 =
*              attr3                 =
*              attr4                 =
*              previous              =
*              travel_id             =
*              booking_id            =
*              booking_supplement_id =
*              agency_id             =
          customer_id           = <ls_travel>-CustomerId
*              carrier_id            =
*              connection_id         =
*              supplement_id         =
*              begin_date            =
*              end_date              =
*              booking_date          =
*              flight_date           =
*              status                =
*              currency_code         =
          severity              = if_abap_behv_message=>severity-error
*              uname                 =
                                                                )
                      %element-CustomerID = if_abap_behv=>mk-on ) TO reported-travel.

      ENDIF.

    ENDLOOP.
  ENDMETHOD.

  METHOD ValidateBookingFee.
  ENDMETHOD.

  METHOD ValidateCurrencyCode.
  ENDMETHOD.

  METHOD ValidateDates.

    READ ENTITIES OF zms80_i_travel_m IN LOCAL MODE
    ENTITY Travel
    FIELDS ( BeginDate EndDate )
    WITH CORRESPONDING #( keys )
    RESULT DATA(travels).

    LOOP AT travels INTO DATA(ls_travel).

      IF ls_travel-EndDate < ls_travel-BeginDate.

        APPEND VALUE #( %tky = ls_travel-%tky ) TO failed-travel.

        APPEND VALUE #( %tky = ls_travel-%tky
                        %msg = NEW /dmo/cm_flight_messages(
          textid                = /dmo/cm_flight_messages=>begin_date_bef_end_date
*          attr1                 =
*          attr2                 =
*          attr3                 =
*          attr4                 =
*          previous              =
          travel_id             = ls_travel-TravelId
*          booking_id            =
*          booking_supplement_id =
*          agency_id             =
*          customer_id           =
*          carrier_id            =
*          connection_id         =
*          supplement_id         =
          begin_date            = ls_travel-BeginDate
          end_date              = ls_travel-EndDate
*          booking_date          =
*          flight_date           =
*          status                =
*          currency_code         =
          severity              = if_abap_behv_message=>severity-error
*          uname                 =
        )
        %element-BeginDate = if_abap_behv=>mk-on
        %element-EndDate = if_abap_behv=>mk-on
         ) TO reported-travel.

      ELSEIF ls_travel-BeginDate < cl_abap_context_info=>get_system_date( ).

        APPEND VALUE #( %tky = ls_travel-%tky ) TO failed-travel.

        APPEND VALUE #( %tky = ls_travel-%tky
                            %msg = NEW /dmo/cm_flight_messages(
              textid                = /dmo/cm_flight_messages=>begin_date_on_or_bef_sysdate
*          attr1                 =
*          attr2                 =
*          attr3                 =
*          attr4                 =
*          previous              =
*          travel_id             =
*          booking_id            =
*          booking_supplement_id =
*          agency_id             =
*          customer_id           =
*          carrier_id            =
*          connection_id         =
*          supplement_id         =
              begin_date            = ls_travel-BeginDate
              end_date              = ls_travel-EndDate
*          booking_date          =
*          flight_date           =
*          status                =
*          currency_code         =
              severity              = if_abap_behv_message=>severity-error
*          uname                 =
            )
            %element-BeginDate = if_abap_behv=>mk-on
            %element-EndDate = if_abap_behv=>mk-on
             ) TO reported-travel.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD ValidateStatus.

    READ ENTITIES OF zms80_i_travel_m IN LOCAL MODE
    ENTITY Travel
    FIELDS ( OverallStatus )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel).

    LOOP AT lt_travel INTO DATA(ls_travel).

      CASE ls_travel-OverallStatus.

        WHEN 'O'.
        WHEN 'A'.
        WHEN 'X'.

        WHEN OTHERS.

          APPEND VALUE #( %tky = ls_travel-%tky ) TO failed-travel.

          APPEND VALUE #( %tky = ls_travel-%tky
                              %msg = NEW /dmo/cm_flight_messages(
                textid                = /dmo/cm_flight_messages=>status_invalid
*          attr1                 =
*          attr2                 =
*          attr3                 =
*          attr4                 =
*          previous              =
*          travel_id             =
*          booking_id            =
*          booking_supplement_id =
*          agency_id             =
*          customer_id           =
*          carrier_id            =
*          connection_id         =
*          supplement_id         =
*          begin_date            =
*          end_date              =
*          booking_date          =
*          flight_date           =
            status                = ls_travel-OverallStatus
*          currency_code         =
                severity              = if_abap_behv_message=>severity-error
*          uname                 =
              )
              %element-OverallStatus = if_abap_behv=>mk-on
               ) TO reported-travel.

      ENDCASE.

    ENDLOOP.

  ENDMETHOD.

  METHOD calculateTotalPrice.


    MODIFY ENTITIES OF zms80_i_travel_m IN LOCAL MODE
    ENTITY Travel
    EXECUTE recalcTotPrice
    FROM CORRESPONDING #( keys ).

  ENDMETHOD.

ENDCLASS.
