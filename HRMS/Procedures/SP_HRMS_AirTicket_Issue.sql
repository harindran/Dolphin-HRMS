-------Procedure for AirticketIssue--------------------------------------------------------------------
if exists(select 1 from sys.procedures where name='Innova_HR_GetEmpDetails_AirticketIssue') Drop Procedure Innova_HR_GetEmpDetails_AirticketIssue
Go

Create Procedure [dbo].[Innova_HR_GetEmpDetails_AirticketIssue](@trzid as varchar(100),@issuedate varchar(100))--,@amount numeric(30,2),@calculate varchar(10))
as
Begin
	Declare @lastclaimdate as date,@lastclaimamt as numeric(30,6),@lopdays as integer
  
	Select @lastclaimdate=isnull(T1.U_TickDate,isnull(T0.U_airlstdt,T0.U_startdte)),@lastclaimamt =U_total from [@SMPR_OHEM] T0 left join [@SMPR_OTIS] T1 on T0.U_empid=T1.U_empID
	and T1.Docentry=(select max(docentry)docentry from [@SMPR_OTIS]  where U_IDNo=@trzid and Canceled<>'Y') where T0.U_ExtEmpNo=@trzid
 
	set @lopdays=(Select count(1) from [@SMPR_ODAS] T0 inner join [@SMPR_DAS1] T1 on T0.DocEntry=T1.DocEntry where T0.U_AttdDate between @lastclaimdate and @issuedate and T1.U_IDNo=@trzid and isnull(T1.U_AttStatus,'')='LP')

	select U_empid,U_firstNam +' '+U_lastName [Name],T1.Name [Department],T2.name [Designation],T5.Descr [Emptype],T6.name[Country],Replace(convert(varchar,T0.U_startdte,103),'/','.') [JoiningDate],
	Replace(convert(varchar,@lastclaimdate,103),'/','.')[Lastdate],convert(numeric(30,2),isnull(@lastclaimamt,0))[Lastclaimamt],isnull(T4.U_eligiamt,0) [Eligibleamt],
	isnull(T4.U_tcktpryr,0) [TcktPeryear],Datediff(dd,@lastclaimdate,@issuedate)[TotalDays],@lopdays [LOPDays],Datediff(dd,@lastclaimdate,@issuedate)-@lopdays[noofday],
	Round((isnull(T4.U_eligiamt,0)/(365*isnull(T4.U_tcktpryr,1)))*(Datediff(dd,@lastclaimdate,@issuedate)-(Case when @lopdays<15 then 0 else @Lopdays end)),2) [TicketAmount],
	Replace(Convert(varchar,@issuedate,103),'/','.')[IssueDate],isnull(T4.U_nooftckt,0) nooftckt
	from [@SMPR_OHEM] T0 inner join OUDP T1 on T0.U_dept=T1.code inner join OHPS T2 on T2.posID=T0.U_position  
	left join [@SMPR_HEM10] T4 on T4.code=T0.code and @issuedate between T4.U_fromdate and isnull(T4.U_Todate,@issuedate)
	left join (select FldValue,Descr  from UFD1  WHERE TableID='@smpr_ohem' and FieldID in (select FieldID  from CUFD  WHERE TableID='@smpr_ohem' and AliasID='gropCode'))T5 on T5.FldValue=T0.U_gropCode
	left join OCRY T6 on T6.code=T0.U_ncountry
	Where U_ExtEmpNo =@trzid 

End

--[Innova_HR_GetEmpDetails_AirticketIssue] 'TRZ114','20181011'


Go
-------Leave/FInal Settlement EMployee Details FIlling--------------------------------------------------------------------
if exists(select 1 from sys.procedures where name='Innova_HR_Airticket_History') Drop Procedure Innova_HR_Airticket_History
Go
Create Procedure [dbo].[Innova_HR_Airticket_History](@empid as varchar(100),@HistoryTYpe as varchar(100))
as
Begin
	if @HistoryTYpe='OITS'
	Begin
		select T0.DocEntry,T0.DocNum,T0.object objtype,U_IDNo[Empid],U_empname[Employee Name],U_TickDate [Ticket Issued Date],
		U_noofday [Claim Days],U_Total[Claimed Amount],T0.U_nooftckt [Eligible No of Ticket],U_tcktpryr[Eligible Ticket Per Year],U_eligiamt [Eligible Amount] 
		from [@SMPR_OTIS] T0  Where T0.U_empid=@empid
	End
	If @HistoryTYpe='OHEM'
	Begin
		Select T0.U_ExtEmpNo [Empid],U_firstNam +' '+U_lastName [Employee Name],T1.U_fromdate [FromDate],T1.U_todate [ToDate],
		T1.U_nooftckt [Eligible No of Ticket],T1.U_tcktpryr [Eligible Ticket By Year],T1.U_eligiamt [Eligible Amount] ,'OHEM' objtype
		from [@SMPR_OHEM] T0 left join [@SMPR_HEM10] T1 on T0.code=T1.code Where T0.U_empid=@empid 
	End

End

--EXEC [Innova_HR_Airticket_History] '97','OHEM'""""
