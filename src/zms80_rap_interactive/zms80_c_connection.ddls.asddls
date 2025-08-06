@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection / Consumption Flight'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMS80_C_Connection 
provider contract transactional_query 
as projection on ZMS80_I_CONNECTION
{
    key CarrierId,
    key ConnectionId,
    AirportFromId,
    AirportToId,
    DepartureTime,
    ArrivalTime,
    @Semantics.quantity.unitOfMeasure: 'DistanceUnit'
//      cast( distance as abap.dec(10,2) ) as Distance,
    Distance,
    DistanceUnit,
    /* Associations */
    _Carrier,
    _Flight
}
