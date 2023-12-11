CREATE proc [dbo].[@SMS_SP_Employee-wise_End_of_Service]  (@asonDate as date)            
as            
begin          
          
--Declare @asonDate as date          
Declare @LeaveCalculationStartdate as date          
set @LeaveCalculationStartdate='20170101'          
--set @asonDate='20180220'          
          
;with salarydetails as (select code,Sum(Case when U_PayElCod='Basic' then U_Amount else 0 end) [Basic],Sum(Case when U_PayElCod<>'Basic' then U_Amount else 0 end) [Allowance] from [@SMPR_HEM1] group by code),          
          
employee_workingdays as (Select T0.U_empID empID,convert(Date,isnull(U_termDate,@asondate))[Termination Date] ,convert(Date,U_startdte) 'Joining Dt',Convert(Date,@asondate) 'Report Dt',ISNULL(DATEDIFF(DAY,T0.U_startdte,CONVERT(DATETIME,@asondate,112)),1) 
 
      
 'Total Working Days',Round((cast((ISNULL(DATEDIFF(DAY,T0.U_startdte,CONVERT(DATETIME,@asondate ,112)),1))as float)/cast(30.4167 as float)/cast(12 as float)),6) [Year]          
from [@SMPR_OHEM] T0),          
          
GradutiyDetails as (Select empID,[Joining Dt],[Report Dt],[Total Working Days],Year[Gratuity Years],case when T0.[year] < 5 then Convert(int,T0.[Year]) else 5 end 'Grad @21 (Years)',          
case when T0.[year] < 5 then (T0.[Year] - Convert(int,T0.[Year])) else 0 end 'Grad @21 (Days)',case when T0.[year] > 5 then Convert(int,T0.[Year])- 5 else 0 end 'Grad @30 (Years)',          
case when T0.[year] > 5 then (T0.[Year] - Convert(int,T0.[Year]))  else 0 end 'Grad @30 (Days)'  from employee_workingdays T0),          
          
--LastAirticketbookedDate as (Select T2.Empid,isnull(T1.ocrcode3,'')[InnovaID],Max(T0.refdate)[Last AirTicket Booked Date] from OJDT T0 inner join JDT1 T1 on T0.transid=T1.Transid           
--inner join ohem T2 on T2.ExtEmpNo=isnull(T1.ocrcode3,'') where T1.Account='20221002' and isnull(T1.ocrcode3,'')<>'' and (T1.debit-T1.credit)>0 Group by isnull(T1.ocrcode3,''),T2.empid),          
--LastAirticketbookedAmount as (Select T2.Empid,isnull(T1.ocrcode3,'')[InnovaID],Max(T1.Debit-T1.credit)[Last AirTicket Booked Amount] from OJDT T0 inner join JDT1 T1 on T0.transid=T1.Transid           
--inner join LastAirticketbookedDate T2 on T2.InnovaID=isnull(T1.ocrcode3,'') and T0.refdate=T2.[Last AirTicket Booked Date] where T1.Account='20221002' and isnull(T1.ocrcode3,'')<>'' and (T1.debit-T1.credit)>0 Group by isnull(T1.ocrcode3,''),T2.empid),  
  
    
            
          
LOP_airticket as (select A.U_empID ,count(*)[LOP]  from [@Smpr_das1] A Inner Join [@SMPR_ODAS] B on A.DocEntry =B.DocEntry inner join [@SMPR_OHEM] C on C.U_empID=A.U_empID  where A.U_AttStatus in ('LP')          
and B.U_AttdDate between  isnull(C.U_airlstdt,C.U_startdte) AND @asondate group by A.U_empID),          
          
AirTicketIssued_MaxDate as (select U_empid,max(U_tickdate)[ClaimedDate] from [@SMPR_OTIS] where isnull(U_approved,'')='Y' and isnull(Canceled,'')<>'Y' and U_DocDate<=@asondate Group by U_empid),          
AirTicket_LastClaimDate as (Select T0.U_empID ,isnull(T1.ClaimedDate,Isnull(T0.U_airlstdt,T0.U_startdte))[LastClaimDate] from [@SMPR_OHEM] T0 left join AirTicketIssued_MaxDate T1 on T0.U_empid=T1.U_empid),          
          
AirticketDetails as (Select T0.U_empID[EMPID],T0.U_ExtEmpNo,isnull(T1.U_tcktpryr,0)[Eligible Airticket Years],          
isnull(T1.U_eligiamt,0)[Eligible Air Ticket],T0.U_startdte [U_startdte] ,T2.LastClaimDate [Last AirTicket Booked Date],1+datediff(dd,T2.LastClaimDate,@asondate)-isnull(T4.LOP,0) [Current Year Days],          
(Case when isnull(T1.U_tcktpryr,1)=0 then 0 else Round((1+datediff(dd,T2.LastClaimDate,@asondate)-isnull(T4.LOP,0))*(isnull(T1.U_eligiamt,0)/(isnull(T1.U_tcktpryr,1)*365)),0) end)[Accrued Air Ticket_CurrentPeriod]          
 from [@SMPR_OHEM] T0  left join [@SMPR_HEM10] T1 on T0.code=T1.code and @asondate between T1.U_fromdate and isnull(T1.U_todate,@asondate)           
left join AirTicket_LastClaimDate T2 on T2.U_empID=T0.U_empid left join (select U_empid,(case when LOP<=30 then 0 else LOP end)LOP from LOP_airticket) T4 on T4.U_empID=T0.U_empid),          
      
