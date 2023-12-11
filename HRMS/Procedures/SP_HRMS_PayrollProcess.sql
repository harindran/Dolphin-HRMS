	-------Procedure for Payroll Process----------------------------------------------------------------------------------------
if exists(select 1 from sys.procedures where name='Innova_HRMS_PayrollProcess') Drop Procedure Innova_HRMS_PayrollProcess
Go
CREATE Procedure [dbo].[Innova_HRMS_PayrollProcess](@location varchar(max),@payperiod varchar(100),@empstatus varchar(100),@docentry varchar(10))
as
Begin
--Declare @location as varchar(100)
--Declare @payperiod as varchar(100)
--Declare @empstatus as varchar(2)
--Select @location='-1',@payperiod='FY2018-06',@empstatus='1'

Declare @fromdate as datetime,@todate as datetime

select @fromdate=F_RefDate,@todate=T_RefDate  from OFPR Where Code=@payperiod 

if object_ID('tempdb..#Temp_payroll') IS NOT NULL Drop table #Temp_Payroll 

--Employee Details Fetching
Select T0.Code,T0.U_empid,T0.U_ExtEmpNo[EmpCode],T0.U_firstNam+' '+T0.U_lastName [EmpName],T0.U_position [Designation],T0.U_dept [DeptCode],T1.Name [Department],convert(varchar(20),isnull(T0.U_paymode,'')) [PayMode],Datediff(dd,@fromdate,@todate)+1[TotalDays],
Convert(numeric(30,2),0.00) [WorkedDays],Convert(numeric(30,2),0.00) [LopDays],Convert(numeric(30,2),0.00) [PHDays],Convert(numeric(30,2),0.00) [LveDays],Convert(numeric(30,2),0.00) [WODays],Convert(numeric(30,2),0.00) [PayableDays],
Convert(numeric(30,2),0.00) [OTHrs],Convert(numeric(30,2),0.00) [OTDays],Convert(numeric(30,6),0.00)[TotalOT],Convert(numeric(30,6),0.00)[TotalOT_Perhour],Convert(numeric(30,6),0.00) [TotalBasic],Convert(numeric(30,6),0.00) [TotalSalary],
Convert(numeric(30,2),0.00) [A1],Convert(numeric(30,2),0.00) [A2],Convert(numeric(30,2),0.00) [A3],Convert(numeric(30,2),0.00) [A4],Convert(numeric(30,2),0.00) [A5],Convert(numeric(30,2),0.00) [A6],Convert(numeric(30,2),0.00) [A7],
Convert(numeric(30,2),0.00) [A8],Convert(numeric(30,2),0.00) [A9],Convert(numeric(30,2),0.00) [A10],Convert(numeric(30,2),0.00) [A11],Convert(numeric(30,2),0.00) [A12],Convert(numeric(30,2),0.00) [A13],Convert(numeric(30,2),0.00) [A14],
Convert(numeric(30,2),0.00) [A15],Convert(numeric(30,2),0.00) [A16],Convert(numeric(30,2),0.00) [A17],Convert(numeric(30,2),0.00) [A18],Convert(numeric(30,2),0.00) [A19],Convert(numeric(30,2),0.00) [A20],
Convert(numeric(30,2),0.00) [AB1],Convert(numeric(30,2),0.00) [AB2],Convert(numeric(30,2),0.00) [AB3],Convert(numeric(30,2),0.00) [AB4],Convert(numeric(30,2),0.00) [AB5],Convert(numeric(30,2),0.00) [AB6],Convert(numeric(30,2),0.00) [AB7],
Convert(numeric(30,2),0.00) [AB8],Convert(numeric(30,2),0.00) [AB9],Convert(numeric(30,2),0.00) [AB10],Convert(numeric(30,2),0.00) [AB11],Convert(numeric(30,2),0.00) [AB12],Convert(numeric(30,2),0.00) [AB13],Convert(numeric(30,2),0.00) [AB14],
Convert(numeric(30,2),0.00) [AB15],Convert(numeric(30,2),0.00) [AB16],Convert(numeric(30,2),0.00) [AB17],Convert(numeric(30,2),0.00) [AB18],Convert(numeric(30,2),0.00) [AB19],Convert(numeric(30,2),0.00) [AB20],
Convert(numeric(30,2),0.00) [DB1],Convert(numeric(30,2),0.00) [DB2],Convert(numeric(30,2),0.00) [DB3],Convert(numeric(30,2),0.00) [DB4],Convert(numeric(30,2),0.00) [DB5],Convert(numeric(30,2),0.00) [DB6],Convert(numeric(30,2),0.00) [DB7],
Convert(numeric(30,2),0.00) [DB8],Convert(numeric(30,2),0.00) [DB9],Convert(numeric(30,2),0.00) [DB10],Convert(numeric(30,2),0.00) [DB11],Convert(numeric(30,2),0.00) [DB12],Convert(numeric(30,2),0.00) [DB13],Convert(numeric(30,2),0.00) [DB14],
Convert(numeric(30,2),0.00) [DB15],Convert(numeric(30,2),0.00) [DB16],Convert(numeric(30,2),0.00) [DB17],Convert(numeric(30,2),0.00) [DB18],Convert(numeric(30,2),0.00) [DB19],Convert(numeric(30,2),0.00) [DB20],
Convert(numeric(30,6),0.00) [OTAmt],Convert(numeric(30,6),0.00) [GrossSalary],Convert(numeric(30,6),0.00) [LoanDeduction],
Convert(numeric(30,6),0.00) [AirTicekt_Addition],Convert(numeric(30,2),0.00) [AL_Settled_Deduction],Convert(numeric(30,2),0.00) [AdvanceSal_Settlement_Deduction],Convert(numeric(30,2),0.00) [TripAllowance_Addition]
,Convert(numeric(30,6),0.00) [TotalAddition],Convert(numeric(30,6),0.00) [TotalDeduction],Convert(numeric(30,6),0.00) [NetSalaryB4_Round] ,Convert(numeric(30,6),0.00) [Roundoff],Convert(numeric(30,6),0.00) [NetSalary] 
into #Temp_Payroll from [@SMPR_OHEM] T0 left join OUDP T1 on T0.U_dept=T1.Code where (T0.U_status=@empstatus or @empstatus='-1') and (@location like '%#'+T0.U_location+'#%'  or @location='-1') and T0.U_startdte<=@todate 
and T0.U_empid not in (select T1.U_empid from [@SMPR_OPRC] T0 inner join [@SMPR_PRC1] T1 on T0.DocEntry=T1.DocEntry where T0.U_Fromdate=@fromdate and T0.DocEntry<>@docentry)

