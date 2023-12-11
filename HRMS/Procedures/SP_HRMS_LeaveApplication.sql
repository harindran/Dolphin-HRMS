-------Procedure for Leave Application Histroy Details--------------------------------------------------------------------
if exists(select 1 from sys.procedures where name='Innova_HRMS_LeaveApplicaiton_History') Drop Procedure Innova_HRMS_LeaveApplicaiton_History
Go
Create Procedure [dbo].[Innova_HRMS_LeaveApplicaiton_History](@empid varchar(100),@leavetype varchar(10),@Docetnry varchar(100))
as
begin
	if @Docetnry<>'-1'
	 Begin
		  select DocEntry,DocNum,convert(varchar,U_Docdate,103)[Posting date],(Case when Canceled='Y' then 'Cancelled' else (case when Status='C' then 'Close' when status='D' then 'Waiting for Approval' when status='O' then 'Open' Else Status end) end)[Status],
		  Convert(varchar,U_Fromdate,103)[From Date],convert(varchar,U_Todate,103)[To Date],Convert(numeric(30,2),U_NoDayLve)[Total days],Convert(Numeric(30,2),U_EliLvDay)[Eligible days],
		  Convert(numeric(30,2),U_BalLeave)[Balance days],(Case when U_HalfDay='Y' then 'Yes' else 'No' end)[HalfDay],isnull(U_rempid,'')[Replacement ID],isnull(U_RempName,'')[Replacement Name],
		  isnull(U_reason,'')[Reason] from [@SMPR_OLVA] Where U_empid=@empid and U_lvecode=@leavetype and DocEntry<@Docetnry 
		  Order by U_Fromdate desc
	 End
	Else
	 Begin
		  select T0.DocEntry,T0.DocNum,T1.Name [Leave Type],convert(varchar,T0.U_Docdate,103)[Posting date],(Case when T0.Canceled='Y' then 'Cancelled' else (case when Status='C' then 'Close' when status='D' then 'Waiting for Approval' when status='O' then 'Open' Else Status end) end)[Status],
		  Convert(varchar,T0.U_Fromdate,103)[From Date],convert(varchar,T0.U_Todate,103)[To Date],Convert(numeric(30,2),T0.U_NoDayLve)[Total days],Convert(Numeric(30,2),T0.U_EliLvDay)[Eligible days],
		  Convert(numeric(30,2),T0.U_BalLeave)[Balance days],(Case when T0.U_HalfDay='Y' then 'Yes' else 'No' end)[HalfDay],isnull(T0.U_rempid,'')[Replacement ID],isnull(T0.U_RempName,'')[Replacement Name],
		  isnull(T0.U_reason,'')[Reason],T0.U_IDNo+' - '+T0.U_empName [header],T0.Object [objtype] from [@SMPR_OLVA] T0 inner join [@SMPR_OLVE] T1 on T0.U_lvecode=T1.code Where U_empid=@empid
		Order by T1.Name,U_Fromdate desc
	 End
End
--Exec [Innova_HRMS_LeaveApplicaiton_History]'178','AL'
Go

