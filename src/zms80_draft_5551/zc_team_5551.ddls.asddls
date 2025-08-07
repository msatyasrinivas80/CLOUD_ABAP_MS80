@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for UX Team'
@Search.searchable: true
@Metadata.allowExtensions: true
define root view entity ZC_TEAM_5551
  as projection on ZI_TEAM_5551 as Team
{
      @EndUserText.label: 'First Name'
      @Search.defaultSearchElement: true
  key Firstname,
      @EndUserText.label: 'Last Name'
      @Search.defaultSearchElement: true
      Lastname,
      @EndUserText.label: 'Age'
      Age,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Role'
      Role,
      @EndUserText.label: 'Salary'
      Salary,
      @EndUserText.label: 'Active'
      Active,
      CreatedBy,
      LastChangedAt,
      LocalLastChangedAt
}
