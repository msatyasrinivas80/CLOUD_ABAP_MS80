@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'F4 Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZMS80_I_AIRPORT
  as select from /dmo/airport
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
  key airport_id as AirportId,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      name       as Name,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      city       as City,
      @Search.defaultSearchElement: true
      country    as Country
}