if (@empstatus='5' or @empstatus='14') Delete #Temp_Payroll where U_empid not in (select U_empid from [@SMPR_OHEM] where U_termdate between @fromdate and @todate) 


--Attendance Details Fetching
Update T0 set T0.PayableDays=T1.TWdays,T0.WorkedDays=T1.Wdays,T0.LopDays=T1.LOPdays,T0.PHDays=T1.PHdays,T0.LveDays=T1.LveDays,T0.WODays=T1.WOdays,T0.OTHrs=T1.TotalOT
from #Temp_Payroll T0 inner join (Select T1.U_empid,sum(T1.U_OTHrs)[TotalOT],
sum((Case when isnull(T1.U_AttStatus,'') in ('LP') then (Case when isnull(T1.U_halfday,'')='Y' then 0.50 else 1.00 end) Else 0.00 end)+(Case when isnull(T1.U_halfday,'')='Y' and isnull(U_halfstatus,'')='LP' then 0.50 else 0.00 end))[LOPdays],
sum(Case when isnull(T1.U_AttStatus,'') in ('PH') then (Case when isnull(T1.U_halfday,'')='Y' then 0.50 else 1.00 end) Else 0.00 end)[PHdays],
sum(Case when isnull(T1.U_AttStatus,'') in ('WO') then (Case when isnull(T1.U_halfday,'')='Y' then 0.50 else 1.00 end) Else 0.00 end)[WOdays],
sum(Case when isnull(T1.U_AttStatus,'') not in ('PS','WO','PH','LP') then (Case when isnull(T1.U_halfday,'')='Y' then 0.50 else 1.00 end) Else 0.00 end)[LveDays],
sum((Case when isnull(T1.U_AttStatus,'') in ('PS') then (Case when isnull(T1.U_halfday,'')='Y' then 0.50 else 1.00 end) Else 0.00 end)+(Case when isnull(T1.U_halfday,'')='Y' and isnull(U_halfstatus,'')='PS' then 0.50 else 0.00 end))[Wdays],
sum((Case when isnull(T1.U_halfday,'')='Y' and isnull(U_halfstatus,'')='PS' then 0.50 else 0.00 end)+(Case when  isnull(T2.U_payable,'')='N' then 0.00 Else (Case when isnull(T1.U_halfday,'')='Y' then 0.50 else 1.00 end) end))[TWdays]
from [@SMPR_ODAS] T0 inner join [@SMPR_DAS1] T1 on T0.DocEntry=T1.DocEntry  left join [@SMPR_OLVE] T2 on T2.Code=T1.U_attstatus Where  T1.U_empid is not null and 
Convert(Date,T0.U_AttdDate) between @fromdate and @todate Group by T1.U_empid)T1 on T1.U_empID=T0.U_empID 

