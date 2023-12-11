Option Strict Off
Option Explicit On

Imports SAPbouiCOM.Framework

Namespace HRMS
    <FormAttribute("OPRC", "Transcation/frmPayrollProcess.b1f")>
    Friend Class frmPayrollProcess
        Inherits UserFormBase
        Public WithEvents objform As SAPbouiCOM.Form
        Dim FormCount As Integer = 0
        Dim strsql As String
        Dim objrs As SAPbobsCOM.Recordset
        Private WithEvents odbdsDetails As SAPbouiCOM.DBDataSource
        Public WithEvents cmbdesignation, cmbdepartment As SAPbouiCOM.Column, cmbpaymode As SAPbouiCOM.Column
        Dim addupdate As Boolean = False
        Dim lastrowid As Integer = 1

        Public Sub New()
            Try

            Catch ex As Exception

            End Try
        End Sub

        Public Overrides Sub OnInitializeComponent()
            Me.Button0 = CType(Me.GetItem("1").Specific, SAPbouiCOM.Button)
            Me.Button1 = CType(Me.GetItem("2").Specific, SAPbouiCOM.Button)
            Me.StaticText0 = CType(Me.GetItem("lblpay").Specific, SAPbouiCOM.StaticText)
            Me.ComboBox0 = CType(Me.GetItem("cmbpay").Specific, SAPbouiCOM.ComboBox)
            Me.StaticText1 = CType(Me.GetItem("lblfrom").Specific, SAPbouiCOM.StaticText)
            Me.EditText1 = CType(Me.GetItem("txtfrom").Specific, SAPbouiCOM.EditText)
            Me.StaticText2 = CType(Me.GetItem("lblto").Specific, SAPbouiCOM.StaticText)
            Me.EditText2 = CType(Me.GetItem("txtto").Specific, SAPbouiCOM.EditText)
            Me.StaticText4 = CType(Me.GetItem("Item_12").Specific, SAPbouiCOM.StaticText)
            Me.ComboBox2 = CType(Me.GetItem("cmbesta").Specific, SAPbouiCOM.ComboBox)
            Me.Matrix0 = CType(Me.GetItem("Item_14").Specific, SAPbouiCOM.Matrix)
            Me.ComboBox1 = CType(Me.GetItem("cmbseries").Specific, SAPbouiCOM.ComboBox)
            Me.Button2 = CType(Me.GetItem("btnpay").Specific, SAPbouiCOM.Button)
            Me.EditText0 = CType(Me.GetItem("txtdocno").Specific, SAPbouiCOM.EditText)
            Me.CheckBox0 = CType(Me.GetItem("chkfinal").Specific, SAPbouiCOM.CheckBox)
            Me.StaticText5 = CType(Me.GetItem("Item_6").Specific, SAPbouiCOM.StaticText)
            Me.EditText3 = CType(Me.GetItem("txtlocc").Specific, SAPbouiCOM.EditText)
            Me.EditText4 = CType(Me.GetItem("txtlocn").Specific, SAPbouiCOM.EditText)
            Me.EditText5 = CType(Me.GetItem("txtdate").Specific, SAPbouiCOM.EditText)
            Me.LinkedButton1 = CType(Me.GetItem("lnkloc").Specific, SAPbouiCOM.LinkedButton)
            Me.CheckBox1 = CType(Me.GetItem("chkpay").Specific, SAPbouiCOM.CheckBox)
            Me.OnCustomInitialize()

        End Sub

        Public Overrides Sub OnInitializeFormEvents()
            'AddHandler DataLoadAfter, AddressOf Me.frmPayrollProcess_DataLoadAfter
            'AddHandler ResizeAfter, AddressOf Me.frmPayrollProcess_ResizeAfter
            'AddHandler DataLoadAfter, AddressOf Me.frmPayrollProcess_DataLoadAfter
            'AddHandler ResizeAfter, AddressOf Me.frmPayrollProcess_ResizeAfter
            'AddHandler DataLoadAfter, AddressOf Me.frmPayrollProcess_DataLoadAfter
            'AddHandler ResizeAfter, AddressOf Me.frmPayrollProcess_ResizeAfter
            'AddHandler DataLoadAfter, AddressOf Me.frmPayrollProcess_DataLoadAfter
            'AddHandler ResizeAfter, AddressOf Me.frmPayrollProcess_ResizeAfter

        End Sub

        Private Sub OnCustomInitialize()
            objform = objaddon.objapplication.Forms.GetForm("OPRC", FormCount)
            objform = objaddon.objapplication.Forms.ActiveForm

            Try
                objform.Freeze(True)
                odbdsDetails = objform.DataSources.DBDataSources.Item(CType(1, Object))
                cmbdesignation = Matrix0.Columns.Item("desig")
                cmbdepartment = Matrix0.Columns.Item("dept")
                cmbpaymode = Matrix0.Columns.Item("paymode")

                Comboload()
                ManageAttributes()
                If Link_objtype.ToString.ToUpper = "OPRC" And Link_Value.ToString <> "" Then
                    objform.Mode = SAPbouiCOM.BoFormMode.fm_FIND_MODE
                    objform.Items.Item("txtentry").Enabled = True
                    objform.Items.Item("txtentry").Specific.string = Link_Value
                    Button0.Item.Click(SAPbouiCOM.BoCellClickType.ct_Regular)
                    objform.Items.Item("txtentry").Enabled = False
                    Link_objtype = "-1" : Link_Value = "-1"
                    Matrix_Field_Setup()
                Else
                    objform.Items.Item("txtdate").Specific.string = Now.Date.ToString("dd.MM.yyyy")
                    CheckBox0.Item.Height = CheckBox0.Item.Height + 3
                    CheckBox1.Item.Height = CheckBox1.Item.Height + 3
                    CheckBox1.Item.Width = CheckBox1.Item.Width + 10
                    EditText3.Value = "#"
                    objform.Items.Item("txtentry").Specific.string = objaddon.objglobalmethods.GetNextDocentry_Value("[@SMPR_OPRC]")
                    ComboBox2.Select("1", SAPbouiCOM.BoSearchKey.psk_ByValue)
                    objform.ActiveItem = "cmbpay"
                End If

                objform.EnableMenu("1283", False) 'Remove
                objform.EnableMenu("1284", False) 'Cancel
                objform.EnableMenu("1286", False) 'close
                If objaddon.objcompany.UserName.ToString.ToUpper <> "MANAGER" Then objform.EnableMenu("6913", False) 'User Defined Field

                objform.Freeze(False)
            Catch ex As Exception
                objform.Freeze(False)
            End Try
        End Sub

        Private Sub ManageAttributes()
            Try
                objaddon.objglobalmethods.SetAutomanagedattribute_Editable(objform, "cmbpay", True, True, False)
                objaddon.objglobalmethods.SetAutomanagedattribute_Editable(objform, "txtfrom", False, True, False)
                objaddon.objglobalmethods.SetAutomanagedattribute_Editable(objform, "txtto", False, True, False)
                objaddon.objglobalmethods.SetAutomanagedattribute_Editable(objform, "cmbesta", True, True, False)
                objaddon.objglobalmethods.SetAutomanagedattribute_Editable(objform, "cmbseries", True, True, False)
                objaddon.objglobalmethods.SetAutomanagedattribute_Editable(objform, "txtdocno", False, True, False)
                objaddon.objglobalmethods.SetAutomanagedattribute_Editable(objform, "txtdate", True, True, False)

                objaddon.objglobalmethods.SetAutomanagedattribute_Visible(objform, "lnkloc", True, False, False)
                CheckBox0.Item.Enabled = True
                CheckBox1.Item.Enabled = False
            Catch ex As Exception

            End Try
        End Sub

        Private Sub Comboload()
            Try
                objrs = objaddon.objcompany.GetBusinessObject(SAPbobsCOM.BoObjectTypes.BoRecordset)
                objrs.DoQuery("EXEC [Innova_HRMS_EMPMASTER_COMBO_FILLING] 'OPRC'")
                If objrs.RecordCount = 0 Then Exit Sub
                For i As Integer = 0 To objrs.RecordCount - 1
                    Try
                        Select Case objrs.Fields.Item("Type").Value.ToString.ToUpper
                            Case "PAYPERIOD" : ComboBox0.ValidValues.Add(objrs.Fields.Item("Code").Value, objrs.Fields.Item("Name").Value)
                            Case "STATUS" : ComboBox2.ValidValues.Add(objrs.Fields.Item("Code").Value, objrs.Fields.Item("Name").Value)
                            Case "POSITION" : cmbdesignation.ValidValues.Add(objrs.Fields.Item("Code").Value, objrs.Fields.Item("Name").Value)
                            Case "DEPARTMENT" : cmbdepartment.ValidValues.Add(objrs.Fields.Item("Code").Value, objrs.Fields.Item("Name").Value)
                            Case "PAYMODE" : cmbpaymode.ValidValues.Add(objrs.Fields.Item("Code").Value, objrs.Fields.Item("Name").Value)
                        End Select
                        objrs.MoveNext()
                    Catch ex As Exception
                        objrs.MoveNext()
                    End Try
                Next
            Catch ex As Exception

            End Try
        End Sub

