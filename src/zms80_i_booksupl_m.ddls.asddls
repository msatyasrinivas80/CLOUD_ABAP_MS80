@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED 
@EndUserText.label: 'Interface View - Booking Supplement' 
@Metadata.ignorePropagatedAnnotations: true 
@ObjectModel.usageType:{ 
 serviceQuality: #X, 
 sizeCategory: #S, 
 dataClass: #MIXED 
} 
define view entity ZMS80_I_BOOKSUPL_M 
 as select from zms80_booksupl_m 
 association to parent ZMS80_I_BOOKING_M as _Booking on $projection.TravelId = _Booking.TravelId 
 and $projection.BookingId = _Booking.BookingId 
 association [1..1] to ZMS80_I_TRAVEL_M as _Travel on $projection.TravelId = _Travel.TravelId 
 association [1..1] to /DMO/I_Supplement as _Supplement on $projection.SupplementId = _Supplement.SupplementID 
 association [1..*] to /DMO/I_SupplementText as _SupplementText on $projection.SupplementId = _SupplementText.SupplementID 
{ 
 key travel_id as TravelId,
 key booking_id as BookingId,
 key booking_supplement_id as BookingSupplementId,
 supplement_id as SupplementId,
 @Semantics.amount.currencyCode: 'CurrencyCode' 
 price as Price,
 currency_code as CurrencyCode,
 @Semantics.systemDateTime.lastChangedAt: true
 last_changed_at as LastChangedAt,
 //associations 
 _Travel,
 _Booking,
 _Supplement,
 _SupplementText 
}