--Salary Details Fetching
Update T0 set T0.TotalSalary=T1.TotalSalary,T0.TotalBasic=T1.Basic,T0.TotalOT=T1.OTAmount*1.5 From #Temp_Payroll T0 inner join 
(Select Code,sum(U_amount)[TotalSalary],sum(case when U_PayElCod='Basic' then U_Amount else 0 end)[Basic],sum(case when isnull(U_OT,'')='Y' then U_Amount else 0 end)[OTAmount] from [@SMPR_HEM1] Group by Code)T1 on T0.Code=T1.code 

Update T0 set T0.[A1]=T1.[A1],T0.[A2]=T1.[A2],T0.[A3]=T1.[A3],T0.[A4]=T1.[A4],T0.[A5]=T1.[A5],T0.[A6]=T1.[A6],T0.[A7]=T1.[A7],T0.[A8]=T1.[A8],T0.[A9]=T1.[A9],T0.[A10]=T1.[A10],T0.[A11]=T1.[A11],T0.[A12]=T1.[A12],
T0.[A13]=T1.[A13],T0.[A14]=T1.[A14],T0.[A15]=T1.[A15],T0.[A16]=T1.[A16],T0.[A17]=T1.[A17],T0.[A18]=T1.[A18],T0.[A19]=T1.[A19],T0.[A20]=T1.[A20] From #Temp_Payroll T0 inner join 
(SELECT Code,isnull([A1],0)[A1],isnull([A2],0)[A2], isnull([A3],0)[A3], isnull([A4],0)[A4], isnull([A5],0)[A5], isnull([A6],0)[A6], isnull([A7],0)[A7], isnull([A8],0)[A8], isnull([A9],0)[A9], isnull([A10],0)[A10],
isnull( [A11],0)[A11], isnull([A12],0)[A12], isnull([A13],0)[A13], isnull([A14],0)[A14], isnull([A15],0)[A15], isnull([A16],0)[A16], isnull([A17],0)[A17], isnull([A18],0)[A18], isnull([A19],0)[A19], isnull([A20],0)[A20]
FROM  (SELECT T0.Code,T1.U_Sequence,isnull(T0.U_amount,0) AS Amount FROM [@SMPR_HEM1] T0 inner join [@SMPR_OPYE] T1 on T0.U_PayElCod=T1.code) AS A
PIVOT (SUm(Amount)  FOR U_Sequence IN ([A1],[A2], [A3], [A4], [A5], [A6], [A7], [A8], [A9], [A10], [A11], [A12], [A13], [A14], [A15], [A16], [A17], [A18], [A19], [A20])) AS PivotTable) T1 on T0.code=T1.code

--OTDays Calculation From OT Time & OT Perhour
Update #Temp_payroll set OTdays=Floor(OTHrs)+(((OTHrs-Floor(OTHrs))/60)*100),TotalOT_Perhour=((TotalOT*12/365)/8)

