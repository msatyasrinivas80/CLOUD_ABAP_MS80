@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View - Flight Data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZMS80_I_FLIGHT_R
  as select from /dmo/flight
  association [1..1] to ZMS80_I_CARRIER_R as _Carrier on $projection.CarrierId = _Carrier.CarrierId
{
      @UI.lineItem: [{ position: 10 }]
      @ObjectModel.text.association: '_Carrier'
  key carrier_id     as CarrierId,
      @UI.lineItem: [{ position: 20 }]
  key connection_id  as ConnectionId,
      @UI.lineItem: [{ position: 30 }]
  key flight_date    as FlightDate,
      @UI.lineItem: [{ position: 40 }]
      @Semantics.amount.currencyCode: 'CurrencyCode'
      price          as Price,
      @UI.lineItem: [{ position: 50 }]
      currency_code  as CurrencyCode,
      @UI.lineItem: [{ position: 60 }]
      @Search.defaultSearchElement: true
      plane_type_id  as PlaneTypeId,
      @UI.lineItem: [{ position: 70 }]
      seats_max      as SeatsMax,
      @UI.lineItem: [{ position: 80 }]
      seats_occupied as SeatsOccupied,

      _Carrier
}