leavetaken as (select A.U_empID,count(*)[LeaveTaken],sum(Case when B.U_AttdDate>='20180101' then 0 else 1 end)[AL_TOBE_Deducted]  from [@Smpr_das1] A Inner Join [@SMPR_ODAS] B on A.DocEntry =B.DocEntry  where A.U_AttStatus in ('AL') and          
 B.U_AttdDate between @LeaveCalculationStartdate and @asondate group by A.U_empID),         
        
LOP as (select A.U_empID ,count(*)[LOP]  from [@Smpr_das1] A Inner Join [@SMPR_ODAS] B on A.DocEntry =B.DocEntry  where A.U_AttStatus in ('LP') and B.U_AttdDate between  @LeaveCalculationStartdate AND @asondate group by A.U_empID),          
          
--Leave_encash as (select T0.U_empid[EMpid],sum((case when T0.U_LveSettDate<=@LeaveCalculationStartdate  then isnull(T0.U_apprdays,0)-isnull(T1.U_nodaylve,0) else 0 end))[encashdays_OB],          
--sum((case when T0.U_LveSettDate between @LeaveCalculationStartdate and @asondate then isnull(T0.U_apprdays,0)-isnull(T1.U_nodaylve,0) else 0 end))[encashdays]          
--from [@SMPR_OLSE] t0 left join [@SMPR_OLVA] T1 on T0.U_LveAppNo=T1.DocNum and T0.U_empid=T1.U_empID  and T1.U_lvecode='AL' where T0.U_LveSettDate between @LeaveCalculationStartdate and @asondate--T0.U_LveSettDate>=@LeaveCalculationStartdate           
--group by T0.U_empid),          
          
Leave_encash as (select T0.U_empid[EMpid],--sum((case when T0.U_LveSettDate<=@LeaveCalculationStartdate  then isnull(T0.U_lvncshdy,0) else 0 end))  
0 [encashdays_OB],sum((case when T0.U_LveSettDate between @LeaveCalculationStartdate and @asondate then isnull(T0.U_lvncshdy,0) else 0 end))[encashdays]          
from [@SMPR_OLSE] t0 where T0.U_approved='Y' and  T0.U_LveSettDate <=@asondate--T0.U_LveSettDate>=@LeaveCalculationStartdate           
group by T0.U_empid),          
      
AnnualLeave as (select distinct U_empid,'AL' [Type],T1.U_DOJAfterLveDate[AL_OBDate],T1.U_DOJAfterLveBal [AL_OBDays] from [@SMPR_OHEM] T0 inner join   [@SMPR_HEM2] T1 on T0.code=T1.code where T1.U_LveCode='AL'),          
          