--OT & Gross Salary Calculation
Update #Temp_Payroll set OTAmt=Round((TotalOT_Perhour*OTdays),2),GrossSalary=Round(((PayableDays*(TotalSalary/TotalDays))+(TotalOT_Perhour*OTdays)),2),TotalAddition=0.00,TotalDeduction=0.00,
[A1]=Round((PayableDays*([A1]/TotalDays)),2),[A2]=Round((PayableDays*([A2]/TotalDays)),2),[A3]=Round((PayableDays*([A3]/TotalDays)),2),[A4]=Round((PayableDays*([A4]/TotalDays)),2),[A5]=Round((PayableDays*([A5]/TotalDays)),2),
[A6]=Round((PayableDays*([A6]/TotalDays)),2),[A7]=Round((PayableDays*([A7]/TotalDays)),2),[A8]=Round((PayableDays*([A8]/TotalDays)),2),[A9]=Round((PayableDays*([A9]/TotalDays)),2),[A10]=Round((PayableDays*([A10]/TotalDays)),2),
[A11]=Round((PayableDays*([A11]/TotalDays)),2),[A12]=Round((PayableDays*([A12]/TotalDays)),2),[A13]=Round((PayableDays*([A13]/TotalDays)),2),[A14]=Round((PayableDays*([A14]/TotalDays)),2),[A15]=Round((PayableDays*([A15]/TotalDays)),2),
[A16]=Round((PayableDays*([A16]/TotalDays)),2),[A17]=Round((PayableDays*([A17]/TotalDays)),2),[A18]=Round((PayableDays*([A18]/TotalDays)),2),[A19]=Round((PayableDays*([A19]/TotalDays)),2),[A20]=Round((PayableDays*([A20]/TotalDays)),2)

--Addition - Air Ticket Issue
Update T0 set T0.AirTicekt_Addition=T1.AirTicket,T0.TotalAddition=isnull(T0.TotalAddition,0)+isnull(T1.AirTicket ,0)
from #Temp_Payroll T0 inner join (Select U_empid,sum(U_Total)[AirTicket] from [@SMPR_OTIS] where isnull(U_Approved,'')='Y' and Canceled<>'Y' and isnull(Status,'O')='O' and isnull(U_payroll,'')='Y' 
and U_DocDate between @fromdate and @todate Group by U_empid)T1 on T0.U_empid=T1.U_empID 

--Addition & Deduction - Addition/Deduction Screen
Update T0 set  T0.[AB1]=T1.[AB1],T0.[AB2]=T1.[AB2],T0.[AB3]=T1.[AB3],T0.[AB4]=T1.[AB4],T0.[AB5]=T1.[AB5],T0.[AB6]=T1.[AB6],T0.[AB7]=T1.[AB7],T0.[AB8]=T1.[AB8],T0.[AB9]=T1.[AB9],T0.[AB10]=T1.[AB10],T0.[AB11]=T1.[AB11],T0.[AB12]=T1.[AB12],
T0.[AB13]=T1.[AB13],T0.[AB14]=T1.[AB14],T0.[AB15]=T1.[AB15],T0.[AB16]=T1.[AB16],T0.[AB17]=T1.[AB17],T0.[AB18]=T1.[AB18],T0.[AB19]=T1.[AB19],T0.[AB20]=T1.[AB20] from #Temp_Payroll T0 inner join  
(SELECT U_EmpID,isnull([AB1],0)[AB1],isnull([AB2],0)[AB2], isnull([AB3],0)[AB3], isnull([AB4],0)[AB4], isnull([AB5],0)[AB5], isnull([AB6],0)[AB6], isnull([AB7],0)[AB7], isnull([AB8],0)[AB8],isnull([AB9],0)[AB9], isnull([AB10],0)[AB10],
isnull( [AB11],0)[AB11], isnull([AB12],0)[AB12], isnull([AB13],0)[AB13], isnull([AB14],0)[AB14], isnull([AB15],0)[AB15], isnull([AB16],0)[AB16], isnull([AB17],0)[AB17], isnull([AB18],0)[AB18], isnull([AB19],0)[AB19], isnull([AB20],0)[AB20] 
FROM (select T1.U_EmpID,T2.U_Sequence,T1.U_amount Amount from [@SMPR_OPAD] T0 inner join [@SMPR_PAD1] T1 on T0.DocEntry=T1.DocEntry inner join [@SMPR_OPYE] T2 on T1.U_PayCode=T2.Code 
where U_PayPerid=@payperiod and T0.Canceled<>'Y' and isnull(T0.Status,'O')='O' and T1.U_Type='A') AS A
PIVOT (SUm(Amount)  FOR U_Sequence IN ([AB1],[AB2], [AB3], [AB4], [AB5], [AB6], [AB7], [AB8], [AB9], [AB10], [AB11], [AB12], [AB13], [AB14], [AB15], [AB16], [AB17], [AB18], [AB19], [AB20])) AS PivotTable)T1 on T0.U_empid=T1.U_EmpID

