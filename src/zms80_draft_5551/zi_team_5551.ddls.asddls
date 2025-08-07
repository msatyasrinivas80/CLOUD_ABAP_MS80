@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for UX demo'
@Metadata.allowExtensions: true
define root view entity ZI_TEAM_5551
  as select from zrap_team_5551
{
  key firstname          as Firstname,
      lastname           as Lastname,
      age                as Age,
      role               as Role,
      salary             as Salary,
      active             as Active,
      @Semantics.user.lastChangedBy: true
      createdby      as CreatedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      lastchangedat      as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      locallastchangedat as LocalLastChangedAt
}
