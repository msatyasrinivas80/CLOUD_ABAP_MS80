@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection / Consumption Booking'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZMS80_C_BOOKING_U
  as projection on ZMS80_I_BOOKING_U
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
      /* Associations */
      _Carrier,
      _Connection,
      _Customer,
      _Travel   : redirected to parent ZMS80_C_TRAVEL_U
}