#Region "Field Details"

        Private WithEvents Button0 As SAPbouiCOM.Button
        Private WithEvents Button1 As SAPbouiCOM.Button
        Private WithEvents StaticText0 As SAPbouiCOM.StaticText
        Private WithEvents ComboBox0 As SAPbouiCOM.ComboBox
        Private WithEvents StaticText1 As SAPbouiCOM.StaticText
        Private WithEvents EditText1 As SAPbouiCOM.EditText
        Private WithEvents StaticText2 As SAPbouiCOM.StaticText
        Private WithEvents EditText2 As SAPbouiCOM.EditText
        Private WithEvents StaticText4 As SAPbouiCOM.StaticText
        Private WithEvents ComboBox2 As SAPbouiCOM.ComboBox
        Private WithEvents Matrix0 As SAPbouiCOM.Matrix
        Private WithEvents ComboBox1 As SAPbouiCOM.ComboBox
        Private WithEvents Button2 As SAPbouiCOM.Button
        Private WithEvents EditText0 As SAPbouiCOM.EditText
        Private WithEvents CheckBox0 As SAPbouiCOM.CheckBox
        Private WithEvents StaticText5 As SAPbouiCOM.StaticText
        Private WithEvents EditText3 As SAPbouiCOM.EditText
        Private WithEvents EditText4 As SAPbouiCOM.EditText
        Private WithEvents EditText5 As SAPbouiCOM.EditText
        Private WithEvents LinkedButton1 As SAPbouiCOM.LinkedButton
        Private WithEvents CheckBox1 As SAPbouiCOM.CheckBox
#End Region