Update T0 set  T0.[DB1]=T1.[DB1],T0.[DB2]=T1.[DB2],T0.[DB3]=T1.[DB3],T0.[DB4]=T1.[DB4],T0.[DB5]=T1.[DB5],T0.[DB6]=T1.[DB6],T0.[DB7]=T1.[DB7],T0.[DB8]=T1.[DB8],T0.[DB9]=T1.[DB9],T0.[DB10]=T1.[DB10],T0.[DB11]=T1.[DB11],T0.[DB12]=T1.[DB12],
T0.[DB13]=T1.[DB13],T0.[DB14]=T1.[DB14],T0.[DB15]=T1.[DB15],T0.[DB16]=T1.[DB16],T0.[DB17]=T1.[DB17],T0.[DB18]=T1.[DB18],T0.[DB19]=T1.[DB19],T0.[DB20]=T1.[DB20] from #Temp_Payroll T0 inner join  
(SELECT U_EmpID,isnull([DB1],0)[DB1],isnull([DB2],0)[DB2], isnull([DB3],0)[DB3], isnull([DB4],0)[DB4], isnull([DB5],0)[DB5], isnull([DB6],0)[DB6], isnull([DB7],0)[DB7], isnull([DB8],0)[DB8], isnull([DB9],0)[DB9], isnull([DB10],0)[DB10],
isnull( [DB11],0)[DB11], isnull([DB12],0)[DB12], isnull([DB13],0)[DB13], isnull([DB14],0)[DB14], isnull([DB15],0)[DB15], isnull([DB16],0)[DB16], isnull([DB17],0)[DB17], isnull([DB18],0)[DB18], isnull([DB19],0)[DB19], isnull([DB20],0)[DB20]
FROM  (select T1.U_EmpID,T2.U_Sequence,T1.U_amount Amount from [@SMPR_OPAD] T0 inner join [@SMPR_PAD1] T1 on T0.DocEntry=T1.DocEntry inner join [@SMPR_OPYE] T2 on T1.U_PayCode=T2.Code 
where U_PayPerid=@payperiod and T0.Canceled<>'Y' and isnull(T0.Status,'O')='O' and T1.U_Type='D') AS A
PIVOT (SUm(Amount)  FOR U_Sequence IN ([DB1],[DB2], [DB3], [DB4], [DB5], [DB6], [DB7], [DB8], [DB9], [DB10], [DB11], [DB12], [DB13], [DB14], [DB15], [DB16], [DB17], [DB18], [DB19], [DB20])) AS PivotTable)T1 on T0.U_empid=T1.U_EmpID

Update T0 set T0.TotalAddition=isnull(T0.TotalAddition,0)+isnull([AB1],0)+isnull([AB2],0)+ isnull([AB3],0)+ isnull([AB4],0)+ isnull([AB5],0)+ isnull([AB6],0)+ isnull([AB7],0)+ isnull([AB8],0)+ isnull([AB9],0)+ isnull([AB10],0)+ isnull([AB11],0)+isnull([AB12],0)+
 isnull([AB13],0)+ isnull([AB14],0)+ isnull([AB15],0)+ isnull([AB16],0)+ isnull([AB17],0)+ isnull([AB18],0)+ isnull([AB19],0)+ isnull([AB20],0)
,T0.TotalDeduction=isnull([DB1],0)+isnull([DB2],0)+ isnull([DB3],0)+ isnull([DB4],0)+ isnull([DB5],0)+ isnull([DB6],0)+ isnull([DB7],0)+ isnull([DB8],0)+ isnull([DB9],0)+ isnull([DB10],0)+ isnull([DB11],0)+ isnull([DB12],0)+ isnull([DB13],0)+
 isnull([DB14],0)+ isnull([DB15],0)+ isnull([DB16],0)+ isnull([DB17],0)+ isnull([DB18],0)+ isnull([DB19],0)+ isnull([DB20],0) from #Temp_Payroll T0 

--Deduction - Loan Deduction From Loan Application for that particular month EMI
Update T0 set T0.LoanDeduction=T1.LoanDeduction,T0.TotalDeduction=T0.TotalDeduction+T1.LoanDeduction from #Temp_Payroll T0 inner join 
(Select T0.U_empid,sum(T1.U_Amount)[LoanDeduction] from [@SMPR_OLOA] T0 inner join [@SMPR_LOA1] T1 on T0.DocEntry=T1.DocEntry Where isnull(T0.U_Approved,'')='Y' and isnull(T0.Status,'')<>'C' and isnull(T0.Canceled,'')<>'Y' and 
T1.U_Date between @fromdate and @todate and isnull(T1.U_Status,'O')<>'C' and isnull(T1.U_dedsal,'')='Y' Group by T0.U_empid)T1 on T0.U_Empid=T1.U_empID