-------Procedure for Leave Application Balance Leave Details--------------------------------------------------------------------
if exists(select 1 from sys.procedures where name='Innova_HRMS_LeaveApplication_Balance') Drop Procedure Innova_HRMS_LeaveApplication_Balance
Go
CREATE Procedure [dbo].[Innova_HRMS_LeaveApplication_Balance](@todate as date,@empid as varchar(100),@leavetype varchar(10))
as 
begin
	--Declare @todate as date,@EMPID as varchar(100),@leavetype as varchar(10)
	--select @EMPID=230,@ToDate='20180715',@leavetype='AL'
	Declare @Fromdate as date
	Declare @OB_Leave_Days numeric(30,3),@LeaveTaken numeric(30,3),@Lop_Leave numeric(30,3),@Total_Worked_Days numeric(30,3),@Totalleave_master numeric(30,3),@carryfwd_master numeric(30,3)
	Declare @leave_encashed numeric(30,3),@LeaveTaken_ForAccrual numeric(30,3)

	select @carryfwd_master=U_MxLveFwd,@Totalleave_master=U_TotalLve from [@SMPR_OLVE] where  code=@leavetype

	if @carryfwd_master=0 Begin Select @Fromdate=Convert(varchar,datepart(YYYY,@todate))+'0101',@OB_Leave_Days=0 End

	If @carryfwd_master<>0 
	Select @Fromdate=isnull(T1.U_DOJAfterLveDate,U_startdte),@OB_Leave_Days=isnull(T1.U_DOJAfterLveBal,0) from [@SMPR_OHEM] T0 inner join [@SMPR_HEM2] T1 on T0.code=T1.code 
	where T0.U_EMPid=@empid  and T1.U_LveCode=@leavetype  
 
	Select @leave_encashed=sum(isnull(U_lvncshdy,0)) From [@SMPR_OLSE] where isnull(Canceled,'N')<>'Y' and U_empid=@empid and U_lvncshdt>=@fromdate and @leavetype='AL' and isnull(U_approved,'')='Y'
	 --Select @Fromdate=(Case when U_LveSettDate> @Fromdate then  U_LveSettDate else @Fromdate end),@OB_Leave_Days=(Case when U_LveSettDate> @Fromdate then (U_EliSetDay-U_ApprDays) else @OB_Leave_Days end)
	 --From [@SMPR_OLSE] where isnull(Canceled,'N')<>'Y' and U_empid=@empid 

	Select @LeaveTaken=sum((Datediff(dd,(Case when U_fromdate<@fromdate then @fromdate else U_fromdate end),U_todate)+1)*(Case when U_Halfday='Y' then  0.5 else 1 end)),
	@LeaveTaken_ForAccrual=sum(Case when U_fromdate>'20171231' then 0 else ((Datediff(dd,U_Fromdate,(Case when U_Todate>'20171231' then '20171231' else U_Todate end))+1)*(Case when U_Halfday='Y' then  0.5 else 1 end)) end)
	 from [@SMPR_OLVA] Where Canceled='N' and U_Approved='Y'  and U_empid=@empid and U_LveCode=@leavetype and (@Fromdate<U_FromDate or @Fromdate<U_todate)

	 Select --@LeaveTaken=Sum(Case when T1.U_attstatus=@leavetype then (Case when T1.U_Halfday='Y' then  0.5 else 1 end) else 0 end),
	@Total_Worked_Days=Datediff(dd,@fromdate,@todate)+1,@Lop_Leave=Sum(Case when T1.U_attstatus='LP' then (Case when T1.U_Halfday='Y' then  0.5 else 1 end) else 0 end)
	from [@SMPR_ODAS] T0 inner join [@SMPR_DAS1] T1 on T0.DocEntry=T1.DocEntry where isnull(T0.Canceled,'N')<>'Y' and T1.U_empID=@EMPID and T0.U_AttdDate between @fromdate and @todate

	Select @empid[Empid],@fromdate[FromDate],@todate[ToDate],isnull(@OB_Leave_Days,0)[Leave_OB],isnull(@LeaveTaken,0)[Leave_Taken],isnull(@leave_encashed,0)[Leave_Encashed],isnull(@Lop_Leave,0) [Leave_LOP],
	isnull(@Total_Worked_Days,0)[TotalDays],isnull(@Total_Worked_Days,0)-isnull(@Lop_Leave,0)[Worked Days],isnull(@LeaveTaken_ForAccrual,0)[LeaveTaken_ForApproval],
	(Case when @carryfwd_master=0 then @totalLeave_master else ((isnull(@Total_Worked_Days,0)-isnull(@LeaveTaken_ForAccrual,0)-isnull(@Lop_Leave,0))*isnull(@Totalleave_master,0)/365)end)[Accured_Days],
	Round(isnull(@OB_Leave_Days,0)+(Case when @carryfwd_master=0 then @totalLeave_master else ((isnull(@Total_Worked_Days,0)-isnull(@LeaveTaken_ForAccrual,0)-isnull(@Lop_Leave,0))*isnull(@Totalleave_master,0)/365)end)
	-isnull(@LeaveTaken,0)-isnull(@leave_encashed,0),2)[Available_Leave]

End

--[Innova_HRMS_LeaveApplication_Balance] '20180724','178','SL'