-------Procedure for Leave/FInal Settlement--------------------------------------------------------------------
-------Leave/FInal Settlement EMployee Details FIlling--------------------------------------------------------------------
if exists(select 1 from sys.procedures where name='Innova_HRMS_GetEmpDetails_Settlement') Drop Procedure Innova_HRMS_GetEmpDetails_Settlement
Go
CREATE Procedure [dbo].[Innova_HRMS_GetEmpDetails_Settlement](@trzid as varchar(100))
as
Begin
	 select U_empid,U_firstNam +' '+U_lastName [Name],T1.Name [Department],T2.name [Designation],T0.U_gropCode [Emptype],T3.name[Country],
	 Replace(convert(varchar,T0.U_startdte,103),'/','.') [JoiningDate],isnull(Replace(convert(varchar,T0.U_termdate,103),'/','.'),'') [termDate],
	 Replace(isnull((select convert(varchar,Max(U_LveSettDate),103) DocEntry from [@SMPR_OLSE] where U_empID=T0.u_empid and Canceled<>'Y'),''),'/','.') [Leavesettleddate],
	 isnull((select Max(DocEntry)DocEntry from [@SMPR_OLVA] where U_empID=T0.u_empid and isnull(U_Approved,'')='Y' and Canceled<>'Y' and isnull(status,'')='O' and isnull(U_Payable,'N')<>'Y' and U_lvecode='AL'),0)[LeaveAppentry],
	 isnulL((Select Max(DocEntry)DocEntry from [@SMPR_OTIS] where U_empID=T0.U_empid and isnull(U_approved,'')='Y' and Canceled<>'Y' and isnull(status,'')='O'  and isnull(U_payroll,'N')<>'Y'),0)[Airticket],
	 (T4.LvstSalary*12/365)[PerDaySalary_lvst],T4.LvstSalary [Salary_lvst],Salary[Salary_month],isnull(T0.U_paymode,'')[Paymode],isnull(T0.U_bankacct,'')[BankAcct],isnull(T0.U_bankiban,'')[Bankiban]
	 from [@SMPR_OHEM] T0 inner join OUDP T1 on T0.U_dept=T1.code inner join OHPS T2 on T2.posID=T0.U_position  left join OCRY T3 on T3.code=T0.U_ncountry 
	 left join (select Code,sum(Case when isnull(U_LveSettlement,'N')='Y' then U_amount else 0 end)[LvstSalary],sum(U_amount)[Salary] from [@SMPR_HEM1] Group by Code) T4 on T4.code=T0.code
	 Where U_ExtEmpNo =@trzid 
End

--[Innova_HRMS_GetEmpDetails_Settlement] 'TRZ257'
Go

-------Leave/FInal Settlement Gratuity Calculation--------------------------------------------------------------------
if exists(select 1 from sys.procedures where name='Innnova_HRMS_Grauity_Settlement') Drop Procedure Innnova_HRMS_Grauity_Settlement
Go
Create Procedure [dbo].[Innnova_HRMS_Grauity_Settlement](@asondate datetime,@empid as varchar(10))
as 
Begin
	--Declare @asondate as datetime
	--Declare @empid as varchar(10)
	--set @asondate='20180717'
	--set @empid=230

	Declare @Workingdays as numeric(30,6)
	Declare @lopdays as numeric(30,6)
	Declare @year as numeric(30,6)
	Declare @basic as numeric(30,6)

	set @Workingdays=isnull((Select ISNULL(DATEDIFF(DAY,U_startdte,CONVERT(DATETIME,isnull(U_termdate,@asondate),112)),0) from [@SMPR_OHEM] where U_empID=@empid),0)
	set @lopdays=isnull((Select count(1) from [@SMPR_ODAS] T0 inner join [@SMPR_DAS1] T1 on T0.DocEntry=T1.DocEntry Where T0.U_AttdDate <=@asondate and T1.U_empid=@empid and T1.U_AttStatus='LP'),0)
	Set @year =Round((cast(@Workingdays-@lopdays as float)/cast(30.4167 as float)/cast(12 as float)),6)

	Set @basic=(cast(isnull((select Sum(U_Amount) from [@SMPR_OHEM] T0 inner join [@SMPR_HEM1] T1 on T0.code=T1.code where T0.U_empid=@empid and isnull(T1.U_FandF,'')='Y'),0) as float)* Cast(12 as float))/cast(365 as float)
	--Select @Workingdays,@year ,@basic 

	;with GradutiyDetails as (Select case when @year  < 5 then Convert(int,@year) else 5 end 'Grad @21 (Years)',case when @year  < 5 then (@year  - Convert(int,@year )) else 0 end 'Grad @21 (Days)',
	case when @year > 5 then Convert(int,@year )- 5 else 0 end 'Grad @30 (Years)',case when @year  > 5 then (@year  - Convert(int,@year ))  else 0 end 'Grad @30 (Days)')

	Select @Workingdays [Totaldays],@lopdays [LOP],@Workingdays-@lopdays [Working Days],@year [Year],@basic [basic],21*([Grad @21 (Years)] + [Grad @21 (Days)])+30* ([Grad @30 (Years)] + [Grad @30 (Days)])[Gratuity Days],
	Round(isnull((@basic*21*([Grad @21 (Years)] + [Grad @21 (Days)]))+ (@basic*30* ([Grad @30 (Years)] + [Grad @30 (Days)])),0),6) 'Gratuity Amount'
	from GradutiyDetails Where @year>1

End
--[Innnova_HRMS_Grauity_Settlement] '20190331','274'

Go
-------Leave/FInal Settlement History Details--------------------------------------------------------------------
if exists(select 1 from sys.procedures where name='Innova_HRMS_Settlement_History') Drop Procedure Innova_HRMS_Settlement_History
Go
Create Procedure [dbo].[Innova_HRMS_Settlement_History](@empid as varchar(100))
as
Begin
	select T0.DocEntry,T0.DocNum,T0.object objtype,U_IDNo[Empid],U_empname[Employee Name],T0.U_DocDate [Settlement Date],(Case when T0.U_setltype='LS' then 'Leave Settlement' Else 'Final Settlement' end)[Settlement Type],
	(Case when T0.Canceled='Y' then 'Cancelled' Else (Case when T0.status='O' then 'Open' when T0.Status='C' then 'Close' when T0.Status='D' then 'Waiting for Approval' else T0.Status end)end)[Status],
	isnull(U_totalamt,0)[Total Payable],isnull(U_lvsalamt,0)[Leave Salary Amt],isnull(U_lvncshmt,0)[Leave Encashed Amt],isnull(U_AiTiketAmt,0)[AirTicket Amt],isnull(U_advsalry,0)[Advance Salary Amt],
	isnull(U_retention,0)[Loan Deduction],isnull(U_addedamt,0)[Addition/Deduction],isnull(U_gratuity,0)[Gratutity]
	from [@SMPR_OLSE] T0  Where T0.U_empid=@empid
End

--EXEC [Innova_HR_Airticket_History] '97','OHEM'""""