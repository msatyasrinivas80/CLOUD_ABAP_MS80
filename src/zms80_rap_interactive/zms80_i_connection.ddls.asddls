@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View Connection'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@UI.headerInfo: { typeName: 'Connection', typeNamePlural: 'Connections..!' }
@Search.searchable: true
@Metadata.allowExtensions: true
define root view entity ZMS80_I_CONNECTION
  as select from /dmo/connection
  association [1..*] to ZMS80_I_FLIGHT_R  as _Flight  on  $projection.CarrierId    = _Flight.CarrierId
                                                      and $projection.ConnectionId = _Flight.ConnectionId
  association [1..1] to ZMS80_I_CARRIER_R as _Carrier on  $projection.CarrierId = _Carrier.CarrierId
{

      @UI.facet: [{ purpose: #STANDARD,
      type: #IDENTIFICATION_REFERENCE,
      position: 10,
      label: 'Connection',
      id: 'Connection' },
      { purpose: #STANDARD,
      type: #LINEITEM_REFERENCE,
      position: 20,
      label: 'Flight',
      id: 'Flight',
      targetElement: '_Flight' }]

      @UI.lineItem: [{ position: 1, label: 'Airline' }]
      @UI.identification: [{ position: 31, label: 'Airline' }]
      @ObjectModel.text.association: '_Carrier'
      @Search.defaultSearchElement: true
      @EndUserText.quickInfo: 'Airline ID Details'
  key carrier_id      as CarrierId,
      @UI.lineItem: [{ position: 2 }]
      @UI.identification: [{ position: 32 }]
      @Search.defaultSearchElement: true
      @EndUserText.quickInfo: 'Connection ID Details'
  key connection_id   as ConnectionId,
      @UI.lineItem: [{ position: 3 }]
      @UI.selectionField: [{position: 10}]
      @UI.identification: [{ position: 33 }]
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZMS80_I_AIRPORT', element: 'AirportId' } }]
      @ObjectModel.text.association: '_Carrier'
      airport_from_id as AirportFromId,
      @UI.selectionField: [{position: 20}]
      @UI.lineItem: [{ position: 4 }]
      @UI.identification: [{ position: 34 }]
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZMS80_I_AIRPORT', element: 'AirportId' } }]
      @ObjectModel.text.association: '_Carrier'
      @EndUserText.label: 'Destinatin Airport ID'
      airport_to_id   as AirportToId,
      @UI.lineItem: [{ position: 5, label: 'Departure Time' }]
      @UI.identification: [{ position: 35 }]
      departure_time  as DepartureTime,
      @UI.lineItem: [{ position: 6, label: 'Arrival Time' }]
      @UI.identification: [{ position: 36 }]
      arrival_time    as ArrivalTime,
      @Semantics.quantity.unitOfMeasure: 'DistanceUnit'
      cast( distance as abap.dec(10,2) ) as Distance,
//      distance        as Distance,
      distance_unit   as DistanceUnit,
      @Search.defaultSearchElement: true
      _Flight,
      @Search.defaultSearchElement: true
      _Carrier
}
