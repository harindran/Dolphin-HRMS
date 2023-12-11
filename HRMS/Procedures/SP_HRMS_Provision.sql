-------Table Creation for Provision--------------------------------------------------------------------------------------------------------------------------------------------------------------
If not exists (select 1 from sys.tables where name='HRMS_PROVISION_DETAILS')
Begin
	CREATE TABLE [dbo].[HRMS_PROVISION_DETAILS]
	([Docentry] [int] NULL,[EmpID] [nvarchar](11) NULL,[IDNo] [nvarchar](100) NULL,[EmpName] [nvarchar](4000) NULL,[VisaSponsor] [nvarchar](250) NOT NULL,[Location] [nvarchar](100) NOT NULL,[Department] [nvarchar](20) NOT NULL,
	[JoinDate] [date] NULL,[ProvisionDate] [date] NULL,[WorkedDays] [int] NULL,[Gratuity_Year] [float] NULL,[Gratuity_21Days] [float] NULL,[Gratuity_21Year] [int] NULL,[Gratuity_30Days] [float] NULL,[Gratuity_30Year] [int] NULL,
	[Gratuity_Amount] [float] NOT NULL,[Basic] [numeric](38, 6) NOT NULL,[Allowance] [numeric](38, 6) NOT NULL,[GrossSalary] [numeric](38, 6) NULL,[Air_EligibleYear] [smallint] NULL,[Air_EligibleAmt] [numeric](19, 6) NULL,
	[Air_lastBooked] [datetime] NULL,[Air_Days] [int] NULL,[AirTicket_Amount] [numeric](38, 14) NULL,[Leave_OB] [numeric](38, 6) NULL,[Leave_Accured] [numeric](23, 8) NULL,[Leave_taken] [int] NULL,[Leave_Encashed] [numeric](38, 6) NULL,
	[Leave_LOP] [int] NULL,[Leave_Balance] [numeric](38, 6) NULL,[Leave_Amount] [numeric](38, 6) NULL,[Ocrcode1] [nvarchar](100) NULL,[Ocrcode2] [nvarchar](100) NULL,[OCrcode3] [nvarchar](100) NULL,[Ocrcode4] [varchar](1) NOT NULL,
	[Ocrcode5] [nvarchar](100) NULL,[Leave_debitCode] [varchar](100) NULL,[Leave_debitName] [varchar](100) NULL,[Leave_CreditCode] [varchar](100) NULL,[Leave_CreditName] [varchar](100) NULL,[Air_debitCode] [varchar](100) NULL,
	[Air_debitName] [varchar](100) NULL,[Air_CreditCode] [varchar](100) NULL,[Air_CreditName] [varchar](100) NULL,[Gratuity_debitCode] [varchar](100) NULL,[Gratuity_debitName] [varchar](100) NULL,[Gratuity_CreditCode] [varchar](100) NULL,
	[Gratuity_CreditName] [varchar](100) NULL,[JENO] [varchar](100) NULL,[Finalize] [varchar](10) NULL)
End

Go
-------Procedure for Provision Creation --------------------------------------------------------------------
if exists(select 1 from sys.procedures where name='Innova_HRMS_Provision_Creation') Drop Procedure Innova_HRMS_Provision_Creation
Go