--Deduction - Annual Leave Salary Settleed in Settlment Screen
Update T0 set T0.AL_Settled_Deduction=(AL_Settled*(TotalSalary/TotalDays)),T0.TotalDeduction=T0.TotalDeduction+(AL_Settled*(TotalSalary/TotalDays)) from #Temp_Payroll T0 inner join 
(Select U_empid,sum(Datediff(dd,(Case when U_Fromdate<@fromdate then @fromdate else U_Fromdate end),(Case when U_Todate<@todate then U_todate else @todate end))+1)[AL_Settled]
from [@SMPR_OLVA] Where isnull(Canceled,'')<>'Y' and isnull(U_Approved,'')='Y' and isnull(U_lvecode,'')='AL' and isnull(U_Payable,'')<>'Y' 
and U_Todate>=@fromdate and U_FromDate<=@todate Group by U_empid) T1 on T0.U_empID=T1.U_empID 

--Deduction Advance Salary From settlement Screen
Update T0 set T0.AdvanceSal_Settlement_Deduction=T1.AdvsalAmount,T0.TotalDeduction=T0.TotalDeduction+AdvsalAmount from #Temp_Payroll T0 inner join 
(Select T0.U_empid,sum(T1.U_amount)AdvsalAmount from [@SMPR_OLSE] T0 inner join [@SMPR_LSE2] T1 on T0.DocEntry=T1.DocEntry 
Where isnull(T0.Canceled,'')='N' and isnull(T0.U_approved,'N')='Y' and U_Todate>=@fromdate and U_FromDate<=@todate --and (@fromdate between  U_fromdate and U_todate or @todate between  U_fromdate and U_todate)
 Group by T0.U_EmpID)T1 on T0.U_empID=T1.U_EmpID 

--Addition -Trip Allowance From Daily Trip Sheet
Update T0 set T0.TripAllowance_Addition=T1.TripAllowance,T0.TotalAddition=T0.TotalAddition+T1.TripAllowance from #Temp_Payroll T0 inner join 
(select T0.U_DriverName,sum(T1.U_TripAllowance)TripAllowance from [@SMVH_ODTS] T0 inner join [@SMVH_DTS1] T1 on T0.DocEntry=T1.DocEntry 
WHERE isnull(T0.Status ,'')='O' and T0.U_date between @fromdate and @todate Group by T0.U_DriverName)T1 on T0.EmpCode =T1.U_DriverName 

-- Addition & Deduction - Settlement Screen - Adjust in Payroll flag
Update T0 set  T0.[AB1]=T1.[AB1],T0.[AB2]=T1.[AB2],T0.[AB3]=T1.[AB3],T0.[AB4]=T1.[AB4],T0.[AB5]=T1.[AB5],T0.[AB6]=T1.[AB6],T0.[AB7]=T1.[AB7],T0.[AB8]=T1.[AB8],T0.[AB9]=T1.[AB9],T0.[AB10]=T1.[AB10],T0.[AB11]=T1.[AB11],T0.[AB12]=T1.[AB12],
T0.[AB13]=T1.[AB13],T0.[AB14]=T1.[AB14],T0.[AB15]=T1.[AB15],T0.[AB16]=T1.[AB16],T0.[AB17]=T1.[AB17],T0.[AB18]=T1.[AB18],T0.[AB19]=T1.[AB19],T0.[AB20]=T1.[AB20] from #Temp_Payroll T0 inner join  
(SELECT U_EmpID,isnull([AB1],0)[AB1],isnull([AB2],0)[AB2], isnull([AB3],0)[AB3], isnull([AB4],0)[AB4], isnull([AB5],0)[AB5], isnull([AB6],0)[AB6], isnull([AB7],0)[AB7], isnull([AB8],0)[AB8],isnull([AB9],0)[AB9], isnull([AB10],0)[AB10],
isnull( [AB11],0)[AB11], isnull([AB12],0)[AB12], isnull([AB13],0)[AB13], isnull([AB14],0)[AB14], isnull([AB15],0)[AB15], isnull([AB16],0)[AB16], isnull([AB17],0)[AB17], isnull([AB18],0)[AB18], isnull([AB19],0)[AB19], isnull([AB20],0)[AB20] 
FROM (select T0.U_empid,T2.U_Sequence,T1.U_amount Amount from [@SMPR_OLSE] T0 inner join [@SMPR_LSE4] T1 on T0.DocEntry=T1.DocEntry inner join [@SMPR_OPYE] T2 on T1.U_type=T2.Code 
where isnull(T0.Canceled,'')='N' and T1.U_mode='A' and isnull(T1.U_payroll,'N')='Y' and isnull(T0.U_approved,'N')='Y' and T1.U_paydate between  @fromdate and @todate) AS A
PIVOT (SUm(Amount)  FOR U_Sequence IN ([AB1],[AB2], [AB3], [AB4], [AB5], [AB6], [AB7], [AB8], [AB9], [AB10], [AB11], [AB12], [AB13], [AB14], [AB15], [AB16], [AB17], [AB18], [AB19], [AB20])) AS PivotTable)T1 on T0.U_empid=T1.U_EmpID

