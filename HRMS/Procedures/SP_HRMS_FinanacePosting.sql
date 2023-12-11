-------Table Creation for Provision--------------------------------------------------------------------------------------------------------------------------------------------------------------
If not exists (select 1 from sys.tables where name='HRMS_POSTINGLOG')
Begin
	CREATE TABLE [dbo].[HRMS_POSTINGLOG]([ID] [int] IDENTITY(1,1) NOT NULL,[Createdate] [datetime] NOT NULL DEFAULT (getdate()),[OBJTYPE] [varchar](20) NULL,[DocEntry] [varchar](100) NULL,[JENO] [varchar](100) NULL,
	[Status] [varchar](10) NULL,[Remarks] [varchar](max) NULL,PRIMARY KEY CLUSTERED ([ID] ASC)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
End

Go
-------Procedure for Employee Details Update--------------------------------------------------------------------
if exists(select 1 from sys.procedures where name='Innova_HRMS_EmployeeDetailsUpdate_OHEM') Drop Procedure Innova_HRMS_EmployeeDetailsUpdate_OHEM
Go

CREATE Procedure [dbo].[Innova_HRMS_EmployeeDetailsUpdate_OHEM]  
as  
Begin  
	Update T1 set T1.ExtEmpNo=T0.U_ExtEmpNo,T1.firstName=T0.U_firstNam,T1.lastName=T0.U_lastName,T1.jobTitle=left(T0.U_jobTitle,20),T1.position=T0.U_position, T1.dept=T0.U_dept,T1.branch=T0.U_branch,
	T1.manager=T0.U_manager,T1.userId=T0.U_userid,T1.salesPrson=T0.U_slpcode,T1.officeTel=T0.U_oficetel,T1.officeExt=T0.U_oficeext,T1.mobile=left(T0.U_mobile,20),T1.pager=left(T0.U_pager,20),T1.homeTel=T0.U_hometel,T1.fax=left(T0.U_fax,20),
	T1.email=T0.U_email,T1.workStreet=T0.U_wstreet,T1.StreetNoW=T0.U_wstretno,T1.WorkBuild=T0.U_wbuildng, T1.workBlock=T0.U_wblock,T1.workZip=T0.U_wzipcode,T1.workCity=T0.U_wcity,T1.workCounty=T0.U_wcounty,T1.workCountr=T0.U_wcountry,
	T1.workState=T0.U_wtate,T1.homeStreet=T0.U_nstreet, T1.StreetNoH=T0.U_nstretno,T1.HomeBuild=T0.U_nbuildng,T1.homeBlock=T0.U_nblock,T1.homeZip=T0.U_nzipcode,T1.homeCity=T0.U_ncity,T1.homeCounty=T0.U_ncounty,T1.homeCountr=T0.U_ncountry,
	T1.homeState=T0.U_ntate,T1.birthDate=T0.U_obirthDt,T1.brthCountr=T0.U_brthcont,T1.citizenshp=T0.U_citizen,T1.martStatus=T0.U_mrstatus,T1.nChildren=T0.U_noofchld,T1.sex=T0.U_sex--,T1.U_Bloodgrp=left(T0.U_bloodgrp,10),T1.U_OutsourID=T0.U_religion,
	--T1.U_EmpGrpCode=T0.U_GropCode,T1.U_PhotoAttach=T0.U_photoatt,T1.passportNo=T0.U_passpno,T1.passportEx=T0.U_passexdt,T1.PassIssue=T0.U_passisdt,T1.PassIssuer=T0.U_passisur, T1.startDate=T0.U_startdte,T1.status=T0.U_status,T1.U_ProbMonth=T0.U_probmnth,
	--T1.U_Probdate=T0.U_probdate,T1.U_ProbExtdate=T0.U_probexdt,T1.U_ContEndDate=T0.U_conenddt,T1.termDate=T0.U_termdate, T1.termReason=T0.U_termreas,T1.U_ResgDate=T0.U_resgdate,T1.U_NoticePerdDays=T0.U_noteperd,T1.U_termType=T0.U_termtype,
	--T1.U_PayMode=T0.U_paymode,T1.bankCode=T0.U_bankcode,T1.bankBranch=T0.U_bankbrch, T1.bankAcount=T0.U_bankacct,T1.U_IBAN=T0.U_bankiban,T1.U_BFirstName=T0.U_bankfnam,T1.U_BLastName=T0.U_banklnam,T1.U_Location=T0.U_location,
	--T1.U_ShiftCode=T0.U_shiftcde,T1.U_OT=T0.U_OT, T1.U_GradeCode=T0.U_grade,T1.U_SubGrade1=T0.U_subgrad1,T1.U_SubGrade2=T0.U_subgrad2,T1.U_FandF=T0.U_fandf,T1.U_CampCode=T0.U_campcode,T1.U_RoomNo=T0.U_roomno,T1.U_Destination=T0.U_destplac, 
	--T1.U_ApprovedUser=T0.U_approved,T1.U_LoanEligible=T0.U_loanelgi,T1.U_PPFileName=T0.U_ppfname,T1.U_PPAttach=T0.U_ppattach,T1.U_LveSettlmentOBDate=T0.U_lvstobdt,T1.U_LveSettlmentOBDays=T0.U_lvstobdy 
	From  OHEM T1 inner join  [@SMPR_OHEM] T0 on T1.ExtEmpNo=T0.U_ExtEmpNo   
End    


Go
-------Procedure for Loan APplication Posting--------------------------------------------------------------------
if exists(select 1 from sys.procedures where name='Innova_HRMS_Posting_LoanApplication') Drop Procedure Innova_HRMS_Posting_LoanApplication
Go

Create Procedure [dbo].[Innova_HRMS_Posting_LoanApplication] 
as 
Begin
	;with empdetails as (Select T0.U_empid,T0.U_gropCode,T1.U_costcode[Dept_CC],T2.U_costcode[Location_CC],T0.U_ExtEmpNo[Employee_CC],T0.U_otherscc[Others_CC] 
		 from [@SMPR_OHEM] T0 inner join OUDP T1 on T0.U_dept=T1.code inner join OUBR T2 on T2.code=T0.U_branch)

	select  T0.DocEntry,T0.Docnum,T0.U_empID,T0.U_empname,T0.U_IDNo,T0.U_DocDate [Date],T1.Code,T1.Name,T0.U_loanamt[Amount],T3.U_loandc[DebitAccount],T3.U_loancc[CreditAccount],
	t2.Location_CC [Ocrcode1],t2.Dept_CC [Ocrcode2],t2.Employee_CC [Ocrcode3],''[Ocrcode4],t2.Others_CC [Ocrcode5],'OLOA' [Transcode],'Loan Application - ' +T0.U_IDNo [Memo],
	left('Loan Application - Entry No : ' + convert(varchar,T0.DocEntry) +' & Appl No : ' +convert(varchar,T0.Docnum) +' & Loan Type : '+ T1.Name ,250)[Narration],
	left(('Employee No : '+T0.U_IDNo+ '  ID : '+T0.U_Empid),99)[Ref1],left(T0.U_empname,99)[Ref2],left(T1.Name,26)[Ref3]
	from [@SMPR_OLOA] T0 inner join [@SMPR_OLON] T1 on T0.U_LoanCode=T1.code inner join empdetails T2 on T2.U_empid=T0.U_empID 
	inner join (select U_emptype ,U_fromdate,U_todate,T1.U_loancode,T1.U_loandc,T1.U_loancc from [@SMPR_ACCT] T0 inner join [@SMPR_ACCT1] T1 on T0.code=T1.code where isnull(T1.U_loancode,'')<>'')T3 on T3.U_emptype=T2.U_gropCode
	and T3.U_loancode=T0.U_LoanCode and convert(date,T0.U_DocDate) between convert(date,T3.U_fromdate) and convert(date,isnull(T3.U_todate,T0.U_DocDate)) 
	where isnull(T0.U_JENO,'')='' and isnull(T0.U_approved,'N')='Y' and isnull(T0.Canceled,'N')='N' and isnull(T0.status,'')='O'
	--and isnull(T0.U_deduction,'')<>'Y'
End

--Exec [Innova_HRMS_Posting_LoanApplication] 

Go
-------Procedure for Loan APplication Repayment Manual Posting--------------------------------------------------------------------
if exists(select 1 from sys.procedures where name='Innova_HRMS_Posting_LoanRepayment_Manual') Drop Procedure Innova_HRMS_Posting_LoanRepayment_Manual
Go

CREATE Procedure [dbo].[Innova_HRMS_Posting_LoanRepayment_Manual] 
as 
Begin
	;with empdetails as (Select T0.U_empid,T0.U_gropCode,T1.U_costcode[Dept_CC],T2.U_costcode[Location_CC],T0.U_ExtEmpNo[Employee_CC],T0.U_otherscc[Others_CC] 
		 from [@SMPR_OHEM] T0 inner join OUDP T1 on T0.U_dept=T1.code inner join OUBR T2 on T2.code=T0.U_branch),
	IncomingDetails as (Select DocEntry,DocNum,Docdate,objtype from ORCT)

	select T0.DocEntry,T0.Docnum,T4.LineId,T0.U_empID,T0.U_empname,T0.U_IDNo,T5.DocDate [Date],T1.Code,T1.Name,T4.U_PaidAmt [Amount],T3.U_loancc[DebitAccount],T3.U_loandc[CreditAccount],
	t2.Location_CC [Ocrcode1],t2.Dept_CC [Ocrcode2],t2.Employee_CC [Ocrcode3],''[Ocrcode4],t2.Others_CC [Ocrcode5],'OLOA' [Transcode],'Loan Application Deduction- ' +T0.U_IDNo [Memo],
	left('Loan Application - Entry No : ' + convert(varchar,T0.DocEntry) +' & Appl No : ' +convert(varchar,T0.Docnum)+' & Line No : ' +convert(varchar,T4.LineId) +' & Loan Type : '+ T1.Name ,250)[Narration],
	left(('Employee No : '+T0.U_IDNo+ '  ID : '+T0.U_Empid),99)[Ref1],left(T0.U_empname,99)[Ref2],left(convert(varchar,T1.Name) +' - Deduction',26)[Ref3]
	from [@SMPR_OLOA] T0 inner join [@SMPR_LOA1] T4 on T4.DocEntry=T0.DocEntry  inner join [@SMPR_OLON] T1 on T0.U_LoanCode=T1.code 
	inner join empdetails T2 on T2.U_empid=T0.U_empID inner join IncomingDetails T5 on T5.DocEntry=T4.U_trgtenty and T5.objtype=T4.U_trgttype
	inner join (select U_emptype ,U_fromdate,U_todate,T1.U_loancode,T1.U_loandc,T1.U_loancc from [@SMPR_ACCT] T0 inner join [@SMPR_ACCT1] T1 on T0.code=T1.code where isnull(T1.U_loancode,'')<>'')T3 on T3.U_emptype=T2.U_gropCode 
	and T3.U_loancode=T0.U_LoanCode and convert(date,T5.DocDate) between convert(date,T3.U_fromdate) and convert(date,isnull(T3.U_todate,T5.DocDate))
	where isnull(T0.U_approved,'N')='Y' and isnull(T0.Canceled,'N')='N' and isnull(T4.U_Status,'')='C' and  isnull(T4.U_trgttype,'')='24' and isnull(T4.U_jeno,'')=''
End

--Exec [Innova_HRMS_Posting_LoanRepayment_Manual] 

Go
-------Procedure for Settlement Posting--------------------------------------------------------------------
if exists(select 1 from sys.procedures where name='Innova_HRMS_Posting_Settlement') Drop Procedure Innova_HRMS_Posting_Settlement
Go

Create Procedure [dbo].[Innova_HRMS_Posting_Settlement](@Docentry varchar(100))
as 
Begin 
	--Declare @Docentry as varchar(100)
	--set @Docentry=186
	Declare @GLEntry as varchar(100),@settype as varchar(100)
	IF OBJECT_ID('tempdb..#details') IS NOT NULL drop table #details

	Select @GLEntry=T2.Code,@settype=(Case when T0.U_setltype='LS' then  'Leave Settlement' else 'Full & Final Settlement' end) from [@SMPR_OLSE] T0 Inner join [@SMPR_OHEM] T1 on T0.U_empid=T1.U_empid 
	Inner join [@SMPR_ACCT] T2 on T2.U_emptype=T1.U_gropCode and T0.U_LveSettDate between T2.U_fromdate and isnull(T2.U_todate,T0.U_LveSettDate)
	Where T0.DocEntry=@Docentry

	;With Cte as (
	Select T0.DocEntry,T0.U_lvsalamt,T2.U_lvesaldc,T2.U_lvesaldn,T2.U_lvesalcc,T2.U_lvesalcn,T0.U_lvncshmt,T2.U_lveencdc,T2.U_lveencdn,T2.U_lveenccc,T2.U_lveenccn,T0.U_AiTiketAmt,T2.U_aircladc,T2.U_aircladn,T2.U_airclacc,T2.U_airclacn,
	T0.U_advsalry,T2.U_advsaldc,T2.U_advsaldn,T2.U_advsalcc,T2.U_advsalcn,T0.U_gratuity,T2.U_gratiydc,T2.U_gratiydn,T2.U_gratiycc,T2.U_gratiycn,T0.U_Remarks [Remarks]
	from [@SMPR_OLSE] T0 Inner join [@SMPR_ACCT] T2 on T2.Code=@GLEntry Where T0.DocEntry=@Docentry),

	Details as (
	Select Docentry,'Leave Salary' [Type],'' Name,U_lvsalamt[Amount],U_lvesaldc[DebitCode],U_lvesaldn[DebitName],U_lvesalcc[CreditCode],U_lvesalcn[CreditName]from cte where isnull(U_lvsalamt,0)<>0
	union all
	Select Docentry,'Leave Encashment' [Type],'' Name,U_lvncshmt[Amount],U_lveencdc,U_lveencdn,U_lveenccc,U_lveenccn from cte where isnull(U_lvncshmt,0)<>0
	union all
	Select Docentry,'Air Ticket Claim' [Type],'' Name,U_AiTiketAmt[Amount],U_aircladc,U_aircladn,U_airclacc,U_airclacn from cte where isnull(U_AiTiketAmt,0)<>0
	union all
	Select Docentry,'Advance Salary' [Type],'' Name,U_advsalry[Amount],U_advsaldc,U_advsaldn,U_advsalcc,U_advsalcn from cte where isnull(U_advsalry,0)<>0
	union all
	Select Docentry,'Gratuity' [Type],'' Name,U_gratuity[Amount],U_gratiydc,U_gratiydn,U_gratiycc,U_gratiycn from cte where isnull(U_gratuity,0)<>0
	union all
	Select T0.DocEntry,'Loan Deduction'[Type],T4.Name[Name],T1.U_amount,T3.U_loancc,T3.U_loancn,T3.U_loandc,T3.U_loandn from [@SMPR_OLSE] T0 Inner join [@SMPR_LSE3] T1 on T1.DocEntry=T0.DocEntry 
	inner join [@SMPR_OLOA] T2 on T2.DocEntry=T1.U_loanapen and T2.Docnum=T1.U_loanapno Inner join [@SMPR_ACCT1] T3 on T3.Code =@GLEntry and T3.U_loancode=T2.U_LoanCode 
	inner join [@SMPR_OLON] T4 on T4.code=T2.U_loancode Where isnull(T1.U_amount,0)<>0 and T0.DocEntry=@Docentry
	union all
	Select T0.DocEntry,'Addition/Deduction'[Type],T3.Name,T1.U_amount,T2.U_adddeddc,T2.U_adddeddn,T2.U_adddedcc,T2.U_adddedcn from [@SMPR_OLSE] T0 Inner join [@SMPR_LSE4] T1 on T1.DocEntry=T0.DocEntry 
	Inner join [@SMPR_ACCT2] T2 on T2.Code =@GLEntry and T2.U_andncode=T1.U_type inner join [@SMPR_OPYE] T3 on T3.code=T1.U_type Where isnull(T1.U_amount,0)<>0 and T0.DocEntry=@Docentry),

	CostCenterdetails as (Select T0.U_empid,T2.U_costcode [Ocrcode1],T1.U_costcode [Ocrcode2],T0.U_ExtEmpNo[Ocrcode3],''[Ocrcode4],T0.U_otherscc[Ocrcode5] 
		 from [@SMPR_OHEM] T0 inner join OUDP T1 on T0.U_dept=T1.code inner join OUBR T2 on T2.code=T0.U_branch)

	Select T0.DocEntry,T0.Type[SettType],T0.Name[Sett_Name],T0.Amount,T0.DebitCode,T0.DebitName,T0.CreditCode,T0.CreditName,T1.Docnum,T1.U_lvesettdate[Date],'OLSE' [Transcode],
	T1.U_empid[EmpID],T1.U_IDNO[InnovaID],T1.U_Empname[EmpName],T1.U_Remarks,left(('Employee No : '+T1.U_IDNo+ '  ID : '+T1.U_Empid),99)[Ref1],left(T1.U_empname,99)[Ref2],left(@settype,26)[Ref3],@settype +' - '+T1.U_IDNo [Memo],
	left(@settype +' - Entry No : ' + convert(varchar,T0.DocEntry) +' & Appl No : ' +convert(varchar,T1.Docnum) + (Case when convert(varchar,isnull(U_remarks,''))<>'' then '  Remarks : ' + convert(varchar,U_remarks) else '' end),250)[Narration],
	T2.[Ocrcode1],T2.[Ocrcode2],T2.[Ocrcode3],T2.[Ocrcode4],T2.[Ocrcode5] into #details 
	from details T0 inner join [@SMPR_OLSE] T1 on T0.DocEntry=T1.DocEntry inner join CostCenterdetails T2 on T2.U_empid=T1.U_empid

	Select DocEntry,SettType [Lref1],Sett_Name [Lref2],DocNum[Lref3],Debitcode[AcctCode],DebitName[AcctName],Amount [DebitAmount],0 [CreditAmount],Date,Transcode,Empid,InnovaID,EMpName,Ref1,Ref2,Ref3,Memo,Narration,
	[Ocrcode1],[Ocrcode2],[Ocrcode3],[Ocrcode4],[Ocrcode5]   from #details
	union all
	Select DocEntry,'','',DocNum[Lref3],CreditCode[AcctCode],CreditName[AcctName],0 [DebitAmount],Sum(Amount) [CreditAmount],Date,Transcode,Empid,InnovaID,EMpName,Ref1,Ref2,Ref3,Memo,Narration,
	[Ocrcode1],[Ocrcode2],[Ocrcode3],[Ocrcode4],[Ocrcode5]   from #details
	Group by DocEntry,CreditCode,CreditName,DocNum,Date,Transcode,Empid,InnovaID,EMpName,Ref1,Ref2,Ref3,Memo,Narration,[Ocrcode1],[Ocrcode2],[Ocrcode3],[Ocrcode4],[Ocrcode5]

	IF OBJECT_ID('tempdb..#details') IS NOT NULL drop table #details
End

--[Innova_HRMS_Posting_Settlement] 181

Go
-------Procedure for Payroll Process Posting--------------------------------------------------------------------
if exists(select 1 from sys.procedures where name='Innova_HRMS_Posting_PayrollProcess') Drop Procedure Innova_HRMS_Posting_PayrollProcess
Go

CREATE Procedure [dbo].[Innova_HRMS_Posting_PayrollProcess]( @Docentry varchar(100))    
as     
Begin    
	IF OBJECT_ID('tempdb..#temp_GLEntry') IS NOT NULL drop table #temp_GLEntry    
	IF OBJECT_ID('tempdb..#Payroll_posting') IS NOT NULL drop table #Payroll_posting    
	--Declare @docentry as varchar(100)    
	--Set @docentry=57    
    
	--Getting Cost Center details for the employees    
	;with CostCenterdetails as (Select T0.U_empid,T2.U_costcode [Ocrcode1],T1.U_costcode [Ocrcode2],T1.Name ,T0.U_ExtEmpNo[Ocrcode3],''[Ocrcode4],T0.U_otherscc[Ocrcode5]     
	from [@SMPR_OHEM] T0 inner join OUDP T1 on T0.U_dept=T1.code inner join OUBR T2 on T2.code=T0.U_branch)    
	--Getting Account Mapping table details    
	Select T1.U_IDNO,T1.U_empid,T3.Code [GLEntry],T4.ocrcode1,T4.ocrcode2,T4.ocrcode3,T4.ocrcode4,T4.ocrcode5,T0.U_todate [Date],'OPRC'[Transcode],    
	'Payroll Process For the Month of '+DateName(Month,T0.U_todate)+ ' '+Convert(varchar,DateName(YYYY,T0.U_todate))[Memo],'Payroll Process For the Month of '+DateName(Month,T0.U_todate)+' '+Convert(varchar,DateName(YYYY,T0.U_todate))[Narration],    
	'Payroll Entry No :' +convert(varchar(100),T0.Docentry) +' Doc No :' +convert(varchar(100),T0.DocNum) [Ref1],'PayrollProcess'[Ref2],T0.DOcnum[Ref3],    
	T3.U_otdc [OtdebitCode],T3.U_otdn [OtdebitName],T3.U_otcc [OtCreditCode],T3.U_otcn [OtCreditName],    
	T3.U_aircladc [AirDebitCode],T3.U_aircladn [AirDebitName],T3.U_airclacc [AirCreditCode],T3.U_airclacn [AirCreditName],    
	T3.U_tripaldc [TripDebitCode],T3.U_tripaldn [TripDebitName],T3.U_tripalcc [TripCreditCode],T3.U_tripalCn [TripCreditName],    
	T3.U_lvesaldc [ALSalDebitCode],T3.U_lvesaldn [ALSalDebitName],T3.U_lvesalcc [ALSalCreditCode],T3.U_lvesalcn [ALSalCreditName],    
	T3.U_advsaldc [AdvsalDebitCode],T3.U_advsaldn [AdvsalDebitName],T3.U_advsalcc [AdvsalCreditCode],T3.U_advsalcn [AdvsalCreditName]    
	into #temp_GLEntry from [@SMPR_OPRC] T0 inner join [@SMPR_PRC1] T1 on T0.DocEntry=T1.DocEntry Inner join [@SMPR_OHEM] T2 on T2.U_empid=T1.U_empid     
	Inner join [@SMPR_ACCT] T3 on T3.U_emptype=T2.U_gropCode and T0.U_Todate between T3.U_fromdate and isnull(T3.U_todate,T0.U_Todate)    
	inner join Costcenterdetails T4 on T4.U_empid=T1.U_empid    
	Where T0.DocEntry=@Docentry    
    
	--Salary Pay Element Posting    
	Select * into #Payroll_posting from (    
	Select 'A'[Type],T1.Date,T1.Transcode,T1.Memo,T1.Narration,T1.Ref1,T1.Ref2,T1.Ref3,Convert(varchar(100),'Salary-PayElements') [Lref1],Convert(varchar(100),T3.Name) [Lref2],T1.Ref3 [Lref3],    
	Convert(varchar(100),T1.Ocrcode1)Ocrcode1,Convert(varchar(100),T1.ocrcode2)ocrcode2,Convert(varchar(100),'') ocrcode3,Convert(varchar(100),'') ocrcode4,Convert(varchar(100),T1.ocrcode5)ocrcode5,    
	T2.U_payeledc[DebitCode],T2.U_payeledn[DebitName],T2.U_payelecc[CreditCode],T2.U_payelecn[CreditName],sum(isnull(T0.Amount,0))Amount from     
	(select U_empID,U_A1 [Amount],'A1' [Type] from [@SMPR_PRC1] Where isnull(U_A1,0)>0 and     Docentry=@Docentry union all     
	select U_empID,U_A2 [Amount],'A2' [Type] from [@SMPR_PRC1] Where isnull(U_A2,0)>0 and     Docentry=@Docentry union all     
	select U_empID,U_A3 [Amount],'A3' [Type] from [@SMPR_PRC1] Where isnull(U_A3,0)>0 and     Docentry=@Docentry union all     
	select U_empID,U_A4 [Amount],'A4' [Type] from [@SMPR_PRC1] Where isnull(U_A4,0)>0 and     Docentry=@Docentry union all     
	select U_empID,U_A5 [Amount],'A5' [Type] from [@SMPR_PRC1] Where isnull(U_A5,0)>0 and     Docentry=@Docentry union all     
	select U_empID,U_A6 [Amount],'A6' [Type] from [@SMPR_PRC1] Where isnull(U_A6,0)>0 and     Docentry=@Docentry union all     
	select U_empID,U_A7 [Amount],'A7' [Type] from [@SMPR_PRC1] Where isnull(U_A7,0)>0 and     Docentry=@Docentry union all     
	select U_empID,U_A8 [Amount],'A8' [Type] from [@SMPR_PRC1] Where isnull(U_A8,0)>0 and     Docentry=@Docentry union all     
	select U_empID,U_A9 [Amount],'A9' [Type] from [@SMPR_PRC1] Where isnull(U_A9,0)>0 and     Docentry=@Docentry union all     
	select U_empID,U_A10 [Amount],'A10' [Type] from [@SMPR_PRC1] Where isnull(U_A10,0)>0 and  Docentry=@Docentry union all     
	select U_empID,U_A11 [Amount],'A11' [Type] from [@SMPR_PRC1] Where isnull(U_A11,0)>0 and  Docentry=@Docentry union all     
	select U_empID,U_A12 [Amount],'A12' [Type] from [@SMPR_PRC1] Where isnull(U_A12,0)>0 and  Docentry=@Docentry union all     
	select U_empID,U_A13 [Amount],'A13' [Type] from [@SMPR_PRC1] Where isnull(U_A13,0)>0 and  Docentry=@Docentry union all     
	select U_empID,U_A14 [Amount],'A14' [Type] from [@SMPR_PRC1] Where isnull(U_A14,0)>0 and  Docentry=@Docentry union all     
	select U_empID,U_A15 [Amount],'A15' [Type] from [@SMPR_PRC1] Where isnull(U_A15,0)>0 and  Docentry=@Docentry union all     
	select U_empID,U_A16 [Amount],'A16' [Type] from [@SMPR_PRC1] Where isnull(U_A16,0)>0 and  Docentry=@Docentry union all     
	select U_empID,U_A17 [Amount],'A17' [Type] from [@SMPR_PRC1] Where isnull(U_A17,0)>0 and  Docentry=@Docentry union all     
	select U_empID,U_A18 [Amount],'A18' [Type] from [@SMPR_PRC1] Where isnull(U_A18,0)>0 and  Docentry=@Docentry union all     
	select U_empID,U_A19 [Amount],'A19' [Type] from [@SMPR_PRC1] Where isnull(U_A19,0)>0 and  Docentry=@Docentry union all     
	select U_empID,U_A20 [Amount],'A20' [Type] from [@SMPR_PRC1] Where isnull(U_A20,0)>0 and  Docentry=@Docentry    
	)T0 Inner join #temp_GLEntry T1 on T0.U_empid=T1.U_empid inner join [@SMPR_ACCT3] T2 on T2.Code=T1.GLEntry    
	inner join [@SMPR_OPYE] T3 on T3.code=T2.U_paycode and T3.U_sequence=T0.Type    
	where isnull(T2.U_paycode,'')<>'' Group by T1.Date,T1.Transcode,T1.Memo,T1.Narration,T1.Ref1,T1.Ref2,T1.Ref3,T1.Ocrcode1,T1.ocrcode2,T1.ocrcode5,U_payeledc,U_payeledn,U_payelecc,U_payelecn,T3.Name)A    
    
	--OT Amount Posting    
	Insert into #Payroll_posting     
	select 'A'[Type],T1.Date,T1.Transcode,T1.Memo,T1.Narration,T1.Ref1,T1.Ref2,T1.Ref3,'Salary-Addition' [Lref1],'OT' [Lref2],T1.Ref3[Lref3],T1.Ocrcode1,T1.Ocrcode2,''ocrcode3,''ocrcode4,T1.ocrcode5,    
	T1.[OtdebitCode],T1.OtdebitName,T1.OtCreditCode,T1.OtCreditName,Sum(U_TotalOTAmt) [Amount]    
	from [@SMPR_PRC1] T0 Inner join #temp_GLEntry T1 on T0.U_empID=T1.U_empID Where isnull(U_TotalOTAmt,0)>0 and  Docentry=@Docentry     
	Group by T1.Date,T1.Transcode,T1.Memo,T1.Narration,T1.Ref1,T1.Ref2,T1.Ref3,T1.Ocrcode1,T1.ocrcode2,T1.ocrcode5,T1.[OtdebitCode],T1.OtdebitName,T1.OtCreditCode,T1.OtCreditName    
    
	--Fixed Addition (Air Ticket Claim)    
	Insert into #Payroll_posting     
	select 'A'[Type],T1.Date,T1.Transcode,T1.Memo,T1.Narration,T1.Ref1,T1.Ref2,T1.Ref3,'Additions'[Lref1],'Air Ticket Claim'[Lref2],T1.Ref3[Lref3],T1.Ocrcode1,T1.ocrcode2,''ocrcode3,''ocrcode4,T1.ocrcode5,T1.airdebitcode,T1.airdebitName,T1.airCreditcode,  
	T1.airCreditName,Sum(U_FA1) [Amount]    
	from [@SMPR_PRC1] T0 Inner join #temp_GLEntry T1 on T0.U_empID=T1.U_empID Where isnull(U_FA1,0)>0 and  Docentry=@Docentry     
	Group by T1.Date,T1.Transcode,T1.Memo,T1.Narration,T1.Ref1,T1.Ref2,T1.Ref3,T1.Ocrcode1,T1.ocrcode2,T1.ocrcode5,T1.airdebitcode,T1.airdebitName,T1.airCreditcode,T1.airCreditName    
    
	--Fixed Addition (Trip Allowance)    
	Insert into #Payroll_posting     
	select 'A'[Type],T1.Date,T1.Transcode,T1.Memo,T1.Narration,T1.Ref1,T1.Ref2,T1.Ref3,'Additions'[Lref1],'Trip Allowance'[Lref2],T1.Ref3[Lref3],T1.Ocrcode1,T1.ocrcode2,''ocrcode3,''ocrcode4,T1.ocrcode5,T1.TripDebitCode,T1.TripDebitName,T1.[TripCreditCode],T1
  
	.[TripCreditName],sum(U_FA2) [Amount]    
	from [@SMPR_PRC1] T0 Inner join #temp_GLEntry T1 on T0.U_empID=T1.U_empID Where isnull(U_FA2,0)>0 and  Docentry=@Docentry     
	Group by T1.Date,T1.Transcode,T1.Memo,T1.Narration,T1.Ref1,T1.Ref2,T1.Ref3,T1.Ocrcode1,T1.ocrcode2,T1.ocrcode5,T1.TripDebitCode,T1.TripDebitName,T1.[TripCreditCode],T1.[TripCreditName]    
    
	--Variable Addition(Addition/Deduction)    
	Insert into #Payroll_posting     
	Select 'A'[Type],T1.Date,T1.Transcode,T1.Memo,T1.Narration,T1.Ref1,T1.Ref2,T1.Ref3,'Additions'[Lref1],T3.Name[Lref2],T1.Ref3[Lref3],T1.Ocrcode1,T1.ocrcode2,''ocrcode3,''ocrcode4,T1.ocrcode5,T2.U_adddeddc[DebitCode],T2.U_adddeddn[DebitName],T2.U_adddedcc[CreditCode],T2.U_adddedcn[CreditName],sum(isnull(T0.Amount,0))Amount from     
	(select U_empID,U_AB1 [Amount],'AB1' [Type] from [@SMPR_PRC1] Where isnull(U_AB1,0)>0 and  Docentry=@Docentry   union all     
	select U_empID,U_AB2 [Amount],'AB2' [Type] from [@SMPR_PRC1] Where isnull(U_AB2,0)>0 and  Docentry=@Docentry    union all     
	select U_empID,U_AB3 [Amount],'AB3' [Type] from [@SMPR_PRC1] Where isnull(U_AB3,0)>0 and  Docentry=@Docentry    union all     
	select U_empID,U_AB4 [Amount],'AB4' [Type] from [@SMPR_PRC1] Where isnull(U_AB4,0)>0 and  Docentry=@Docentry    union all     
	select U_empID,U_AB5 [Amount],'AB5' [Type] from [@SMPR_PRC1] Where isnull(U_AB5,0)>0 and  Docentry=@Docentry    union all     
	select U_empID,U_AB6 [Amount],'AB6' [Type] from [@SMPR_PRC1] Where isnull(U_AB6,0)>0 and  Docentry=@Docentry    union all     
	select U_empID,U_AB7 [Amount],'AB7' [Type] from [@SMPR_PRC1] Where isnull(U_AB7,0)>0 and  Docentry=@Docentry    union all     
	select U_empID,U_AB8 [Amount],'AB8' [Type] from [@SMPR_PRC1] Where isnull(U_AB8,0)>0 and  Docentry=@Docentry    union all     
	select U_empID,U_AB9 [Amount],'AB9' [Type] from [@SMPR_PRC1] Where isnull(U_AB9,0)>0 and  Docentry=@Docentry    union all     
	select U_empID,U_AB10 [Amount],'AB10' [Type] from [@SMPR_PRC1] Where isnull(U_AB10,0)>0 and  Docentry=@Docentry union all     
	select U_empID,U_AB11 [Amount],'AB11' [Type] from [@SMPR_PRC1] Where isnull(U_AB11,0)>0 and  Docentry=@Docentry union all     
	select U_empID,U_AB12 [Amount],'AB12' [Type] from [@SMPR_PRC1] Where isnull(U_AB12,0)>0 and  Docentry=@Docentry union all     
	select U_empID,U_AB13 [Amount],'AB13' [Type] from [@SMPR_PRC1] Where isnull(U_AB13,0)>0 and  Docentry=@Docentry union all     
	select U_empID,U_AB14 [Amount],'AB14' [Type] from [@SMPR_PRC1] Where isnull(U_AB14,0)>0 and  Docentry=@Docentry union all     
	select U_empID,U_AB15 [Amount],'AB15' [Type] from [@SMPR_PRC1] Where isnull(U_AB15,0)>0 and  Docentry=@Docentry union all     
	select U_empID,U_AB16 [Amount],'AB16' [Type] from [@SMPR_PRC1] Where isnull(U_AB16,0)>0 and  Docentry=@Docentry union all     
	select U_empID,U_AB17 [Amount],'AB17' [Type] from [@SMPR_PRC1] Where isnull(U_AB17,0)>0 and  Docentry=@Docentry union all     
	select U_empID,U_AB18 [Amount],'AB18' [Type] from [@SMPR_PRC1] Where isnull(U_AB18,0)>0 and  Docentry=@Docentry union all     
	select U_empID,U_AB19 [Amount],'AB19' [Type] from [@SMPR_PRC1] Where isnull(U_AB19,0)>0 and  Docentry=@Docentry union all     
	select U_empID,U_AB20 [Amount],'AB20' [Type] from [@SMPR_PRC1] Where isnull(U_AB20,0)>0 and  Docentry=@Docentry     
	)T0 Inner join #temp_GLEntry T1 on T0.U_empid=T1.U_empid inner join [@SMPR_ACCT2] T2 on T2.Code=T1.GLEntry    
	inner join [@SMPR_OPYE] T3 on T3.code=T2.U_andncode and T3.U_sequence=T0.Type    
	where isnull(T2.U_andncode,'')<>'' Group by T1.Date,T1.Transcode,T1.Memo,T1.Narration,T1.Ref1,T1.Ref2,T1.Ref3,T1.Ocrcode1,T1.ocrcode2,T1.ocrcode5,U_adddeddc,U_adddeddn,U_adddedcc,U_adddedcn,T3.Name    
    
	--Fixed Deduction (Loan Deduction)    
	Insert into #Payroll_posting     
	Select 'D'[Type],T3.Date,T3.Transcode,T3.Memo,T3.Narration,T3.Ref1,T3.Ref2,T3.Ref3,'Deductions-Loan'[Lref1],A.Name[Lref2],T3.Ref3[Lref3],T3.Ocrcode1,T3.ocrcode2,T0.U_IDNo ocrcode3,''ocrcode4,T3.ocrcode5,    
	T4.U_loancc [DebitCode],T4.U_loancn [DebitName],T4.U_loandc[CreditCode],T4.U_loandn[CreditName],Sum(T1.U_PaidAmt) Amount     
	from [@SMPR_OLOA] T0 inner join [@SMPR_LOA1] T1 on T0.DocEntry=T1.DocEntry inner join [@SMPR_OLON] A on A.code=T0.U_LoanCode     
	inner join [@SMPR_OPRC] T2 on T1.U_Date between T2.U_FromDate and T2.U_todate and T2.DocEntry=@docentry     
	inner join #temp_GLEntry T3 on T3.U_empID =T0.U_empID Inner join [@SMPR_ACCT1] T4 on T4.Code=T3.GLEntry and T4.U_loancode=T0.U_LoanCode     
	Where isnull(T0.U_Approved,'')='Y' and isnull(T0.Canceled,'')<>'Y' and isnull(T1.U_Status,'O')='C' and isnull(T1.U_dedsal,'')='Y' and isnull(T1.U_PaidAmt,0)<>0  and T1.U_trgttype='OPRC' and T1.U_trgtenty=@docentry  
	Group by T3.Date,T3.Transcode,T3.Memo,T3.Narration,T3.Ref1,T3.Ref2,T3.Ref3,A.Name,T3.Ocrcode1,T3.ocrcode2,T0.U_IDNo,T3.ocrcode5,T4.U_loancc,T4.U_loancn,T4.U_loandc,T4.U_loandn    
    
	--Fixed Deduction(Annual Leave Salary Deduction From Leave Settlement)    
	Insert into #Payroll_posting     
	select 'D'[Type],T1.Date,T1.Transcode,T1.Memo,T1.Narration,T1.Ref1,T1.Ref2,T1.Ref3,'Deductions'[Lref1],'Annual Salary'[Lref2],T1.Ref3[Lref3],T1.Ocrcode1,T1.ocrcode2,T0.U_IDNo ocrcode3,''ocrcode4,T1.ocrcode5,    
	T1.ALSalCreditCode [DebitCode],T1.ALSalCreditName [DebitName],T1.ALSalDebitCode [CreditCode],T1.ALSalDebitName [CreditName],sum(U_FD2) [Amount]    
	from [@SMPR_PRC1] T0 Inner join #temp_GLEntry T1 on T0.U_empID=T1.U_empID Where isnull(U_FD2,0)>0 and  Docentry=@Docentry     
	Group by T1.Date,T1.Transcode,T1.Memo,T1.Narration,T1.Ref1,T1.Ref2,T1.Ref3,T1.Ocrcode1,T1.ocrcode2,T0.U_IDNo,T1.ocrcode5,T1.ALSalCreditCode ,T1.ALSalCreditName,T1.ALSalDebitCode,T1.ALSalDebitName    
    
	--Fixed Deduction(Advance Leave Salary Deduction From Leave Settlement)    
	Insert into #Payroll_posting     
	select 'D'[Type],T1.Date,T1.Transcode,T1.Memo,T1.Narration,T1.Ref1,T1.Ref2,T1.Ref3,'Deductions'[Lref1],'Advance Salary'[Lref2],T1.Ref3[Lref3],T1.Ocrcode1,T1.ocrcode2,T0.U_IDNo ocrcode3,''ocrcode4,T1.ocrcode5,    
	T1.AdvSalCreditCode [DebitCode],T1.AdvSalCreditName [DebitName],T1.AdvSalDebitCode [CreditCode],T1.AdvSalDebitName [CreditName],sum(U_FD3) [Amount]    
	from [@SMPR_PRC1] T0 Inner join #temp_GLEntry T1 on T0.U_empID=T1.U_empID Where isnull(U_FD3,0)>0 and  Docentry=@Docentry     
	Group by T1.Date,T1.Transcode,T1.Memo,T1.Narration,T1.Ref1,T1.Ref2,T1.Ref3,T1.Ocrcode1,T1.ocrcode2,T0.U_IDNo,T1.ocrcode5,T1.AdvSalCreditCode,T1.AdvSalCreditName,T1.AdvSalDebitCode,T1.AdvSalDebitName    
    
	--Variable Deduction (Addition/Deduction)    
	Insert into #Payroll_posting     
	Select 'D'[Type],T1.Date,T1.Transcode,T1.Memo,T1.Narration,T1.Ref1,T1.Ref2,T1.Ref3,'Deductions'[Lref1],T3.Name[Lref2],T1.Ref3[Lref3],T1.Ocrcode1,T1.ocrcode2,T1.U_IDNo ocrcode3,''ocrcode4,T1.ocrcode5,    
	T2.U_adddedcc[DebitCode],T2.U_adddedcn[DebitName],T2.U_adddeddc[CreditCode],T2.U_adddeddn[CreditName],sum(isnull(T0.Amount,0))Amount from     
	(select U_empID,U_DB1 [Amount],'DB1' [Type] from [@SMPR_PRC1] Where isnull(U_DB1,0)>0 and  Docentry=@Docentry   union all     
	select U_empID,U_DB2 [Amount],'DB2' [Type] from [@SMPR_PRC1] Where isnull(U_DB2,0)>0 and  Docentry=@Docentry    union all     
	select U_empID,U_DB3 [Amount],'DB3' [Type] from [@SMPR_PRC1] Where isnull(U_DB3,0)>0 and  Docentry=@Docentry    union all     
	select U_empID,U_DB4 [Amount],'DB4' [Type] from [@SMPR_PRC1] Where isnull(U_DB4,0)>0 and  Docentry=@Docentry    union all     
	select U_empID,U_DB5 [Amount],'DB5' [Type] from [@SMPR_PRC1] Where isnull(U_DB5,0)>0 and  Docentry=@Docentry    union all     
	select U_empID,U_DB6 [Amount],'DB6' [Type] from [@SMPR_PRC1] Where isnull(U_DB6,0)>0 and  Docentry=@Docentry    union all     
	select U_empID,U_DB7 [Amount],'DB7' [Type] from [@SMPR_PRC1] Where isnull(U_DB7,0)>0 and  Docentry=@Docentry    union all     
	select U_empID,U_DB8 [Amount],'DB8' [Type] from [@SMPR_PRC1] Where isnull(U_DB8,0)>0 and  Docentry=@Docentry    union all     
	select U_empID,U_DB9 [Amount],'DB9' [Type] from [@SMPR_PRC1] Where isnull(U_DB9,0)>0 and  Docentry=@Docentry    union all     
	select U_empID,U_DB10 [Amount],'DB10' [Type] from [@SMPR_PRC1] Where isnull(U_DB10,0)>0 and  Docentry=@Docentry union all     
	select U_empID,U_DB11 [Amount],'DB11' [Type] from [@SMPR_PRC1] Where isnull(U_DB11,0)>0 and  Docentry=@Docentry union all     
	select U_empID,U_DB12 [Amount],'DB12' [Type] from [@SMPR_PRC1] Where isnull(U_DB12,0)>0 and  Docentry=@Docentry union all     
	select U_empID,U_DB13 [Amount],'DB13' [Type] from [@SMPR_PRC1] Where isnull(U_DB13,0)>0 and  Docentry=@Docentry union all     
	select U_empID,U_DB14 [Amount],'DB14' [Type] from [@SMPR_PRC1] Where isnull(U_DB14,0)>0 and  Docentry=@Docentry union all     
	select U_empID,U_DB15 [Amount],'DB15' [Type] from [@SMPR_PRC1] Where isnull(U_DB15,0)>0 and  Docentry=@Docentry union all     
	select U_empID,U_DB16 [Amount],'DB16' [Type] from [@SMPR_PRC1] Where isnull(U_DB16,0)>0 and  Docentry=@Docentry union all     
	select U_empID,U_DB17 [Amount],'DB17' [Type] from [@SMPR_PRC1] Where isnull(U_DB17,0)>0 and  Docentry=@Docentry union all     
	select U_empID,U_DB18 [Amount],'DB18' [Type] from [@SMPR_PRC1] Where isnull(U_DB18,0)>0 and  Docentry=@Docentry union all     
	select U_empID,U_DB19 [Amount],'DB19' [Type] from [@SMPR_PRC1] Where isnull(U_DB19,0)>0 and  Docentry=@Docentry union all     
	select U_empID,U_DB20 [Amount],'DB20' [Type] from [@SMPR_PRC1] Where isnull(U_DB20,0)>0 and  Docentry=@Docentry     
    
	)T0 Inner join #temp_GLEntry T1 on T0.U_empid=T1.U_empid inner join [@SMPR_ACCT2] T2 on T2.Code=T1.GLEntry    
	inner join [@SMPR_OPYE] T3 on T3.code=T2.U_andncode and T3.U_sequence=T0.Type    
	where isnull(T2.U_andncode,'')<>'' Group by T1.Date,T1.Transcode,T1.Memo,T1.Narration,T1.Ref1,T1.Ref2,T1.Ref3,T1.Ocrcode1,T1.ocrcode2,T1.U_IDNo,T1.ocrcode5,U_adddeddc,U_adddeddn,U_adddedcc,U_adddedcn,T3.Name 
    
    
	Select [Type],Date,Transcode,Memo,Narration,Ref1,Ref2,Ref3,Lref1,Lref2,Lref3,Ocrcode1,ocrcode2,ocrcode3,ocrcode4,ocrcode5,DebitCode[AccountCode],DebitName[AccountName],Amount[DebitAmount],0.00[CreditAmount] from #Payroll_posting Where Type='A'    
	Union all    
	Select [Type],Date,Transcode,Memo,Narration,Ref1,Ref2,Ref3,'','',Lref3,'','','','',ocrcode5,CreditCode[AccountCode],CreditName[AccountName],0[DebitAmount],Sum(Amount)[CreditAmount] from #Payroll_posting Where Type='A'    
	Group by [Type],Date,Transcode,Memo,Narration,Ref1,Ref2,Ref3,Lref3,ocrcode5,CreditCode,CreditName    
	Union all    
	Select [Type],Date,Transcode,Memo,Narration,Ref1,Ref2,Ref3,Lref1,Lref2,Lref3,Ocrcode1,ocrcode2,ocrcode3,ocrcode4,ocrcode5,DebitCode[AccountCode],DebitName[AccountName],Amount[DebitAmount],0.00[CreditAmount] from #Payroll_posting Where Type='D'    
	Union all    
	Select [Type],Date,Transcode,Memo,Narration,Ref1,Ref2,Ref3,Lref1,Lref2,Lref3,Ocrcode1,ocrcode2,ocrcode3,ocrcode4,ocrcode5,CreditCode  [AccountCode],CreditName  [AccountName],0.00[DebitAmount],Amount [CreditAmount] from #Payroll_posting Where Type='D'    
    
	IF OBJECT_ID('tempdb..#temp_GLEntry') IS NOT NULL drop table #temp_GLEntry    
	IF OBJECT_ID('tempdb..#Payroll_posting') IS NOT NULL drop table #Payroll_posting    
    
