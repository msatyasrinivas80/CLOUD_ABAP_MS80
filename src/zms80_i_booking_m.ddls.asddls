@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED 
@EndUserText.label: 'Interface View - Booking' 
@Metadata.ignorePropagatedAnnotations: true 
@ObjectModel.usageType:{ 
 serviceQuality: #X, 
 sizeCategory: #S, 
 dataClass: #MIXED 
} 
define view entity ZMS80_I_BOOKING_M 
 as select from zms80_booking_m 
 association to parent ZMS80_I_TRAVEL_M as _Travel on $projection.TravelId = _Travel.TravelId
 composition [0..*] of ZMS80_I_BOOKSUPL_M as _BookSupl
 association [1..1] to /DMO/I_Carrier as _Carrier on $projection.CarrierId = _Carrier.AirlineID 
 association [1..1] to /DMO/I_Customer as _Customer on $projection.CustomerId = _Customer.CustomerID 
 association [1..1] to /DMO/I_Connection as _Connection on $projection.CarrierId = _Connection.AirlineID 
 and $projection.ConnectionId = _Connection.ConnectionID 
 association [1..1] to /DMO/I_Booking_Status_VH as _Status on $projection.BookingStatus = _Status.BookingStatus 
{ 
 key travel_id as TravelId,
 key booking_id as BookingId,
 booking_date as BookingDate,
 customer_id as CustomerId,
 carrier_id as CarrierId,
 connection_id as ConnectionId,
 flight_date as FlightDate,
 @Semantics.amount.currencyCode: 'CurrencyCode' 
 flight_price as FlightPrice,
 currency_code as CurrencyCode,
 booking_status as BookingStatus,
 @Semantics.systemDateTime.lastChangedAt: true
 last_changed_at as LastChangedAt,
 //Association 
 _BookSupl,
 _Carrier,
 _Travel,
 _Customer,
 _Connection,
 _Status 
} 
