-------Loan Application History Details--------------------------------------------------------------------
if exists(select 1 from sys.procedures where name='Innova_HRMS_LoanApplicaiton_History') Drop Procedure Innova_HRMS_LoanApplicaiton_History
Go
CREATE Procedure [dbo].[Innova_HRMS_LoanApplicaiton_History](@empid varchar(100),@Tabletype as varchar(1),@docentry varchar(100),@loancode varchar(100))
as
begin

	if @Tabletype='H'
	Begin 
		 Select T0.DocEntry,T0.DocNum,COnvert(varchar,T0.U_Docdate,103)[Date],
		 (Case when T0.Canceled='Y' then 'Cancelled' Else (Case when T0.status='O' then 'Open' when T0.Status='C' then 'Close' when T0.Status='D' then 'Waiting for Approval' else T0.Status end)end)[Status] ,
		 T1.name [Loan Type],COnvert(numeric(30,2),T0.U_LoanAmt)[Loan Amount],U_NoOfInst [No.Of.Inst],
		 Convert(numeric(30,2),T0.U_AmtMonth)[Amount/Month],COnvert(varchar,U_effdate,103)[Eff Date],Convert(Numeric(30,2),ISNULL(U_paidamt,0))[Paid Amt],
		 (Case when T0.Canceled='Y' then  0 else COnvert(numeric(30,2),ISNULL(U_PendAmt,0)) end)[Bal Amt],
		 Convert(varchar,T0.U_IDNo)+' - '+convert(varchar,T0.U_empName )[header],T0.Object [objtype]
		 from [@SMPR_OLOA] T0 left join [@SMPR_OLON] T1 on T0.U_Loancode=T1.code  Where T0.U_empID=@empid and (T0.U_LoanCode=@loancode or @loancode='-1')
	End
	if @Tabletype='D'
	Begin 
		Select T0.DocEntry,Convert(varchar,T1.U_date,103)[Installment Date],Convert(numeric(30,2),T1.U_Amount)[Amount],Convert(numeric(30,2),T1.U_PaidAmt)[Paid Amount],
		(Case when T0.status='O' then (Case when T1.U_Status='C' then 'Closed' else 'Open' end) when T0.Status='C' then 'Close' when T0.Status='D' then 'Waiting for Approval' else T0.Status end)[Status] ,
		(Case when isnull(T1.U_Dedsal,'N')='N' then 'No' else 'Yes' end)[Consider in Payroll],isnull(U_Detail,'')[Details],ISNULL(T1.U_trgttype,'')[Target Type],isnull(T1.U_trgtenty,'')[Target Entry]
		from [@SMPR_OLOA] T0 inner join [@SMPR_LOA1] T1 on T0.DocEntry=T1.DocEntry Where T0.DocEntry=@docentry 
	End

End
