CLASS lhc_Team DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Team RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Team RESULT result.

    METHODS setActive FOR MODIFY
      IMPORTING keys FOR ACTION Team~setActive RESULT result.

    METHODS changeSalary FOR DETERMINE ON SAVE
      IMPORTING keys FOR Team~changeSalary.

    METHODS validateAge FOR VALIDATE ON SAVE
      IMPORTING keys FOR Team~validateAge.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Team RESULT result.

ENDCLASS.

CLASS lhc_Team IMPLEMENTATION.

  METHOD get_instance_features.

    "Read the active flag of the existing members
    READ ENTITIES OF zi_team_5551 IN LOCAL MODE
    ENTITY Team
    FIELDS ( Active ) WITH CORRESPONDING #(  keys )
    RESULT DATA(members)
    FAILED failed.

    result = VALUE #( FOR member IN members
              LET status = COND #( WHEN member-Active = abap_true
                                   THEN if_abap_behv=>fc-o-disabled
                                   ELSE if_abap_behv=>fc-o-enabled  )
                                   IN
             ( %tky                = member-%tky
               %action-setActive   = status ) ).

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_keys>).

    ENDLOOP.

*    MODIFY ENTITIES OF zi_team_5551 IN LOCAL MODE
*    ENTITY Team
*    EXECUTE Edit FROM VALUE #( ( %key-Id = '6AB9A638E48F1FD09CB27B1D50005BC1'
*                                 %param-preserve_changes = 'X' ) )
*    REPORTED DATA(lt_reproted)
*    FAILED DATA(lt_failed)
*    MAPPED DATA(lt_mapped).

  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD setActive.

    " Do background check
    " Check references
    " Onboard member
    MODIFY ENTITIES OF zi_team_5551 IN LOCAL MODE
    ENTITY Team
    UPDATE FIELDS ( Active ) WITH VALUE #( FOR key IN keys
                                              ( %tky = key-%tky
                                                Active = abap_true ) )
      FAILED failed
      REPORTED reported.
    " Fill the response table
    READ ENTITIES OF zi_team_5551 IN LOCAL MODE
    ENTITY Team ALL FIELDS WITH CORRESPONDING #(  keys )
    RESULT DATA(members).

    result = VALUE #( FOR member IN members
                         ( %tky = member-%tky
                           %param = member ) ).

  ENDMETHOD.

  METHOD changeSalary.

    READ ENTITIES OF zi_team_5551 IN LOCAL MODE
      ENTITY Team
      FIELDS ( Role ) WITH CORRESPONDING #( keys )
      RESULT DATA(members).

    LOOP AT members INTO DATA(member).

      IF  member-Role = 'Developer'.
        MODIFY ENTITIES OF zi_team_5551 IN LOCAL MODE
        ENTITY Team
        UPDATE FIELDS ( Salary ) WITH VALUE #( ( %tky = member-%tky
                                                 Salary = 7000 ) ).
      ENDIF.
      IF  member-Role = 'Lead'.
        MODIFY ENTITIES OF zi_team_5551 IN LOCAL MODE
        ENTITY Team
        UPDATE FIELDS ( Salary ) WITH VALUE #( ( %tky = member-%tky
                                                 Salary = 9000 ) ).
      ENDIF.
    ENDLOOP.


  ENDMETHOD.

  METHOD validateAge.

    READ ENTITIES OF zi_team_5551 IN LOCAL MODE
      ENTITY Team
      FIELDS ( Age ) WITH CORRESPONDING #( keys )
      RESULT DATA(members).

    LOOP AT members INTO DATA(member).
      IF  member-age < 21.
        APPEND VALUE #( %tky = member-%tky ) TO failed-team.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

ENDCLASS.
