@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Approval'
@UI: { headerInfo: { typeName: 'Booking',
                     typeNamePlural: 'Bookings..!',
                     title: { type: #STANDARD,
                              value: 'BookingId' } } }
@Search.searchable: true
define view entity ZMS80_C_BOOKING_APR_M
  as projection on ZMS80_I_BOOKING_M
{
      @UI.facet: [{ id: 'Booking',
        purpose: #STANDARD,
        position: 10,
        label: 'Booking'}]
      @Search.defaultSearchElement: true
  key TravelId,
      @UI: {lineItem: [{ position: 20, importance: #HIGH }],
            identification: [{ position: 20 }] }
      @Search.defaultSearchElement: true
  key BookingId,
      @UI: {lineItem: [{ position: 30, importance: #HIGH }],
            identification: [{ position: 30 }] }
      BookingDate,
      @UI: {lineItem: [{ position: 40, importance: #HIGH }],
         identification: [{ position: 40 }],
         selectionField: [{ position: 40 }] }
      @Search.defaultSearchElement: true
      @ObjectModel.text.element: [ 'CustomerName' ]
      CustomerId,
      _Customer.LastName as CustomerName,
      @UI: {lineItem: [{ position: 50, importance: #HIGH }],
         identification: [{ position: 50 }] }
      @ObjectModel.text.element: [ 'CarrierName' ]
      CarrierId,
      _Carrier.Name      as CarrierName,
      @UI: {lineItem: [{ position: 60, importance: #HIGH }],
         identification: [{ position: 60 }] }
      ConnectionId,
      @UI: {lineItem: [{ position: 70, importance: #HIGH }],
         identification: [{ position: 70 }] }
      FlightDate,
      @UI: {lineItem: [{ position: 80, importance: #HIGH }],
         identification: [{ position: 80 }] }
      @Semantics.amount.currencyCode: 'CurrencyCode'
      FlightPrice,
      CurrencyCode,
      @UI: {lineItem: [{ position: 90, importance: #HIGH, label: 'Status' }],
         identification: [{ position: 90, label: 'Status' }],
         textArrangement: #TEXT_ONLY }
      @ObjectModel.text.element: [ 'BookingStatusText' ]
      @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Booking_Status_VH', element: 'BookingStatus' } }]
      BookingStatus,
      _Status._Text.Text as BookingStatusText : localized,
      @UI.hidden: true
      LastChangedAt,
      /* Associations */
      _BookSupl, // : redirected to composition child ZMS80_C_BOOKSUPL_APR_M,
      _Carrier,
      _Connection,
      _Customer,
      _Status,
      _Travel   : redirected to parent ZMS80_C_TRAVEL_APR_M
}
