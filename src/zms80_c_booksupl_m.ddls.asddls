@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Proj / Cons Booking Supplement'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZMS80_C_BOOKSUPL_M
  as projection on ZMS80_I_BOOKSUPL_M
{
  key TravelId,
  key BookingId,
  key BookingSupplementId,
      @ObjectModel.text.element: [ 'SupplementDesc' ]
      SupplementId,
      _SupplementText.Description as SupplementDesc : localized,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      Price,
      CurrencyCode,
      LastChangedAt,
      /* Associations */
      _Travel  : redirected to ZMS80_C_TRAVEL_M,
      _Booking : redirected to parent ZMS80_C_BOOKING_M,
      _Supplement,
      _SupplementText
}
