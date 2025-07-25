@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED 
@EndUserText.label: 'Interface View - Travel' 
@Metadata.ignorePropagatedAnnotations: true 
@ObjectModel.usageType:{ 
 serviceQuality: #X, 
 sizeCategory: #S, 
 dataClass: #MIXED 
} 
define root view entity ZMS80_I_TRAVEL_M 
 as select from zms80_travel_m 
 composition [0..*] of ZMS80_I_BOOKING_M as _booking 
 association [0..1] to /DMO/I_Agency as _Agency on $projection.AgencyId = _Agency.AgencyID 
 association [0..1] to /DMO/I_Customer as _Customer on $projection.CustomerId = _Customer.CustomerID 
 association [0..1] to I_Currency as _Currency on $projection.CurrencyCode = _Currency.Currency 
 association [0..1] to /DMO/I_Overall_Status_VH as _Status on $projection.OverallStatus = _Status.OverallStatus 
{ 
 key travel_id as TravelId,
 agency_id as AgencyId,
 customer_id as CustomerId,
 begin_date as BeginDate,
 end_date as EndDate,
 @Semantics.amount.currencyCode: 'CurrencyCode' 
 booking_fee as BookingFee,
 @Semantics.amount.currencyCode: 'CurrencyCode' 
 total_price as TotalPrice,
 currency_code as CurrencyCode,
 description as Description,
 overall_status as OverallStatus,
 created_by as CreatedBy,
 created_at as CreatedAt,
 @Semantics.user.lastChangedBy: true
 last_changed_by as LastChangedBy,
 @Semantics.systemDateTime.lastChangedAt: true
 last_changed_at as LastChangedAt,
 
 //associations 
 _Agency,
 _booking,
 _Customer,
 _Currency,
 _Status 
} 