#Region "Form Events"

        Private Sub frmPayrollProcess_DataLoadAfter(ByRef pVal As SAPbouiCOM.BusinessObjectInfo) Handles Me.DataLoadAfter
            Try
                If CheckBox0.Checked = True Then
                    CheckBox0.Item.Enabled = False
                    If CheckBox1.Checked = True Then CheckBox1.Item.Enabled = False Else CheckBox1.Item.Enabled = True
                Else
                    CheckBox0.Item.Enabled = True
                    CheckBox1.Item.Enabled = False
                End If

                objaddon.objglobalmethods.LoadCombo_SingleSeries_AfterFind(objform, "cmbseries", "OPRC", ComboBox1.Value)
                Matrix_Field_Setup()

            Catch ex As Exception

            End Try
        End Sub

        Private Sub frmPayrollProcess_ResizeAfter(pVal As SAPbouiCOM.SBOItemEventArg) Handles Me.ResizeAfter
            Try
                objform = objaddon.objapplication.Forms.GetForm("OPRC", FormCount)
                objform.Freeze(True)
                objaddon.objapplication.Menus.Item("1300").Activate()
                objform.Freeze(False)
            Catch ex As Exception
                objform.Freeze(False)
            End Try
        End Sub

#End Region

        Private Sub ComboBox1_ComboSelectAfter(sboObject As System.Object, pVal As SAPbouiCOM.SBOItemEventArg) Handles ComboBox1.ComboSelectAfter
            If objform.Mode <> SAPbouiCOM.BoFormMode.fm_ADD_MODE Then Exit Sub
            If ComboBox1.Selected Is Nothing Then Exit Sub
            objrs = objaddon.objcompany.GetBusinessObject(SAPbobsCOM.BoObjectTypes.BoRecordset)
            objrs.DoQuery("Select nextnumber from Nnm1 where objectcode='OPRC' and series='" & ComboBox1.Selected.Value & "'")
            If objrs.RecordCount > 0 Then
                EditText0.Value = objrs.Fields.Item(0).Value
            End If
        End Sub

        Private Sub ComboBox0_ClickAfter(sboObject As System.Object, pVal As SAPbouiCOM.SBOItemEventArg) Handles ComboBox0.ClickAfter
            Try
                If objform.Mode <> SAPbouiCOM.BoFormMode.fm_ADD_MODE Then Exit Sub
                If ComboBox0.Selected Is Nothing Then Exit Sub
                objrs = objaddon.objcompany.GetBusinessObject(SAPbobsCOM.BoObjectTypes.BoRecordset)
                objrs.DoQuery("select Replace(convert(varchar,F_Refdate,103),'/','.')F_Refdate,Replace(convert(varchar,T_RefDate,103),'/','.')T_RefDate from OFPR where Code='" & ComboBox0.Selected.Value & "'")
                If objrs.RecordCount > 0 Then
                    objform.Items.Item("txtfrom").Specific.string = objrs.Fields.Item("F_Refdate").Value
                    objform.Items.Item("txtto").Specific.string = objrs.Fields.Item("T_RefDate").Value
                End If
            Catch ex As Exception

            End Try
        End Sub

        Private Sub Button2_ClickBefore(sboObject As System.Object, pVal As SAPbouiCOM.SBOItemEventArg, ByRef BubbleEvent As System.Boolean) Handles Button2.ClickBefore
            If objform.Mode = SAPbouiCOM.BoFormMode.fm_OK_MODE Or objform.Mode = SAPbouiCOM.BoFormMode.fm_UPDATE_MODE Then Exit Sub
            If ComboBox0.Selected Is Nothing Then
                objaddon.objapplication.SetStatusBarMessage("Pay period is Missing", SAPbouiCOM.BoMessageTime.bmt_Short, True)
                BubbleEvent = False
                Exit Sub
            End If
            If ComboBox2.Selected Is Nothing Then
                objaddon.objapplication.SetStatusBarMessage("Employee Status is Missing", SAPbouiCOM.BoMessageTime.bmt_Short, True)
                BubbleEvent = False
                Exit Sub
            End If
            If EditText3.Value = "#" Then
                objaddon.objapplication.SetStatusBarMessage("Location is Missing", SAPbouiCOM.BoMessageTime.bmt_Short, True)
                BubbleEvent = False
                Exit Sub
            End If

        End Sub

        Private Sub Button2_ClickAfter(sboObject As System.Object, pVal As SAPbouiCOM.SBOItemEventArg) Handles Button2.ClickAfter
            Try
                If CheckBox0.Checked = True Then
                    objaddon.objapplication.SetStatusBarMessage("Payroll Already Finalized.", SAPbouiCOM.BoMessageTime.bmt_Short, True)
                    Exit Sub
                End If

                objaddon.objapplication.SetStatusBarMessage("Calculating Payroll Details. Please Wait...", SAPbouiCOM.BoMessageTime.bmt_Long, False)
                objform.Freeze(True)

                odbdsDetails.Clear()
                Matrix0.LoadFromDataSource()

                strsql = "EXEC [Innova_HRMS_PayrollProcess] '" & EditText3.Value.ToString & "','" & ComboBox0.Selected.Value & "','" & ComboBox2.Selected.Value & "','" & objform.Items.Item("txtentry").Specific.string & "'"
                objrs = objaddon.objcompany.GetBusinessObject(SAPbobsCOM.BoObjectTypes.BoRecordset)
                objrs.DoQuery(strsql)

                If objrs.RecordCount = 0 Then objaddon.objapplication.SetStatusBarMessage("No records Found", SAPbouiCOM.BoMessageTime.bmt_Short, True) : objform.Freeze(False) : Exit Sub

                odbdsDetails.InsertRecord(odbdsDetails.Size)

                objaddon.objapplication.SetStatusBarMessage("Filling Payroll Details. Please Wait...", SAPbouiCOM.BoMessageTime.bmt_Long, False)

                For i As Integer = 0 To objrs.RecordCount - 1
                    odbdsDetails.SetValue("LineId", i, i + 1)
                    odbdsDetails.SetValue("U_empID", i, objrs.Fields.Item("U_empid").Value.ToString)

                    odbdsDetails.SetValue("U_IDNo", i, objrs.Fields.Item("EmpCode").Value.ToString)
                    odbdsDetails.SetValue("U_empName", i, objrs.Fields.Item("EmpName").Value.ToString)
                    odbdsDetails.SetValue("U_Designat", i, objrs.Fields.Item("Designation").Value.ToString)
                    odbdsDetails.SetValue("U_Dept", i, objrs.Fields.Item("DeptCode").Value.ToString)
                    odbdsDetails.SetValue("U_PayMode", i, objrs.Fields.Item("PayMode").Value.ToString)

                    odbdsDetails.SetValue("U_TotalDays", i, objrs.Fields.Item("TotalDays").Value.ToString)
                    odbdsDetails.SetValue("U_TDayWrkd", i, objrs.Fields.Item("WorkedDays").Value.ToString)
                    odbdsDetails.SetValue("U_HoliDays", i, objrs.Fields.Item("PHDays").Value.ToString)
                    odbdsDetails.SetValue("U_WODays", i, objrs.Fields.Item("WODays").Value.ToString)
                    odbdsDetails.SetValue("U_LveDays", i, objrs.Fields.Item("LveDays").Value.ToString)
                    odbdsDetails.SetValue("U_LOPDays", i, objrs.Fields.Item("LopDays").Value.ToString)
                    odbdsDetails.SetValue("U_PaidDays", i, objrs.Fields.Item("PayableDays").Value.ToString)

                    odbdsDetails.SetValue("U_A1", i, objrs.Fields.Item("A1").Value.ToString)
                    odbdsDetails.SetValue("U_A2", i, objrs.Fields.Item("A2").Value.ToString)
                    odbdsDetails.SetValue("U_A3", i, objrs.Fields.Item("A3").Value.ToString)
                    odbdsDetails.SetValue("U_A4", i, objrs.Fields.Item("A4").Value.ToString)
                    odbdsDetails.SetValue("U_A5", i, objrs.Fields.Item("A5").Value.ToString)
                    odbdsDetails.SetValue("U_A6", i, objrs.Fields.Item("A6").Value.ToString)
                    odbdsDetails.SetValue("U_A7", i, objrs.Fields.Item("A7").Value.ToString)
                    odbdsDetails.SetValue("U_A8", i, objrs.Fields.Item("A8").Value.ToString)
                    odbdsDetails.SetValue("U_A9", i, objrs.Fields.Item("A9").Value.ToString)
                    odbdsDetails.SetValue("U_A10", i, objrs.Fields.Item("A10").Value.ToString)
                    odbdsDetails.SetValue("U_A11", i, objrs.Fields.Item("A11").Value.ToString)
                    odbdsDetails.SetValue("U_A12", i, objrs.Fields.Item("A12").Value.ToString)
                    odbdsDetails.SetValue("U_A13", i, objrs.Fields.Item("A13").Value.ToString)
                    odbdsDetails.SetValue("U_A14", i, objrs.Fields.Item("A14").Value.ToString)
                    odbdsDetails.SetValue("U_A15", i, objrs.Fields.Item("A15").Value.ToString)
                    odbdsDetails.SetValue("U_A16", i, objrs.Fields.Item("A16").Value.ToString)
                    odbdsDetails.SetValue("U_A17", i, objrs.Fields.Item("A17").Value.ToString)
                    odbdsDetails.SetValue("U_A18", i, objrs.Fields.Item("A18").Value.ToString)
                    odbdsDetails.SetValue("U_A19", i, objrs.Fields.Item("A19").Value.ToString)
                    odbdsDetails.SetValue("U_A20", i, objrs.Fields.Item("A20").Value.ToString)


                    odbdsDetails.SetValue("U_Basic", i, objrs.Fields.Item("TotalBasic").Value.ToString)
                    odbdsDetails.SetValue("U_totsal", i, objrs.Fields.Item("TotalSalary").Value.ToString)
                    odbdsDetails.SetValue("U_TotalOTHrs", i, objrs.Fields.Item("OTHrs").Value.ToString)
                    odbdsDetails.SetValue("U_OTPHR", i, objrs.Fields.Item("TotalOT_Perhour").Value.ToString)
                    odbdsDetails.SetValue("U_TotalOTAmt", i, objrs.Fields.Item("OTAmt").Value.ToString)
                    odbdsDetails.SetValue("U_GrossAmt", i, objrs.Fields.Item("GrossSalary").Value.ToString)

                    odbdsDetails.SetValue("U_Addition", i, objrs.Fields.Item("TotalAddition").Value.ToString)
                    odbdsDetails.SetValue("U_FA1", i, objrs.Fields.Item("AirTicekt_Addition").Value.ToString)
                    odbdsDetails.SetValue("U_FA2", i, objrs.Fields.Item("TripAllowance_Addition").Value.ToString)
                    odbdsDetails.SetValue("U_AB1", i, objrs.Fields.Item("AB1").Value.ToString)
                    odbdsDetails.SetValue("U_AB2", i, objrs.Fields.Item("AB2").Value.ToString)
                    odbdsDetails.SetValue("U_AB3", i, objrs.Fields.Item("AB3").Value.ToString)
                    odbdsDetails.SetValue("U_AB4", i, objrs.Fields.Item("AB4").Value.ToString)
                    odbdsDetails.SetValue("U_AB5", i, objrs.Fields.Item("AB5").Value.ToString)
                    odbdsDetails.SetValue("U_AB6", i, objrs.Fields.Item("AB6").Value.ToString)
                    odbdsDetails.SetValue("U_AB7", i, objrs.Fields.Item("AB7").Value.ToString)
                    odbdsDetails.SetValue("U_AB8", i, objrs.Fields.Item("AB8").Value.ToString)
                    odbdsDetails.SetValue("U_AB9", i, objrs.Fields.Item("AB9").Value.ToString)
                    odbdsDetails.SetValue("U_AB10", i, objrs.Fields.Item("AB10").Value.ToString)
                    odbdsDetails.SetValue("U_AB11", i, objrs.Fields.Item("AB11").Value.ToString)
                    odbdsDetails.SetValue("U_AB12", i, objrs.Fields.Item("AB12").Value.ToString)
                    odbdsDetails.SetValue("U_AB13", i, objrs.Fields.Item("AB13").Value.ToString)
                    odbdsDetails.SetValue("U_AB14", i, objrs.Fields.Item("AB14").Value.ToString)
                    odbdsDetails.SetValue("U_AB15", i, objrs.Fields.Item("AB15").Value.ToString)
                    odbdsDetails.SetValue("U_AB16", i, objrs.Fields.Item("AB16").Value.ToString)
                    odbdsDetails.SetValue("U_AB17", i, objrs.Fields.Item("AB17").Value.ToString)
                    odbdsDetails.SetValue("U_AB18", i, objrs.Fields.Item("AB18").Value.ToString)
                    odbdsDetails.SetValue("U_AB19", i, objrs.Fields.Item("AB19").Value.ToString)
                    odbdsDetails.SetValue("U_AB20", i, objrs.Fields.Item("AB20").Value.ToString)

                    odbdsDetails.SetValue("U_Deduction", i, objrs.Fields.Item("TotalDeduction").Value.ToString)
                    odbdsDetails.SetValue("U_FD1", i, objrs.Fields.Item("LoanDeduction").Value.ToString)
                    odbdsDetails.SetValue("U_FD2", i, objrs.Fields.Item("AL_Settled_Deduction").Value.ToString)
                    odbdsDetails.SetValue("U_FD3", i, objrs.Fields.Item("AdvanceSal_Settlement_Deduction").Value.ToString)
                    odbdsDetails.SetValue("U_DB1", i, objrs.Fields.Item("DB1").Value.ToString)
                    odbdsDetails.SetValue("U_DB2", i, objrs.Fields.Item("DB2").Value.ToString)
                    odbdsDetails.SetValue("U_DB3", i, objrs.Fields.Item("DB3").Value.ToString)
                    odbdsDetails.SetValue("U_DB4", i, objrs.Fields.Item("DB4").Value.ToString)
                    odbdsDetails.SetValue("U_DB5", i, objrs.Fields.Item("DB5").Value.ToString)
                    odbdsDetails.SetValue("U_DB6", i, objrs.Fields.Item("DB6").Value.ToString)
                    odbdsDetails.SetValue("U_DB7", i, objrs.Fields.Item("DB7").Value.ToString)
                    odbdsDetails.SetValue("U_DB8", i, objrs.Fields.Item("DB8").Value.ToString)
                    odbdsDetails.SetValue("U_DB9", i, objrs.Fields.Item("DB9").Value.ToString)
                    odbdsDetails.SetValue("U_DB10", i, objrs.Fields.Item("DB10").Value.ToString)
                    odbdsDetails.SetValue("U_DB11", i, objrs.Fields.Item("DB11").Value.ToString)
                    odbdsDetails.SetValue("U_DB12", i, objrs.Fields.Item("DB12").Value.ToString)
                    odbdsDetails.SetValue("U_DB13", i, objrs.Fields.Item("DB13").Value.ToString)
                    odbdsDetails.SetValue("U_DB14", i, objrs.Fields.Item("DB14").Value.ToString)
                    odbdsDetails.SetValue("U_DB15", i, objrs.Fields.Item("DB15").Value.ToString)
                    odbdsDetails.SetValue("U_DB16", i, objrs.Fields.Item("DB16").Value.ToString)
                    odbdsDetails.SetValue("U_DB17", i, objrs.Fields.Item("DB17").Value.ToString)
                    odbdsDetails.SetValue("U_DB18", i, objrs.Fields.Item("DB18").Value.ToString)
                    odbdsDetails.SetValue("U_DB19", i, objrs.Fields.Item("DB19").Value.ToString)
                    odbdsDetails.SetValue("U_DB20", i, objrs.Fields.Item("DB20").Value.ToString)

                    odbdsDetails.SetValue("U_RoundOff", i, objrs.Fields.Item("Roundoff").Value.ToString)
                    odbdsDetails.SetValue("U_NetAmt", i, objrs.Fields.Item("NetSalary").Value.ToString)
                    objrs.MoveNext()
                    If i <> objrs.RecordCount - 1 Then odbdsDetails.InsertRecord(odbdsDetails.Size)
                Next
                Matrix0.LoadFromDataSource()

                Matrix_Field_Setup()
                objaddon.objapplication.StatusBar.SetText("Payroll Details Loaded successfully", SAPbouiCOM.BoMessageTime.bmt_Short, SAPbouiCOM.BoStatusBarMessageType.smt_Success)
                If objform.Mode = SAPbouiCOM.BoFormMode.fm_OK_MODE Then objform.Mode = SAPbouiCOM.BoFormMode.fm_UPDATE_MODE
                objform.Freeze(False)
            Catch ex As Exception
                objaddon.objapplication.SetStatusBarMessage("Error While Loading Payroll Details : " & ex.ToString, SAPbouiCOM.BoMessageTime.bmt_Short, True)
                objform.Freeze(False)
            End Try
        End Sub

        Private Sub Button0_ClickBefore(sboObject As Object, pVal As SAPbouiCOM.SBOItemEventArg, ByRef BubbleEvent As Boolean) Handles Button0.ClickBefore
            If objform.Mode <> SAPbouiCOM.BoFormMode.fm_ADD_MODE Then Exit Sub
            If ComboBox0.Selected Is Nothing Then
                objaddon.objapplication.SetStatusBarMessage("Pay period is Missing", SAPbouiCOM.BoMessageTime.bmt_Short, True)
                BubbleEvent = False
                Exit Sub
            End If
            If ComboBox2.Selected Is Nothing Then
                objaddon.objapplication.SetStatusBarMessage("Employee Status is Missing", SAPbouiCOM.BoMessageTime.bmt_Short, True)
                BubbleEvent = False
                Exit Sub
            End If
            If EditText3.Value = "#" Then
                objaddon.objapplication.SetStatusBarMessage("Location is Missing", SAPbouiCOM.BoMessageTime.bmt_Short, True)
                BubbleEvent = False
                Exit Sub
            End If
            If ComboBox1.Selected Is Nothing Then
                objaddon.objapplication.SetStatusBarMessage("Series is Missing", SAPbouiCOM.BoMessageTime.bmt_Short, True)
                BubbleEvent = False
                Exit Sub
            End If

            If Matrix0.RowCount = 0 Then
                objaddon.objapplication.SetStatusBarMessage("Payroll Details is Missing", SAPbouiCOM.BoMessageTime.bmt_Short, True)
                BubbleEvent = False
                Exit Sub
            End If
        End Sub

        Private Sub Matrix0_LinkPressedAfter(sboObject As System.Object, pVal As SAPbouiCOM.SBOItemEventArg) Handles Matrix0.LinkPressedAfter
            If pVal.ColUID = "Empid" And pVal.Row <> -1 Then
                Try
                    If Matrix0.Columns.Item(pVal.ColUID).Cells.Item(pVal.Row).Specific.string = "" Then Exit Sub
                    Link_Value = Matrix0.Columns.Item(pVal.ColUID).Cells.Item(pVal.Row).Specific.string
                    Link_objtype = "OHEM"
                    Dim oactiveform As New frmEmployeeMaster
                    oactiveform.Show()
                Catch ex As Exception

                End Try
            End If

        End Sub

        Private Sub EditText5_LostFocusAfter(sboObject As Object, pVal As SAPbouiCOM.SBOItemEventArg) Handles EditText5.LostFocusAfter
            Try
                objaddon.objglobalmethods.LoadCombo_Series(objform, "cmbseries", "OPRC", IIf(EditText5.String = "", Now.Date, Date.ParseExact(EditText5.String, "dd.MM.yyyy", System.Globalization.DateTimeFormatInfo.InvariantInfo)))
            Catch ex As Exception
            End Try
        End Sub

        Private Sub Matrix0_ClickAfter(sboObject As System.Object, pVal As SAPbouiCOM.SBOItemEventArg) Handles Matrix0.ClickAfter
            If pVal.Row <= 0 Then Exit Sub
            Try
                'Matrix0.Columns.Item("#").Cells.Item(pVal.Row).Click(SAPbouiCOM.BoCellClickType.ct_Regular)

                Matrix0.CommonSetting.SetRowBackColor(lastrowid, Matrix0.Item.BackColor)
                Matrix0.CommonSetting.SetRowBackColor(pVal.Row, Color.PaleGoldenrod.ToArgb)

                lastrowid = pVal.Row
            Catch ex As Exception

            End Try
        End Sub

        Private Sub Matrix_Field_Setup()
            Try
                Matrix0.Columns.Item("U_A1").Visible = False
                Matrix0.Columns.Item("U_A2").Visible = False
                Matrix0.Columns.Item("U_A3").Visible = False
                Matrix0.Columns.Item("U_A4").Visible = False
                Matrix0.Columns.Item("U_A5").Visible = False
                Matrix0.Columns.Item("U_A6").Visible = False
                Matrix0.Columns.Item("U_A7").Visible = False
                Matrix0.Columns.Item("U_A8").Visible = False
                Matrix0.Columns.Item("U_A9").Visible = False
                Matrix0.Columns.Item("U_A10").Visible = False
                Matrix0.Columns.Item("U_A11").Visible = False
                Matrix0.Columns.Item("U_A12").Visible = False
                Matrix0.Columns.Item("U_A13").Visible = False
                Matrix0.Columns.Item("U_A14").Visible = False
                Matrix0.Columns.Item("U_A15").Visible = False
                Matrix0.Columns.Item("U_A16").Visible = False
                Matrix0.Columns.Item("U_A17").Visible = False
                Matrix0.Columns.Item("U_A18").Visible = False
                Matrix0.Columns.Item("U_A19").Visible = False
                Matrix0.Columns.Item("U_A20").Visible = False

                Matrix0.Columns.Item("U_AB1").Visible = False
                Matrix0.Columns.Item("U_AB2").Visible = False
                Matrix0.Columns.Item("U_AB3").Visible = False
                Matrix0.Columns.Item("U_AB4").Visible = False
                Matrix0.Columns.Item("U_AB5").Visible = False
                Matrix0.Columns.Item("U_AB6").Visible = False
                Matrix0.Columns.Item("U_AB7").Visible = False
                Matrix0.Columns.Item("U_AB8").Visible = False
                Matrix0.Columns.Item("U_AB9").Visible = False
                Matrix0.Columns.Item("U_AB10").Visible = False
                Matrix0.Columns.Item("U_AB11").Visible = False
                Matrix0.Columns.Item("U_AB12").Visible = False
                Matrix0.Columns.Item("U_AB13").Visible = False
                Matrix0.Columns.Item("U_AB14").Visible = False
                Matrix0.Columns.Item("U_AB15").Visible = False
                Matrix0.Columns.Item("U_AB16").Visible = False
                Matrix0.Columns.Item("U_AB17").Visible = False
                Matrix0.Columns.Item("U_AB18").Visible = False
                Matrix0.Columns.Item("U_AB19").Visible = False
                Matrix0.Columns.Item("U_AB20").Visible = False

                Matrix0.Columns.Item("U_DB1").Visible = False
                Matrix0.Columns.Item("U_DB2").Visible = False
                Matrix0.Columns.Item("U_DB3").Visible = False
                Matrix0.Columns.Item("U_DB4").Visible = False
                Matrix0.Columns.Item("U_DB5").Visible = False
                Matrix0.Columns.Item("U_DB6").Visible = False
                Matrix0.Columns.Item("U_DB7").Visible = False
                Matrix0.Columns.Item("U_DB8").Visible = False
                Matrix0.Columns.Item("U_DB9").Visible = False
                Matrix0.Columns.Item("U_DB10").Visible = False
                Matrix0.Columns.Item("U_DB11").Visible = False
                Matrix0.Columns.Item("U_DB12").Visible = False
                Matrix0.Columns.Item("U_DB13").Visible = False
                Matrix0.Columns.Item("U_DB14").Visible = False
                Matrix0.Columns.Item("U_DB15").Visible = False
                Matrix0.Columns.Item("U_DB16").Visible = False
                Matrix0.Columns.Item("U_DB17").Visible = False
                Matrix0.Columns.Item("U_DB18").Visible = False
                Matrix0.Columns.Item("U_DB19").Visible = False
                Matrix0.Columns.Item("U_DB20").Visible = False

                Matrix0.Columns.Item("basic").Visible = False
                Matrix0.Columns.Item("totsal").Visible = False

                strsql = "select 'U_'+U_Sequence [ColName],Name from [@SMPR_OPYE] "
                objrs = objaddon.objcompany.GetBusinessObject(SAPbobsCOM.BoObjectTypes.BoRecordset)
                objrs.DoQuery(strsql)
                If objrs.RecordCount > 0 Then
                    For i As Integer = 0 To objrs.RecordCount - 1
                        Matrix0.Columns.Item(objrs.Fields.Item("ColName").Value.ToString).Visible = True
                        Matrix0.Columns.Item(objrs.Fields.Item("ColName").Value.ToString).TitleObject.Caption = objrs.Fields.Item("Name").Value.ToString
                        Matrix0.Columns.Item(objrs.Fields.Item("ColName").Value.ToString).RightJustified = True
                        Matrix0.Columns.Item(objrs.Fields.Item("ColName").Value.ToString).ColumnSetting.SumType = SAPbouiCOM.BoColumnSumType.bst_Auto
                        objrs.MoveNext()
                    Next
                End If

                Matrix0.Columns.Item("netsal").ColumnSetting.SumType = SAPbouiCOM.BoColumnSumType.bst_Auto
                Matrix0.Columns.Item("totsal").ColumnSetting.SumType = SAPbouiCOM.BoColumnSumType.bst_Auto
                Matrix0.Columns.Item("totamt").ColumnSetting.SumType = SAPbouiCOM.BoColumnSumType.bst_Auto
                Matrix0.Columns.Item("Gsal").ColumnSetting.SumType = SAPbouiCOM.BoColumnSumType.bst_Auto
                Matrix0.Columns.Item("tadd").ColumnSetting.SumType = SAPbouiCOM.BoColumnSumType.bst_Auto
                Matrix0.Columns.Item("atick").ColumnSetting.SumType = SAPbouiCOM.BoColumnSumType.bst_Auto
                Matrix0.Columns.Item("trip").ColumnSetting.SumType = SAPbouiCOM.BoColumnSumType.bst_Auto
                Matrix0.Columns.Item("TD").ColumnSetting.SumType = SAPbouiCOM.BoColumnSumType.bst_Auto
                Matrix0.Columns.Item("loan").ColumnSetting.SumType = SAPbouiCOM.BoColumnSumType.bst_Auto
                Matrix0.Columns.Item("alsal").ColumnSetting.SumType = SAPbouiCOM.BoColumnSumType.bst_Auto
                Matrix0.Columns.Item("advsal").ColumnSetting.SumType = SAPbouiCOM.BoColumnSumType.bst_Auto
                Matrix0.Columns.Item("round").ColumnSetting.SumType = SAPbouiCOM.BoColumnSumType.bst_Auto

                'Matrix0.Columns.Item("netsal").BackColor = Color.SeaGreen.ToArgb
                Matrix0.Columns.Item("netsal").ForeColor = Color.Red.ToArgb
                Matrix0.Columns.Item("netsal").TextStyle = FontStyle.Bold
                Matrix0.Columns.Item("pdays").ForeColor = Color.Green.ToArgb
                Matrix0.Columns.Item("pdays").TextStyle = FontStyle.Bold
                Matrix0.Columns.Item("totamt").ForeColor = Color.DarkOrange.ToArgb
                Matrix0.Columns.Item("totamt").TextStyle = FontStyle.Bold
                Matrix0.Columns.Item("Gsal").ForeColor = 150
                Matrix0.Columns.Item("Gsal").TextStyle = FontStyle.Bold
                Matrix0.Columns.Item("tadd").ForeColor = Color.Brown.ToArgb
                Matrix0.Columns.Item("tadd").TextStyle = FontStyle.Bold
                Matrix0.Columns.Item("TD").ForeColor = Color.DarkMagenta.ToArgb
                Matrix0.Columns.Item("TD").TextStyle = FontStyle.Bold

                Matrix0.CommonSetting.FixedColumnsCount = 9

                objaddon.objapplication.Menus.Item("1300").Activate()
            Catch ex As Exception

            End Try
        End Sub

        Private Sub LinkedButton1_ClickAfter(sboObject As System.Object, pVal As SAPbouiCOM.SBOItemEventArg) Handles LinkedButton1.ClickAfter
            Try
                frmmultiselectform = objaddon.objapplication.Forms.ActiveForm
                Query_multiselect = "select 'Y' [Select],Code,location from olct where isnull(U_HR,'')='Y' and '" & EditText3.Value & "' like '%#'+convert(varchar,code) +'#%' union all"
                Query_multiselect += vbCrLf + "select 'N' [Select],Code,location from olct where isnull(U_HR,'')='Y' and '" & EditText3.Value & "' not like '%#'+convert(varchar,code) +'#%' order by Code"
                multi_objtype = "OLCT"
                Dim activeform As New Frmmulitselect
                activeform.Show()
            Catch ex As Exception

            End Try
        End Sub

        Private Sub Button0_PressedAfter(sboObject As Object, pVal As SAPbouiCOM.SBOItemEventArg) Handles Button0.PressedAfter
            Try
                If pVal.ActionSuccess = True And objform.Mode = SAPbouiCOM.BoFormMode.fm_ADD_MODE Then
                    If addupdate = True Then objaddon.objapplication.StatusBar.SetText("Payroll Process Added and Document Sent for Approval", SAPbouiCOM.BoMessageTime.bmt_Short, SAPbouiCOM.BoStatusBarMessageType.smt_Success)
                    objform.Items.Item("txtdate").Specific.string = Now.Date.ToString("dd.MM.yyyy")
                    EditText3.Value = "#"
                    objform.Items.Item("txtentry").Specific.string = objaddon.objglobalmethods.GetNextDocentry_Value("[@SMPR_OPRC]")
                    ComboBox2.Select("1", SAPbouiCOM.BoSearchKey.psk_ByValue)
                    objform.ActiveItem = "cmbpay"
                ElseIf pVal.ActionSuccess = True And objform.Mode = SAPbouiCOM.BoFormMode.fm_OK_MODE Then
                    If addupdate = True Then objaddon.objapplication.StatusBar.SetText("Payroll Process Updated and Document Sent for Approval", SAPbouiCOM.BoMessageTime.bmt_Short, SAPbouiCOM.BoStatusBarMessageType.smt_Success)
                    objaddon.objapplication.Menus.Item("1304").Activate()
                End If
            Catch ex As Exception

            End Try
        End Sub

        Private Sub Button0_PressedBefore(sboObject As Object, pVal As SAPbouiCOM.SBOItemEventArg, ByRef BubbleEvent As Boolean) Handles Button0.PressedBefore
            Try
                If (objform.Mode = SAPbouiCOM.BoFormMode.fm_ADD_MODE Or objform.Mode = SAPbouiCOM.BoFormMode.fm_UPDATE_MODE) Then
                    addupdate = True
                Else
                    addupdate = False
                End If
            Catch ex As Exception

            End Try
        End Sub

        Private Sub CheckBox0_PressedAfter(sboObject As Object, pVal As SAPbouiCOM.SBOItemEventArg) Handles CheckBox0.PressedAfter
            If CheckBox0.Checked = True Then
                CheckBox1.Item.Enabled = False
            End If
        End Sub

        Private Sub CheckBox1_PressedAfter(sboObject As Object, pVal As SAPbouiCOM.SBOItemEventArg) Handles CheckBox1.PressedAfter
            If CheckBox1.Checked = True Then
                CheckBox0.Item.Enabled = False
            End If
        End Sub

        Private Sub CheckBox1_PressedBefore(sboObject As Object, pVal As SAPbouiCOM.SBOItemEventArg, ByRef BubbleEvent As Boolean) Handles CheckBox1.PressedBefore
            If objform.Mode = SAPbouiCOM.BoFormMode.fm_ADD_MODE Then BubbleEvent = False
        End Sub
    End Class
End Namespace