End  
--[Innova_HRMS_Posting_PayrollProcess] 66

Go
-------Procedure for Provision posting--------------------------------------------------------------------
if exists(select 1 from sys.procedures where name='Innova_HRMS_Provision_Posting') Drop Procedure Innova_HRMS_Provision_Posting
Go

Create Procedure [dbo].[Innova_HRMS_Provision_Posting](@docentry as varchar(10))
As
Begin
	--Declare @docentry as varchar(10)
	--set @docentry='2'
	Declare @previousEntry as varchar(10)
	set @previousEntry=(Select Max(Docentry) from HRMS_PROVISION_DETAILS where ProvisionDate=(select Max(ProvisionDate) from HRMS_PROVISION_DETAILS where ProvisionDate <(Select distinct ProvisionDate from HRMS_PROVISION_DETAILS WHere Docentry=@docentry)))

	;with previousdetails as (
	select EmpID,IDNO,ProvisionDate,Gratuity_Amount,AirTicket_Amount,Leave_Amount from HRMS_PROVISION_DETAILS WHere Docentry=@previousEntry)

	select 'PROV' Transcode,DateName(MM,T0.ProvisionDate)+'-'+Convert(varchar,Datepart(YYYY,T0.ProvisionDate))[Period],T0.ProvisionDate,
	sum(isnull(T0.Gratuity_Amount,0))[Current_Gratuity],sum(isnull(T1.Gratuity_Amount,0))[Previous_Gratuity],sum(isnull(T0.Gratuity_Amount,0)-isnull(T1.Gratuity_Amount,0))Gratuity_Amount,
	sum(isnull(T1.AirTicket_Amount,0))[Previous_AirTicket_Amount],sum(isnull(T0.AirTicket_Amount,0))[Current_AirTicket_Amount],sum(isnull(T0.AirTicket_Amount,0)-isnull(T1.AirTicket_Amount,0)) [AirTicket_Amount],
	sum(isnull(T1.Leave_Amount,0))[Previous_Leave_Amount],sum(isnull(T0.Leave_Amount,0))[Current_Leave_Amount],sum(isnull(T0.Leave_Amount,0)-isnull(T1.Leave_Amount,0)) [Leave_Amount],
	T0.Ocrcode1,T0.Ocrcode2,'' Ocrcode3,T0.Ocrcode4,T0.Ocrcode5,T0.Gratuity_debitCode,T0.Gratuity_debitName,T0.Gratuity_CreditCode,T0.Gratuity_CreditName,T0.Air_debitCode,T0.Air_debitName,T0.Air_CreditCode,T0.Air_CreditName
	,T0.Leave_debitCode,T0.Leave_debitName,T0.Leave_CreditCode,T0.Leave_CreditName
	from HRMS_PROVISION_DETAILS T0 left join previousdetails T1 on T0.empid=T1.empid 
	Where T0.Docentry=@docentry
	Group by DateName(MM,T0.ProvisionDate)+'-'+Convert(varchar,Datepart(YYYY,T0.ProvisionDate)),T0.ProvisionDate,T0.Ocrcode1,T0.Ocrcode2,T0.Ocrcode4,T0.Ocrcode5,
	T0.Gratuity_debitCode,T0.Gratuity_debitName,T0.Gratuity_CreditCode,T0.Gratuity_CreditName,T0.Air_debitCode,T0.Air_debitName,T0.Air_CreditCode,T0.Air_CreditName,T0.Leave_debitCode,T0.Leave_debitName,T0.Leave_CreditCode,T0.Leave_CreditName

End