Update T0 set  T0.[DB1]=T1.[DB1],T0.[DB2]=T1.[DB2],T0.[DB3]=T1.[DB3],T0.[DB4]=T1.[DB4],T0.[DB5]=T1.[DB5],T0.[DB6]=T1.[DB6],T0.[DB7]=T1.[DB7],T0.[DB8]=T1.[DB8],T0.[DB9]=T1.[DB9],T0.[DB10]=T1.[DB10],T0.[DB11]=T1.[DB11],T0.[DB12]=T1.[DB12],
T0.[DB13]=T1.[DB13],T0.[DB14]=T1.[DB14],T0.[DB15]=T1.[DB15],T0.[DB16]=T1.[DB16],T0.[DB17]=T1.[DB17],T0.[DB18]=T1.[DB18],T0.[DB19]=T1.[DB19],T0.[DB20]=T1.[DB20] from #Temp_Payroll T0 inner join  
(SELECT U_EmpID,isnull([DB1],0)[DB1],isnull([DB2],0)[DB2], isnull([DB3],0)[DB3], isnull([DB4],0)[DB4], isnull([DB5],0)[DB5], isnull([DB6],0)[DB6], isnull([DB7],0)[DB7], isnull([DB8],0)[DB8], isnull([DB9],0)[DB9], isnull([DB10],0)[DB10],
isnull( [DB11],0)[DB11], isnull([DB12],0)[DB12], isnull([DB13],0)[DB13], isnull([DB14],0)[DB14], isnull([DB15],0)[DB15], isnull([DB16],0)[DB16], isnull([DB17],0)[DB17], isnull([DB18],0)[DB18], isnull([DB19],0)[DB19], isnull([DB20],0)[DB20]
FROM  (select T0.U_empid,T2.U_Sequence,T1.U_amount Amount from [@SMPR_OLSE] T0 inner join [@SMPR_LSE4] T1 on T0.DocEntry=T1.DocEntry inner join [@SMPR_OPYE] T2 on T1.U_type=T2.Code 
where isnull(T0.Canceled,'')='N' and T1.U_mode='D' and isnull(T1.U_payroll,'N')='Y' and isnull(T0.U_approved,'N')='Y' and T1.U_paydate between  @fromdate and @todate) AS A
PIVOT (SUm(Amount)  FOR U_Sequence IN ([DB1],[DB2], [DB3], [DB4], [DB5], [DB6], [DB7], [DB8], [DB9], [DB10], [DB11], [DB12], [DB13], [DB14], [DB15], [DB16], [DB17], [DB18], [DB19], [DB20])) AS PivotTable)T1 on T0.U_empid=T1.U_EmpID

--Net Salary Calculation
Update #Temp_Payroll set NetSalaryB4_Round=GrossSalary +TotalAddition -TotalDeduction 
Update #Temp_Payroll set ROundoff=Round(NetSalaryB4_Round,0)-NetSalaryB4_Round,NetSalary=Round(NetSalaryB4_Round,0)
--Final Query

Select * from #Temp_Payroll order by empcode--where EMPcode='TRZ135'

if object_ID('tempdb..#Temp_payroll') IS NOT NULL Drop table #Temp_Payroll 

End

--[Innova_HRMS_PayrollProcess]'#3#4#5#12#','FY2018-09',1,58