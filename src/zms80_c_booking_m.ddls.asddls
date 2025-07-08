@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection / Consumption Booking'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZMS80_C_BOOKING_M
  as projection on ZMS80_I_BOOKING_M
{
  key TravelId,
  key BookingId,
      BookingDate,
      @ObjectModel.text.element: [ 'CustomerName' ]
      CustomerId,
      _Customer.LastName as CustomerName,
      @ObjectModel.text.element: [ 'CarrierName' ]
      CarrierId,
      _Carrier.Name      as CarrierName,
      ConnectionId,
      FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      FlightPrice,
      CurrencyCode,
      @ObjectModel.text.element: [ 'BookingStatusText' ]
      BookingStatus,
      _Status._Text.Text as BookingStatusText : localized,
      LastChangedAt,
      /* Associations */
      _BookSupl : redirected to composition child ZMS80_C_BOOKSUPL_M,
      _Carrier,
      _Connection,
      _Customer,
      _Status,
      _Travel   : redirected to parent ZMS80_C_TRAVEL_M
}
