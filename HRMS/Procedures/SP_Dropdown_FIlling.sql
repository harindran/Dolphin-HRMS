-------Common Procedure to Fill the Dropdown in HRMS----------------------------------------------------------------------------------------
if exists(select 1 from sys.procedures where name='Innova_HRMS_EMPMASTER_COMBO_FILLING') Drop Procedure Innova_HRMS_EMPMASTER_COMBO_FILLING
Go

Create Procedure [dbo].[Innova_HRMS_EMPMASTER_COMBO_FILLING] (@objtype varchar(100))
as
Begin
select 'Position'[Type],Convert(varchar,POSID)[Code],isnull(Name,'')[Name] from OHPS where @objtype in ('OHEM','ODAS','OPAD','OPRC')
Union all
select 'Department'[Type],Convert(varchar,Code),isnull(Name,'') from OUDP where @objtype in ('OHEM','ODAS','OPAD','OPRC')
Union all
select 'Branch'[Type],Convert(varchar,Code),isnull(Name,'')from OUBR where @objtype in ('OHEM')
Union all
select 'SAPUser'[Type],Convert(varchar,USERID),isnull(U_Name,'') from OUSR where @objtype in ('OHEM')
Union all
Select 'SalesEmployee'[Type],Convert(varchar,Slpcode),isnull(Slpname,'') from OSLP where @objtype in ('OHEM')
Union all
Select 'status'[Type],Convert(varchar,statusID),isnull(Name,'') from OHST where @objtype in ('OHEM','OPRC')
--Union all
--Select 'status'[Type],Convert(varchar,'-1'),' All' from OHST where @objtype in ('OPRC')
Union all
Select 'TerminationReason'[Type],Convert(varchar,reasonID),isnull(Name,'') from OHTR where @objtype in ('OHEM')
Union all
Select 'Location'[Type],Convert(varchar,Code),isnull(Location,'') froM OLCT Where isnull(U_HR,'N')='Y' and @objtype in ('OHEM','ODAS')
Union all
Select 'Shift'[Type],Convert(varchar,code),isnull(Name,'') from [@SMHR_OSFT] where @objtype in ('OHEM')
Union all
Select 'Grade'[Type],Convert(varchar,Code),isnull(Name,'') from [@SMPR_OGRA] where @objtype in ('OHEM')
Union all
Select 'Country'[Type],Convert(varchar,Code),isnull(Name,'') froM OCRY Where isnull(U_HR,'N')='Y' and @objtype in ('OHEM')
Union all
Select 'Education'[Type],Convert(varchar,edType) ,isnull(Name,'') froM OHED where @objtype in ('OHEM')
Union all
Select 'State'[Type],Convert(varchar,-1),isnull('-1','') where @objtype in ('OHEM')
Union all
Select 'Bank'[Type],Convert(varchar,-1),isnull('-1','')  where @objtype in ('OHEM')
Union all
Select 'SubGrade1'[Type],Convert(varchar,-1),isnull('-1','') where @objtype in ('OHEM')
Union all
Select 'SubGrade2'[Type],Convert(varchar,-1),isnull('-1','') where @objtype in ('OHEM')
union all
select 'OTHERSCC'[Type],Prccode,PrcName from OPRC where active='Y' and getdate() between ValidFrom and isnull(validto,getdate()) and dimcode=5
union all
SELECT 'EmpType'[Type],FldValue ,Descr  FROM UFD1  WHERE TABLEID='@SMPR_OHEM' and FieldID in (select FieldID from cufd where tableid='@SMPR_OHEM' and AliasID='gropCode') and @objtype in ('OLSE','ACCT','ODAS')
union all
select 'Leave'[Type],Code,Name from [@SMPR_OLVE] where @objtype in ('ODAS')
union all 
Select 'Leave'[Type],'PS','Present' where @objtype in ('ODAS')
union all 
select Distinct (Case when U_Type in ('A','D') then 'SETTYPE' when U_type='S' then 'PAY' end)[Type],Code, Name from [@SMPR_OPYE] Where isnull(U_active,'N')='Y' and  @objtype in ('OLSE','ACCT')
union all
select 'PAYPERIOD' [Type],code,Name from OFPR where isnull(U_HR,'')='Y' and  @objtype in ('OPAD','OPRC')
union all
select 'Loan'[Type],Code,Name from [@SMPR_OLON] where @objtype in ('ACCT')
union all
Select 'PAYMODE' [Type],FldValue Code,Descr Name from UFD1 where tableid='@SMPR_OHEM' and FieldID=65 and @objtype in ('OPRC')
Order by Type,Name
   
End

--[Innova_HRMS_EMPMASTER_COMBO_FILLING] 'OHEM'