LeaveCalculation as (Select T0.U_empID,T0.U_ExtEmpNo,t1.Location ,ISNULL(T5.AL_OBDays,0)[OBDAYS_INITIAL],ISNULL(T5.AL_OBDate,T0.U_startdte)[LEAVESTARTDATE],          
((CASE WHEN ISNULL(T5.AL_OBDate,'20000101')>@LeaveCalculationStartdate THEN 0 ELSE ISNULL(T5.AL_OBDays,0) END)-isnull(T4.encashdays_OB,0)+          
ROUND(((case when ISNULL(T5.AL_OBDate,T0.U_startdte)<@LeaveCalculationStartdate then  DATEDIFF(DD,ISNULL(T5.AL_OBDate,T0.U_startdte),@LeaveCalculationStartdate) else 0 end)-          
(select count(*)  from [@Smpr_das1] A Inner Join [@SMPR_ODAS] B on A.DocEntry =B.DocEntry  where A.U_empID = T0.U_EMPID and A.U_AttStatus in ('LP','AL')          
and B.U_AttdDate between ISNULL(T5.AL_OBDate,T0.U_startdte) and dateADD(dd,-1,@LeaveCalculationStartdate)))*(30.00/365.00),2)-          
(select count(*)  from [@Smpr_das1] A Inner Join [@SMPR_ODAS] B on A.DocEntry =B.DocEntry  where A.U_empID = T0.U_EMPID and A.U_AttStatus in ('AL') and B.U_AttdDate between ISNULL(T5.AL_OBDate,T0.U_startdte) and           
dateADD(dd,-1,@LeaveCalculationStartdate))) [OB],          
(Case when isnull(T5.type,'')='AL' then ROUND((((DATEDIFF(DD,(Case when @LeaveCalculationStartdate>ISNULL(T5.AL_OBDate,T0.U_startdte) then @LeaveCalculationStartdate else ISNULL(T5.AL_OBDate,T0.U_startdte)end),@asondate)+1)-          
--isnull(T2.[LeaveTaken],0)-isnull(T3.[LOP],0))*(30.00/365.00)),2) else 0 End) [LEAVE ACCRUED],isnull(T2.[LeaveTaken],0) [LEAVE TAKEN],isnull(T3.[LOP],0)[LOP],isnull(T4.encashdays,0)[Encashdays]          
isnull(T2.AL_TOBE_Deducted,0)-isnull(T3.[LOP],0))*(30.00/365.00)),2) else 0 End) [LEAVE ACCRUED],isnull(T2.[LeaveTaken],0) [LEAVE TAKEN],isnull(T3.[LOP],0)[LOP],isnull(T4.encashdays,0)[Encashdays]          
 from [@SMPR_OHEM] T0 left join olct t1 on t0.U_Location=t1.code  left join leavetaken T2 on T2.U_empID=T0.U_empID left join LOP T3 on T3.U_empID=T0.U_empid  left join leave_encash T4 on T4.empid=T0.U_EMPID           
 Inner join AnnualLeave T5 on T5.U_empID=T0.U_empid          
 where  t0.U_Location in (4,3,5,28)  and ISNULL(T5.AL_OBDate,T0.U_startdte)<@asondate)--T0.status='1' and          
          
Select T0.U_empid[SAP ID],T0.U_ExtEmpNo [Innova Employee ID],Replace(isnull(U_firstNam,'')+' '+isnull(U_lastName,''),'  ',' ') 'Emp Name',isnull(T0.U_visaspon,'') 'Visa Sponsor',T6.Location,T3.[Joining Dt],T3.[Report Dt],--,T7.Descr [Emp Group]    
T3.[Total Working Days],T3.[Gratuity Years],T3.[Grad @21 (Days)],T3.[Grad @21 (Years)],T3.[Grad @30 (Days)],T3.[Grad @30 (Years)] ,          
Round(isnull((((cast(T2.Basic as float) * Cast(12 as float))/cast(365 as float))*21 *(T3.[Grad @21 (Years)] + T3.[Grad @21 (Days)]))           
+ (((cast(T2.Basic as float) * Cast(12 as float))/cast(365 as float))*30 * (T3.[Grad @30 (Years)] + T3.[Grad @30 (Days)])),0),6) 'Gratuity Amount',          
isnull(T2.Basic,0)[Basic],isnull(T2.Allowance,0)[Allowance],isnull(T2.Basic,0)+isnull(T2.Allowance,0)[Gross Salary],          
T4.[Eligible Airticket Years],T4.[Eligible Air Ticket],T4.[Last AirTicket Booked Date],T4.[Current Year Days],          
T4.[Accrued Air Ticket_CurrentPeriod] [Accrued Air Ticket_CurrentPeriod],          
isnull(T5.OB,0.00) [Leave Opening Balance],isnull(T5.[LEAVE ACCRUED],0.00)[LEAVE ACCRUED],isnull(T5.[LEAVE TAKEN],0.00)[LEAVE TAKEN],isnull(T5.Encashdays,0.00)[Leave Encashed Days],isnull(T5.LOP,0.00)[Leave Loss of Pay],          
isnull((T5.OB+T5.[LEAVE ACCRUED]-T5.[LEAVE TAKEN]-T5.[Encashdays]),0.00)[Leave Balance Days],isnull(Round(((T5.OB+T5.[LEAVE ACCRUED]-T5.[LEAVE TAKEN]-T5.[Encashdays])*((isnull(T2.Basic,0)+isnull(T2.Allowance,0))/30)),2),0.00)[Leave Balance Amount]        
  
from [@SMPR_OHEM] T0 left join salarydetails T2 on T2.code=T0.U_empid left join GradutiyDetails T3 on T3.empID=T0.U_empid           
left join AirticketDetails T4 on T4.empid=T0.U_empid left join LeaveCalculation T5 on T5.U_empID=T0.U_empID inner join olct t6 on t0.U_Location=t6.code         
  left join (select fldvalue,Descr  from ufd1 where TableID='@SMPR_OHEM' and FieldID='4') T7 on T0.U_gropcode=T7.fldvalue        
where t0.U_Location in (3,4,5,28) --and T0.U_status in ('1') -- and T0.empid=178          
and T3.[Joining Dt]<=@asondate and isnull(T0.U_termdate,dateadd(dd,1,@asondate))>@asondate order by T0.U_ExtEmpNo          
          
End          
          
  
--[@SMS_SP_Employee-wise_End_of_Service] '20181130'  