CREATE Procedure [dbo].[Innova_HRMS_Provision_Creation](@asondate as datetime)    
as     
begin    
	--Declare @asondate as datetime    
	--set @asondate='20180630'    
    if not exists (Select 1 from HRMS_PROVISION_DETAILS where ProvisionDate=@asondate)    
	Begin        
		IF OBJECT_ID('tempdb..#HRMS_PROVISION') IS NOT NULL drop table #HRMS_PROVISION    
    
		Select EmpID,IDNO,EmpName,VisaSponsor,Location,JoinDate,ProvisionDate,WorkedDays,Gratuity_Year,Gratuity_21Days,Gratuity_21Year,Gratuity_30Days,Gratuity_30Year,Gratuity_Amount,Basic,Allowance,GrossSalary,    
		Air_EligibleYear,Air_EligibleAmt,Air_lastBooked,Air_Days,AirTicket_Amount,Leave_OB,Leave_Accured,Leave_taken,Leave_Encashed,Leave_LOP,Leave_Balance,Leave_Amount     
		into #HRMS_PROVISION from HRMS_PROVISION_DETAILS where 1=2    
    
		Insert into #HRMS_PROVISION     
		(EmpID,IDNO,EmpName,VisaSponsor,Location,JoinDate,ProvisionDate,WorkedDays,Gratuity_Year,Gratuity_21Days,Gratuity_21Year,Gratuity_30Days,Gratuity_30Year,Gratuity_Amount,Basic,Allowance,GrossSalary,    
		Air_EligibleYear,Air_EligibleAmt,Air_lastBooked,Air_Days,AirTicket_Amount,Leave_OB,Leave_Accured,Leave_taken,Leave_Encashed,Leave_LOP,Leave_Balance,Leave_Amount)    
		Exec [@SMS_SP_Employee-wise_End_of_Service]  @asondate    
   
		Insert into #HRMS_PROVISION     
		(EmpID,IDNO,EmpName,VisaSponsor,Location,JoinDate,ProvisionDate,WorkedDays,Gratuity_Year,Gratuity_21Days,Gratuity_21Year,Gratuity_30Days,Gratuity_30Year,Gratuity_Amount,Basic,Allowance,GrossSalary,    
		Air_EligibleYear,Air_EligibleAmt,Air_lastBooked,Air_Days,AirTicket_Amount,Leave_OB,Leave_Accured,Leave_taken,Leave_Encashed,Leave_LOP,Leave_Balance,Leave_Amount)    
		select U_EmpID,U_idno,U_empname,'','',U_JoinDate,@asondate,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0  
		from [@SMPR_OLSE] where isnull(U_setltype,'')='FF' and isnull(U_approved,'')='Y' and isnull(Canceled,'')='N'  
		and Datepart(MM,U_LveSettDate)=Datepart(MM,@asondate) and Datepart(yyyy,U_lvesettdate)=Datepart(yyyy,@asondate)   
		--and U_LveSettDate between '20180701' and '20181130'  
 
  
		Insert into #HRMS_PROVISION     
		(EmpID,IDNO,EmpName,VisaSponsor,Location,JoinDate,ProvisionDate,WorkedDays,Gratuity_Year,Gratuity_21Days,Gratuity_21Year,Gratuity_30Days,Gratuity_30Year,Gratuity_Amount,Basic,Allowance,GrossSalary,    
		Air_EligibleYear,Air_EligibleAmt,Air_lastBooked,Air_Days,AirTicket_Amount,Leave_OB,Leave_Accured,Leave_taken,Leave_Encashed,Leave_LOP,Leave_Balance,Leave_Amount)    
   
		Select EmpID,IDNO,EmpName,VisaSponsor,Location,JoinDate,@asondate,WorkedDays,Gratuity_Year,Gratuity_21Days,Gratuity_21Year,Gratuity_30Days,Gratuity_30Year,Gratuity_Amount,Basic,Allowance,GrossSalary,    
		Air_EligibleYear,Air_EligibleAmt,Air_lastBooked,Air_Days,AirTicket_Amount,Leave_OB,Leave_Accured,Leave_taken,Leave_Encashed,Leave_LOP,Leave_Balance,Leave_Amount     
		from HRMS_PROVISION_DETAILS where ProvisionDate=(Select max(ProvisionDate) from HRMS_PROVISION_DETAILS) and empid not in (select empid from #HRMS_PROVISION)  
    
		Declare @Docentry as int    
		set @docentry =(Select isnull(Max(Docentry),0)+1 from HRMS_PROVISION_details)    
    
		Insert into HRMS_PROVISION_DETAILS     
		(Docentry,EmpID,IDNo,EmpName,VisaSponsor,Location,Department,JoinDate,ProvisionDate,WorkedDays,Gratuity_Year,Gratuity_21Days,Gratuity_21Year,Gratuity_30Days,Gratuity_30Year,Gratuity_Amount    
		,Basic,Allowance,GrossSalary,Air_EligibleYear,Air_EligibleAmt,Air_lastBooked,Air_Days,AirTicket_Amount,Leave_OB,Leave_Accured,Leave_taken,Leave_Encashed,Leave_LOP,Leave_Balance,Leave_Amount,    
		Ocrcode1,Ocrcode2,OCrcode3,Ocrcode4,Ocrcode5,Leave_debitCode,Leave_debitName,Leave_CreditCode,Leave_CreditName,Air_debitCode,Air_debitName,Air_CreditCode,Air_CreditName,    
		Gratuity_debitCode,Gratuity_debitName,Gratuity_CreditCode,Gratuity_CreditName,JENO,Finalize)    
    
		select @docentry [Docentry],T0.EmpID,IDNO,EmpName,VisaSponsor,Location,T2.Name[Department],JoinDate,ProvisionDate,WorkedDays,Gratuity_Year,Gratuity_21Days,Gratuity_21Year,Gratuity_30Days,Gratuity_30Year,Gratuity_Amount,    
		Basic,Allowance,GrossSalary,Air_EligibleYear,Air_EligibleAmt,Air_lastBooked,Air_Days,AirTicket_Amount,Leave_OB,Leave_Accured,Leave_taken,Leave_Encashed,Leave_LOP,Leave_Balance,Leave_Amount,    
		T3.U_costcode [Ocrcode1],T2.U_costcode[Ocrcode2],T0.IDNO[Ocrcode3],''[Ocrcode4],T1.U_otherscc [Ocrcode5],U_lveprvdc,U_lveprvdn,U_lveprvcc,U_lveprvcn,U_airprvdc,U_airprvdn,U_airprvcc,U_airprvcn,U_graprvdc,U_graprvdn,U_graprvcc,U_graprvcn,'','Y'    
		from #HRMS_PROVISION T0 left join [@SMPR_OHEM] T1 on T0.empid=T1.U_empid and T0.IDNo=T1.U_ExtEmpNo left join OUDP T2 on T2.code=T1.U_dept  left join oubr T3 on T3.code=T1.U_branch    
		left join (select Distinct U_emptype,U_lveprvdc,U_lveprvdn,U_lveprvcc,U_lveprvcn,U_airprvdc,U_airprvdn,U_airprvcc,U_airprvcn,U_graprvdc,U_graprvdn,U_graprvcc,U_graprvcn from [@SMPR_ACCT]     
		Where @asondate between U_Fromdate and isnull(U_Todate,@asondate)) T4 on T4.U_emptype=T1.U_gropCode    
  	End    
	--select * from HRMS_PROVISION_details    
 IF OBJECT_ID('tempdb..#HRMS_PROVISION') IS NOT NULL drop table #HRMS_PROVISION    
End  
--[Innova_HRMS_Provision_Creation] 

-------Procedure for the Provision Report--------------------------------------------------------------------------------------------------------------------------------------------------------------
Go
if exists(select 1 from sys.procedures where name='Innova_HRMS_Provision_Report') Drop Procedure Innova_HRMS_Provision_Report
Go
CREATE Procedure [dbo].[Innova_HRMS_Provision_Report](@month as varchar(10),@Year as varchar(10))
As
Begin
	Declare @docentry as varchar(10)
	set @docentry=(Select distinct Docentry from HRMS_PROVISION_DETAILS WHere Datepart(MM,ProvisionDate)=@month and Datepart(YYYY,ProvisionDate)=@Year)
	
	Declare @previousEntry as varchar(10)
	set @previousEntry=(Select Max(Docentry) from HRMS_PROVISION_DETAILS where ProvisionDate=(select Max(ProvisionDate) from HRMS_PROVISION_DETAILS 
	where ProvisionDate <(Select distinct ProvisionDate from HRMS_PROVISION_DETAILS WHere Docentry=@docentry)))

	;with previousdetails as (
	select EmpID,IDNO,ProvisionDate,Gratuity_Amount,AirTicket_Amount,Leave_Amount,((Gratuity_30Year+Gratuity_30Days)*30)+((Gratuity_21Year+Gratuity_21Days)*21)[GratuityDays],Leave_Balance from HRMS_PROVISION_DETAILS WHere Docentry=@previousEntry),
	Empdetails as (
	select T0.U_ExtEmpNo,T1.Descr  from [@SMPR_OHEM] T0 inner join (select B.FldValue,B.Descr from CUFD A inner join UFD1 B on A.TableID=B.TableID and A.FieldID =B.FieldID  
	where A.tableid='@SMPR_OHEM' and A.aliasid='gropcode') T1 on T0.U_gropcode=T1.FldValue)

	Select T0.ProvisionDate,T0.IDNO [Emp ID],T0.EMPName[Emp Name],T2.Descr[Employee Group],T0.VisaSponsor[Visa],T0.Department[Department],T0.Location[Branch],
	isnull(((T0.Gratuity_30Year+T0.Gratuity_30Days)*30)+((T0.Gratuity_21Year+T0.Gratuity_21Days)*21),0)[C_GratuityDays],isnull(T1.GratuityDays,0)[P_GratuityDays],
	isnull(((T0.Gratuity_30Year+T0.Gratuity_30Days)*30)+((T0.Gratuity_21Year+T0.Gratuity_21Days)*21),0)-isnull(T1.GratuityDays,0)[GratuityDays]
	,isnull(T0.Gratuity_Amount,0)[C_Gratuity],isnull(T1.Gratuity_Amount,0)[P_Gratuity],isnull(T0.Gratuity_Amount,0)-isnull(T1.Gratuity_Amount,0)[Gratuity],
	T0.Air_EligibleAmt,T0.Air_EligibleYear,T0.Air_lastBooked[Last Booked Date],isnull(T0.AirTicket_Amount,0)[C_AirTicket],isnull(T1.AirTicket_Amount,0)[P_AirTicket],isnull(T0.AirTicket_Amount,0)-isnull(T1.AirTicket_Amount,0)[AirTicket],
	isnull(T0.leave_balance,0)[C_Leavebalance],isnull(T1.Leave_balance,0)[P_leavebalance],isnull(T0.leave_balance,0)-isnull(T1.Leave_balance,0) [LeaveBalance],
	isnull(T0.Leave_Amount,0)[C_Leave],isnull(T1.Leave_Amount,0)[P_Leave],isnull(T0.Leave_Amount,0)-isnull(T1.Leave_Amount,0) [Leave],
	left(DateName(MM,T0.ProvisionDate),3)+'-'+convert(varchar,DateName(YYYY,T0.ProvisionDate))[Current],left(DateName(MM,T1.ProvisionDate),3)+'-'+convert(varchar,DateName(YYYY,T1.ProvisionDate))[Previous],isnull(Finalize,'')[Finalize],isnull(Jeno,'')[JENO]
	from HRMS_PROVISION_DETAILS T0 left join previousdetails T1 on T0.empid=T1.empid inner join Empdetails T2 on T2.U_ExtEmpNo=T0.IDNo
	Where T0.Docentry=@docentry order by T0.IDNo 

End
