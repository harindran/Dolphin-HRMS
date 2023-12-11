-------Default Series--------------------------------------------------------------------
if exists(select 1 from sys.procedures where name='Innova_GetDefaultSeries') Drop Procedure Innova_GetDefaultSeries
Go
Create Procedure [dbo].[Innova_GetDefaultSeries](@objectcode varchar(10),@userid varchar(100),@Date datetime)
as
Begin

	Declare @dftseris as varchar(100),@indicator as varchar(100),@groupid varchar(100)

	select @indicator=Indicator from OFPR where @Date between F_RefDate and T_RefDate 

	select @dftseris=isnull(T1.Series,T0.DfltSeries) from onnm T0 left join (select objectcode,Series from nnm2 T0 inner join OUSR T1 on T0.UserSign=T1.USERID where T0.ObjectCode=@objectcode and T1.USER_CODE=@userid) T1
	on T0.ObjectCode=T1.ObjectCode  where T0.objectcode=@objectcode 


	Select @groupid=Groupcode,@dftseris=(Case when Indicator=@indicator then @dftseris else '-1' end) from nnm1 where ObjectCode=@objectcode and Series=@dftseris

	if @dftseris='-1' Begin set @dftseris=(Select Top 1 series from nnm1 where objectcode=@objectcode and GroupCode=@groupid and Indicator=@indicator) End

	Select Series,SeriesName,@dftseris [dflt] from nnm1 where ObjectCode=@objectcode and Indicator=@indicator --and Groupcode=@groupid 

End

