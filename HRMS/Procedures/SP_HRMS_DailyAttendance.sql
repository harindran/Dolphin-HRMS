-------Procedure for Daily Attendance--------------------------------------------------------------------
if exists(select 1 from sys.procedures where name='Innova_SP_ODAS_FillEmployee') Drop Procedure Innova_SP_ODAS_FillEmployee
Go
CREATE Procedure [dbo].[Innova_SP_ODAS_FillEmployee](@empid varchar(max),@attndate as datetime,@Location varchar(100),@empgroup varchar(100))
as
Begin
	Declare @attstatus as varchar(2)
	Select @attstatus=(Case when datename(dw,@attndate) in ('Friday') then 'WO' else 'PS' end)
	if exists (select * from HLD1 where @attndate between strdate and enddate) set @attstatus='PH'

	if @empid<>'-1'
	Begin
		 Select T0.U_empID,T0.U_ExtEmpNo,T0.U_firstNam+' ' + T0.U_lastName [Name],isnull(T0.U_position,'')[Desig],isnull(T0.U_dept,'')[Dept],T0.U_shiftcde[scode],T1.Name [Sname],
		 T1.U_FromTime[sfrom],T1.U_Totime[sto],(case when T1.U_Include='Y' then T1.U_ShiftHrs+T1.U_LunchHrs else T1.U_ShiftHrs end)[shrs],isnull(T2.U_lvecode,@attstatus) [Attn],
		 Isnull(T0.U_OT,'N') otappl,isnull(T2.U_halfday,'N') [halfday],(Case when @attstatus='WO' then 'Y' else 'N' end ) [Weekoff],(Case when @attstatus='PH' then 'Y' else 'N' end) [PH]
		 from [@SMPR_OHEM] T0 left join [@SMHR_OSFT] T1 on T0.U_shiftcde=T1.Code
		 inner join (select rowno,splitdata from [fnSplitString](RIght(@empid,len(@empid)-1),'#')) S on S.splitdata=T0.U_ExtEmpNo
		 left join (select U_empID,U_lvecode,isnull(U_halfday,'N')U_halfday from [@SMPR_OLVA] Where @attndate between U_FromDate and U_Todate and Canceled='N' and isnull(U_Approved,'')='Y') T2 on T2.U_empID=T0.U_empID 
		 where  @empid like '%#'+U_ExtEmpNo+'#%' and T0.U_status=1 order by S.Rowno
	End
	Else
	Begin 
		 Select T0.U_empID,T0.U_ExtEmpNo,T0.U_firstNam+' ' + T0.U_lastName [Name],isnull(T0.U_position,'')[Desig],isnull(T0.U_dept,'')[Dept],T0.U_shiftcde[scode],T1.Name [Sname],
		 T1.U_FromTime[sfrom],T1.U_Totime[sto],(case when T1.U_Include='Y' then T1.U_ShiftHrs+T1.U_LunchHrs else T1.U_ShiftHrs end)[shrs],isnull(T2.U_lvecode,@attstatus)[Attn],
		 Isnull(T0.U_OT,'N') otappl,isnull(T2.U_halfday,'N') [halfday],(Case when @attstatus='WO' then 'Y' else 'N' end ) [Weekoff],(Case when @attstatus='PH' then 'Y' else 'N' end) [PH]
		 from [@SMPR_OHEM] T0 left join [@SMHR_OSFT] T1 on T0.U_shiftcde=T1.Code 
		 left join (select U_empID,U_lvecode,isnull(U_halfday,'N')U_halfday from [@SMPR_OLVA] Where @attndate between U_FromDate and U_Todate and Canceled='N' and isnull(U_Approved,'')='Y') T2 on T2.U_empID=T0.U_empID 
		 where (T0.U_location=@location or @Location='') and (T0.U_gropCode=@empgroup or @empgroup='') and T0.U_status=1 --and (T0.U_gropCode=@emptype or @emptype='' )
	End
End


----[Innova_SP_ODAS_FillEmployee] '-1','20180601','',''
-- Exec [Innova_SP_ODAS_FillEmployee] '-1','20180706' ,'4' ,''

--Exec [Innova_SP_ODAS_FillEmployee] '-1','20180707' ,'' ,'GS'