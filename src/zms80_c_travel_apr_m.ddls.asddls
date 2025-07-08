@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel Approval'
@UI: { headerInfo: { typeName: 'Travel',
                     typeNamePlural: 'Travels',
                     title: { type: #STANDARD,
                              value: 'TravelID' } } }
@Search.searchable: true
define root view entity ZMS80_C_TRAVEL_APR_M
  provider contract transactional_query
  as projection on ZMS80_I_TRAVEL_M
{
      @UI.facet: [{ id: 'Travel',
      purpose: #STANDARD,
      position: 10,
      label: 'Travel_M',
      type: #IDENTIFICATION_REFERENCE },

      { id: 'Booking',
      purpose: #STANDARD,
      position: 20,
      label: 'Booking_M',
      type: #LINEITEM_REFERENCE,
      targetElement: '_booking' }]

      @UI: { lineItem: [{ position: 10, importance: #HIGH }],
             identification: [{ position: 10 }] }
      @Search.defaultSearchElement: true
  key TravelId,
      @UI: { lineItem: [{ position: 20, importance: #HIGH }],
             identification: [{ position: 20 }],
             selectionField: [{ position: 20 }] }
      @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Agency', element: 'AgencyID' } }]
      @ObjectModel.text.element: [ 'AgencyName' ]
      AgencyId,
      _Agency.Name       as AgencyName,
      @UI: { lineItem: [{ position: 30, importance: #HIGH }],
             identification: [{ position: 30 }],
             selectionField: [{ position: 30 }] }
      @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Customer', element: 'CustomerID' } }]
      @ObjectModel.text.element: [ 'CustomerName' ]
      @Search.defaultSearchElement: true
      CustomerId,
      _Customer.LastName as CustomerName,
      @UI: { lineItem: [{ position: 40 }],
             identification: [{ position: 40 }] }
      BeginDate,
      @UI: { lineItem: [{ position: 50 }],
             identification: [{ position: 50 }] }
      EndDate,
      @UI: { lineItem: [{ position: 60, importance: #HIGH }],
             identification: [{ position: 60 }] }
      @Semantics.amount.currencyCode: 'CurrencyCode'
      BookingFee,
      @UI: { lineItem: [{ position: 70, importance: #HIGH }],
             identification: [{ position: 70, label: 'TotalPrice' }] }
      @Semantics.amount.currencyCode: 'CurrencyCode'
      TotalPrice,
      CurrencyCode,
      @UI: { lineItem: [{ position: 80, importance: #HIGH }],
             identification: [{ position: 80 }] }
      Description,
      @UI: { lineItem: [{ position: 90, importance: #HIGH },
                        { type: #FOR_ACTION, dataAction: 'acceptTravel', label: 'Accept Travel' },
                        { type: #FOR_ACTION, dataAction: 'rejectTravel', label: 'Reject Travel' }],
            identification: [{ position: 90 },
                        { type: #FOR_ACTION, dataAction: 'acceptTravel', label: 'Accept Travel' },
                        { type: #FOR_ACTION, dataAction: 'rejectTravel', label: 'Reject Travel' }],
            selectionField: [{ position: 90 }],
            textArrangement: #TEXT_ONLY } //No short cut code }

      @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Overall_Status_VH', element: 'OverallStatus' } }]

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
      _booking : redirected to composition child ZMS80_C_BOOKING_APR_M,
      _Currency,
      _Customer,
      _Status
}
