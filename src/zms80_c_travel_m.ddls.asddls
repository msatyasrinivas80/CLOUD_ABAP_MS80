@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection / Consumption Travel' 
@Metadata.ignorePropagatedAnnotations: true 
@Metadata.allowExtensions: true 
define root view entity ZMS80_C_TRAVEL_M 
 provider contract transactional_query 
 as projection on ZMS80_I_TRAVEL_M 
{ 
 
 key TravelId,
 @ObjectModel.text.element: [ 'AgencyName' ] 
 AgencyId,
 _Agency.Name as AgencyName,
 @ObjectModel.text.element: [ 'CustomerName' ] 
 CustomerId,
 _Customer.LastName as CustomerName,
 BeginDate,
 EndDate,
 @Semantics.amount.currencyCode: 'CurrencyCode' 
 BookingFee,
 @Semantics.amount.currencyCode: 'CurrencyCode' 
 TotalPrice,
 CurrencyCode,
 Description,
 @ObjectModel.text.element: [ 'OverallStatusText' ] 
 OverallStatus,
 _Status._Text.Text as OverallStatusText : localized,
 @Semantics.user.createdBy: true
 CreatedBy, 
 @Semantics.systemDateTime.createdAt: true
 CreatedAt, 
 @Semantics.user.lastChangedBy: true
 LastChangedBy, 
 @Semantics.systemDateTime.lastChangedAt: true
 LastChangedAt,
 /* Associations */ 
 _Agency,
 _booking : redirected to composition child ZMS80_C_BOOKING_M,
 _Currency,
 _Customer,
 _Status 
} 
