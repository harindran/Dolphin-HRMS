﻿Imports SAPbouiCOM
Namespace HRMS

    Public Class clsMenuEvent
        Dim objform As SAPbouiCOM.Form
        Dim objglobalmethods As New clsGlobalMethods

        Public Sub MenuEvent_For_StandardMenu(ByRef pVal As SAPbouiCOM.MenuEvent, ByRef BubbleEvent As Boolean)
            Try
                Select Case objaddon.objapplication.Forms.ActiveForm.TypeEx
                    Case "MSTRLOAN" 'Loan Master
                        LoanMaster_MenuEvent(pVal, BubbleEvent)
                    Case "MSTRPAYE" 'Pay Element Master
                        PayElement_MenuEvent(pVal, BubbleEvent)
                    Case "MSTRIDCD" 'ID Card Type Master
                        IDCardtype_MenuEvent(pVal, BubbleEvent)
                    Case "MSTRLEVE" 'Leave Master
                        LeaveMaster_MenuEvent(pVal, BubbleEvent)
                    Case "MSTRSHFT" 'Shift Master
                        ShiftMaster_MenuEvent(pVal, BubbleEvent)
                    Case "MSTREMPL" 'Employee Master
                        EmployeeMaster_MenuEvent(pVal, BubbleEvent)
                    Case "TRANOLVA" 'Leave Application
                        LeaveApplication_MenuEvent(pVal, BubbleEvent)
                    Case "TRANOLAP" 'Loan Application
                        LoanApplication_MenuEvent(pVal, BubbleEvent)
                    Case "ODAS" 'Daily Attendance
                        Dailyattendance_MenuEvent(pVal, BubbleEvent)
                    Case "OPAD" 'Adddition & Deduction screen
                        Addition_Deduction_MenuEvent(pVal, BubbleEvent)
                    Case "OTIS" ' Air Ticekt Issue Screen
                        AirTicket_Issue_MenuEvent(pVal, BubbleEvent)
                    Case "OLSE" 'Leave/Final Settlemtn
                        Settlement_MenuEvent(pVal, BubbleEvent)
                    Case "OPRC" 'Payroll Process
                        PayrollProcess_MenuEvent(pVal, BubbleEvent)
                    Case "ACCT" 'Account Determination
                        Acct_Determination_MenuEvent(pVal, BubbleEvent)
                    Case "PROV"
                        ProvisionProcess_MenuEvent(pVal, BubbleEvent)
                End Select
            Catch ex As Exception

            End Try
        End Sub

        Private Sub Default_Sample_MenuEvent(ByVal pval As SAPbouiCOM.MenuEvent, ByVal BubbleEvent As Boolean)
            Try
                objform = objaddon.objapplication.Forms.ActiveForm
                If pval.BeforeAction = True Then
                Else
                    Select Case pval.MenuUID
                        Case "1281"
                        Case Else
                    End Select
                End If
            Catch ex As Exception
                objaddon.objapplication.SetStatusBarMessage("Error in Standart Menu Event" + ex.ToString, SAPbouiCOM.BoMessageTime.bmt_Medium, True)
            End Try
        End Sub

#Region "Loan Master"

        Private Sub LoanMaster_MenuEvent(ByVal pval As SAPbouiCOM.MenuEvent, ByVal BubbleEvent As Boolean)
            Try
                objform = objaddon.objapplication.Forms.ActiveForm
                If pval.BeforeAction = True Then
                    Select Case pval.MenuUID
                        Case "1283", "1284"
                            objaddon.objapplication.SetStatusBarMessage("Loan Master Remove or Cancel is not allowed", SAPbouiCOM.BoMessageTime.bmt_Short, True)
                            BubbleEvent = False
                    End Select
                Else
                    Select Case pval.MenuUID
                        Case "1281"
                            objform.Items.Item("txtCode").Enabled = True
                            objform.Items.Item("txtCode").Click(SAPbouiCOM.BoCellClickType.ct_Regular)
                        Case "1282"
                            objform.Items.Item("txtCode").Specific.string = objglobalmethods.GetNextCode_Value("[@SMPR_OLON]")
                            objform.Items.Item("txtname").Click(SAPbouiCOM.BoCellClickType.ct_Regular)
                            objform.Items.Item("txtCode").Enabled = False
                            objform.Items.Item("txtname").Click(SAPbouiCOM.BoCellClickType.ct_Regular)
                        Case "1283", "1284"
                            objaddon.objapplication.SetStatusBarMessage("Loan Master Remove or Cancel is not allowed", SAPbouiCOM.BoMessageTime.bmt_Short, True)
                        Case Else
                            objform.Items.Item("txtname").Click(SAPbouiCOM.BoCellClickType.ct_Regular)
                            objform.Items.Item("txtCode").Enabled = False
                            objform.Items.Item("txtname").Click(SAPbouiCOM.BoCellClickType.ct_Regular)
                    End Select
                End If
            Catch ex As Exception
                objaddon.objapplication.SetStatusBarMessage("Error in LoanMaster Menu Event" + ex.ToString, SAPbouiCOM.BoMessageTime.bmt_Medium, True)
            End Try
        End Sub

#End Region

#Region "Pay Element Master"

        Private Sub PayElement_MenuEvent(ByVal pval As SAPbouiCOM.MenuEvent, ByVal BubbleEvent As Boolean)
            Try
                objform = objaddon.objapplication.Forms.ActiveForm
                If pval.BeforeAction = True Then
                    Select Case pval.MenuUID
                        Case "1283", "1284"
                            objaddon.objapplication.SetStatusBarMessage("Pay Element Master Remove or Cancel is not allowed", SAPbouiCOM.BoMessageTime.bmt_Short, True)
                            BubbleEvent = False
                    End Select
                Else
                    Select Case pval.MenuUID
                        Case "1281", "1282"
                            objform.Items.Item("txtcode").Enabled = True
                            objform.Items.Item("txtcode").Click(SAPbouiCOM.BoCellClickType.ct_Regular)
                    End Select
                End If
            Catch ex As Exception
                objaddon.objapplication.SetStatusBarMessage("Error in PayElement Menu Event" + ex.ToString, SAPbouiCOM.BoMessageTime.bmt_Medium, True)
            End Try
        End Sub

#End Region

#Region "ID Card Type Master"

        Private Sub IDCardtype_MenuEvent(ByVal pval As SAPbouiCOM.MenuEvent, ByVal BubbleEvent As Boolean)
            Try
                objform = objaddon.objapplication.Forms.ActiveForm
                If pval.BeforeAction = True Then
                    Select Case pval.MenuUID
                        Case "1283", "1284"
                            objaddon.objapplication.SetStatusBarMessage("ID Card Type Master Remove or Cancel is not allowed", SAPbouiCOM.BoMessageTime.bmt_Short, True)
                            BubbleEvent = False
                    End Select
                Else
                    Select Case pval.MenuUID
                        Case "1281", "1282"
                            objform.Items.Item("txtcode").Enabled = True
                            objform.Items.Item("txtcode").Click(SAPbouiCOM.BoCellClickType.ct_Regular)
                    End Select
                End If
            Catch ex As Exception
                objaddon.objapplication.SetStatusBarMessage("Error in PayElement Menu Event" + ex.ToString, SAPbouiCOM.BoMessageTime.bmt_Medium, True)
            End Try
        End Sub

#End Region

#Region "Leave Master"

        Private Sub LeaveMaster_MenuEvent(ByVal pval As SAPbouiCOM.MenuEvent, ByVal BubbleEvent As Boolean)
            Try
                objform = objaddon.objapplication.Forms.ActiveForm
                If pval.BeforeAction = True Then
                    Select Case pval.MenuUID
                        Case "1283", "1284"
                            objaddon.objapplication.SetStatusBarMessage("Leave Master Remove or Cancel is not allowed", SAPbouiCOM.BoMessageTime.bmt_Short, True)
                            BubbleEvent = False
                    End Select
                Else
                    Select Case pval.MenuUID
                        Case "1281", "1282"
                            objform.Items.Item("txtcode").Enabled = True
                            objform.Items.Item("txtcode").Click(SAPbouiCOM.BoCellClickType.ct_Regular)
                    End Select
                End If
            Catch ex As Exception
                objaddon.objapplication.SetStatusBarMessage("Error in PayElement Menu Event" + ex.ToString, SAPbouiCOM.BoMessageTime.bmt_Medium, True)
            End Try
        End Sub
#End Region

#Region "Shift Master"

        Private Sub ShiftMaster_MenuEvent(ByVal pval As SAPbouiCOM.MenuEvent, ByVal BubbleEvent As Boolean)
            Try
                objform = objaddon.objapplication.Forms.ActiveForm
                If pval.BeforeAction = True Then
                    Select Case pval.MenuUID
                        Case "1283", "1284"
                            objaddon.objapplication.SetStatusBarMessage("Employee Shift Master Remove or Cancel is not allowed", SAPbouiCOM.BoMessageTime.bmt_Short, True)
                            BubbleEvent = False
                    End Select
                Else
                    Select Case pval.MenuUID
                        Case "1281"
                            objform.Items.Item("txtcode").Enabled = True
                            objform.Items.Item("txtcode").Click(SAPbouiCOM.BoCellClickType.ct_Regular)
                        Case "1282"
                            objform.Items.Item("txtcode").Specific.string = objglobalmethods.GetNextCode_Value("[@SMHR_OSFT]")
                            objform.Items.Item("txtname").Click(SAPbouiCOM.BoCellClickType.ct_Regular)
                            objform.Items.Item("txtcode").Enabled = False
                            objform.Items.Item("txtname").Click(SAPbouiCOM.BoCellClickType.ct_Regular)
                        Case Else
                            objform.Items.Item("txtname").Click(SAPbouiCOM.BoCellClickType.ct_Regular)
                            objform.Items.Item("txtcode").Enabled = False
                            objform.Items.Item("txtname").Click(SAPbouiCOM.BoCellClickType.ct_Regular)
                    End Select
                End If
            Catch ex As Exception
                objaddon.objapplication.SetStatusBarMessage("Error in LoanMaster Menu Event" + ex.ToString, SAPbouiCOM.BoMessageTime.bmt_Medium, True)
            End Try
        End Sub

#End Region

#Region "Employee Master"

        Private Sub EmployeeMaster_MenuEvent(ByRef pval As SAPbouiCOM.MenuEvent, ByRef BubbleEvent As Boolean)
            Try
                objform = objaddon.objapplication.Forms.ActiveForm
                If pval.BeforeAction = True Then
                    Select Case pval.MenuUID
                        Case "1293" 'Delete Row
                            Employeemasterdata_Deleterow(pval, BubbleEvent)
                        Case "1283", "1284" 'Remove & Cancel
                            objaddon.objapplication.SetStatusBarMessage("Employee Master Remove or Cancel is not allowed", SAPbouiCOM.BoMessageTime.bmt_Short, True)
                            BubbleEvent = False
                    End Select
                Else
                    Select Case pval.MenuUID
                        Case "1281" 'Find Mode
                            objform.Items.Item("txtempid").Enabled = True
                            objform.Items.Item("txtiempid").Enabled = True
                            objform.Items.Item("txtiempid").Click(SAPbouiCOM.BoCellClickType.ct_Regular)
                        Case "1282" ' Add Mode
                            Employeemasterdata_Addmode(objform)
                        Case "1292" 'Add Row
                            EmployeeMasterdata_Addrow(objform)
                        Case "1293" 'Delete Row
                            Employeemasterdata_Deleterow(pval, BubbleEvent)
                        Case "ELV" 'Employee Leave Application
                            objaddon.objglobalmethods.RightClickMenu_Delete("1280", "ELV")
                            objaddon.objglobalmethods.RightClickMenu_Delete("1280", "ELN")
                            objaddon.objglobalmethods.RightClickMenu_Delete("1280", "EAI")
                            objaddon.objglobalmethods.RightClickMenu_Delete("1280", "EST")
                            Link_objtype = "TRANOLVA"
                            Link_Value = objform.Items.Item("txtempid").Specific.string
                            Dim activeform As New FrmHistory
                            activeform.Show()
                        Case "ELN" 'Employee Loan Application
                            objaddon.objglobalmethods.RightClickMenu_Delete("1280", "ELV")
                            objaddon.objglobalmethods.RightClickMenu_Delete("1280", "ELN")
                            objaddon.objglobalmethods.RightClickMenu_Delete("1280", "EAI")
                            objaddon.objglobalmethods.RightClickMenu_Delete("1280", "EST")
                            Link_objtype = "TRANOLAP_FHD"
                            Link_Value = objform.Items.Item("txtempid").Specific.string
                            Dim activeform As New FrmHistory
                            activeform.Show()
                        Case "EAI"
                            objaddon.objglobalmethods.RightClickMenu_Delete("1280", "ELV")
                            objaddon.objglobalmethods.RightClickMenu_Delete("1280", "ELN")
                            objaddon.objglobalmethods.RightClickMenu_Delete("1280", "EAI")
                            objaddon.objglobalmethods.RightClickMenu_Delete("1280", "EST")
                            Link_objtype = "OTIS_HD"
                            Link_Value = objform.Items.Item("txtempid").Specific.string
                            Dim activeform As New FrmHistory
                            activeform.Show()
                        Case "EST"
                            objaddon.objglobalmethods.RightClickMenu_Delete("1280", "ELV")
                            objaddon.objglobalmethods.RightClickMenu_Delete("1280", "ELN")
                            objaddon.objglobalmethods.RightClickMenu_Delete("1280", "EAI")
                            objaddon.objglobalmethods.RightClickMenu_Delete("1280", "EST")
                            Link_objtype = "OLSE_HD"
                            Link_Value = objform.Items.Item("txtempid").Specific.string
                            Dim activeform As New FrmHistory
                            activeform.Show()
                        Case Else
                            objform.Items.Item("txtiempid").Click(SAPbouiCOM.BoCellClickType.ct_Regular)
                            objform.Items.Item("txtempid").Enabled = False
                            objform.Items.Item("txtiempid").Click(SAPbouiCOM.BoCellClickType.ct_Regular)
                    End Select
                End If
            Catch ex As Exception
                objaddon.objapplication.SetStatusBarMessage("Error in LoanMaster Menu Event" + ex.ToString, SAPbouiCOM.BoMessageTime.bmt_Medium, True)
            End Try
        End Sub

        Private Sub Employeemasterdata_Addmode(ByVal objform As SAPbouiCOM.Form)
            Try
                objform.Freeze(True)
                objform.Items.Item("txtempid").Specific.string = objglobalmethods.GetNextCode_Value("[@SMPR_OHEM]")
                objform.Items.Item("txtcode").Specific.string = objform.Items.Item("txtempid").Specific.string
                objform.Items.Item("txtentry").Specific.string = objform.Items.Item("txtempid").Specific.string

                Dim objmatrix As SAPbouiCOM.Matrix
                objmatrix = objform.Items.Item("mLeave").Specific
                objmatrix.AddRow(1)
                objmatrix.Columns.Item("#").Cells.Item(1).Specific.string = 1

                objmatrix = objform.Items.Item("mSalary").Specific
                objmatrix.AddRow(1)
                objmatrix.Columns.Item("#").Cells.Item(1).Specific.string = 1

                objmatrix = objform.Items.Item("mID").Specific
                objmatrix.AddRow(1)
                objmatrix.Columns.Item("#").Cells.Item(1).Specific.string = 1

                objmatrix = objform.Items.Item("mskill").Specific
                objmatrix.AddRow(1)
                objmatrix.Columns.Item("#").Cells.Item(1).Specific.string = 1

                objmatrix = objform.Items.Item("mtraining").Specific
                objmatrix.AddRow(1)
                objmatrix.Columns.Item("#").Cells.Item(1).Specific.string = 1

                objmatrix = objform.Items.Item("mfamily").Specific
                objmatrix.AddRow(1)
                objmatrix.Columns.Item("#").Cells.Item(1).Specific.string = 1

                objmatrix = objform.Items.Item("meducation").Specific
                objmatrix.AddRow(1)
                objmatrix.Columns.Item("#").Cells.Item(1).Specific.string = 1

                objmatrix = objform.Items.Item("mpreemp").Specific
                objmatrix.AddRow(1)
                objmatrix.Columns.Item("#").Cells.Item(1).Specific.string = 1

                objmatrix = objform.Items.Item("mair").Specific
                objmatrix.AddRow(1)
                objmatrix.Columns.Item("#").Cells.Item(1).Specific.string = 1

                objform.Items.Item("txtiempid").Enabled = True
                objform.Items.Item("txtiempid").Click(SAPbouiCOM.BoCellClickType.ct_Regular)
                objform.Items.Item("txtempid").Enabled = False
                objform.Freeze(False)
            Catch ex As Exception
                objform.Freeze(False)
            End Try
        End Sub

        Private Sub EmployeeMasterdata_Addrow(ByVal objform As SAPbouiCOM.Form)

            Dim objmatrix As SAPbouiCOM.Matrix
            Select Case objform.ActiveItem
                Case "mLeave"
                    objmatrix = objform.Items.Item(objform.ActiveItem).Specific
                    objaddon.objglobalmethods.Matrix_Addrow(objmatrix, "lvcode", "#", True)
                Case "mSalary"
                    objmatrix = objform.Items.Item(objform.ActiveItem).Specific
                    objaddon.objglobalmethods.Matrix_Addrow(objmatrix, "pycode", "#", True)
                Case "mID"
                    objmatrix = objform.Items.Item(objform.ActiveItem).Specific
                    objaddon.objglobalmethods.Matrix_Addrow(objmatrix, "idcode", "#", True)
                Case "mskill"
                    objmatrix = objform.Items.Item(objform.ActiveItem).Specific
                    objaddon.objglobalmethods.Matrix_Addrow(objmatrix, "skcode", "#", True)
                Case "mtraining"
                    objmatrix = objform.Items.Item(objform.ActiveItem).Specific
                    objaddon.objglobalmethods.Matrix_Addrow(objmatrix, "trname", "#", True)
                Case "mfamily"
                    objmatrix = objform.Items.Item(objform.ActiveItem).Specific
                    objaddon.objglobalmethods.Matrix_Addrow(objmatrix, "fname", "#", True)
                Case "meducation"
                    objmatrix = objform.Items.Item(objform.ActiveItem).Specific
                    objaddon.objglobalmethods.Matrix_Addrow(objmatrix, "edfrdt", "#", True)
                Case "mpreemp"
                    objmatrix = objform.Items.Item(objform.ActiveItem).Specific
                    objaddon.objglobalmethods.Matrix_Addrow(objmatrix, "emfrom", "#", True)
                Case "mair"
                    objmatrix = objform.Items.Item(objform.ActiveItem).Specific
                    objaddon.objglobalmethods.Matrix_Addrow(objmatrix, "frdate", "#", True)
            End Select

        End Sub

        Private Sub Employeemasterdata_Deleterow(ByRef pval As SAPbouiCOM.MenuEvent, ByRef BubbleEvent As Boolean)
            Try
                objform = objaddon.objapplication.Forms.ActiveForm
                Dim objmatrix As SAPbouiCOM.Matrix
                If pval.BeforeAction = True Then
                    If objform.ActiveItem = "mLeave" Or objform.ActiveItem = "mSalary" Or objform.ActiveItem = "mID" Or objform.ActiveItem = "mtraining" Or objform.ActiveItem = "mfamily" Or objform.ActiveItem = "meducation" Or objform.ActiveItem = "mpreemp" Or objform.ActiveItem = "mskill" Or objform.ActiveItem = "mair" Then
                        objmatrix = objform.Items.Item(objform.ActiveItem).Specific
                        If objmatrix.VisualRowCount = 1 Then
                            objaddon.objapplication.SetStatusBarMessage("Cannot be deleted.Only one row available", SAPbouiCOM.BoMessageTime.bmt_Short, True)
                            BubbleEvent = False
                        Else
                            Empmaster_currenmatrix = objform.ActiveItem
                        End If
                    End If
                Else
                    If Empmaster_currenmatrix <> "-1" Then
                        objmatrix = objform.Items.Item(Empmaster_currenmatrix).Specific
                        objform.Freeze(True)
                        For i As Integer = 1 To objmatrix.VisualRowCount
                            objmatrix.Columns.Item("#").Cells.Item(i).Specific.string = i
                        Next
                        Empmaster_currenmatrix = "-1"
                        objform.Freeze(False)
                    End If
                End If
            Catch ex As Exception
                objform.Freeze(False)
            End Try
        End Sub

#End Region

#Region "Loan Application"

        Private Sub LoanApplication_MenuEvent(ByRef pval As SAPbouiCOM.MenuEvent, ByRef BubbleEvent As Boolean)
            Try
                Dim ocombo As SAPbouiCOM.ComboBox
                Dim chkpayroll As SAPbouiCOM.CheckBox
                Dim nextlineid As Integer = 0
                objform = objaddon.objapplication.Forms.ActiveForm
                Dim objmatrix As SAPbouiCOM.Matrix
                If pval.BeforeAction = True Then
                    Select Case pval.MenuUID
                        Case "1293" 'Delete Row
                            objmatrix = objform.Items.Item("mtloan").Specific
                            If objmatrix.VisualRowCount = 1 Then BubbleEvent = False
                        Case "1283", "1284" 'Remove & Cancel
                            objaddon.objapplication.SetStatusBarMessage("Loan Application Remove or Cancel is not allowed", SAPbouiCOM.BoMessageTime.bmt_Short, True)
                            BubbleEvent = False
                        Case "NXTM" 'Move to Next Month
                            objmatrix = objform.Items.Item("mtloan").Specific
                            If Current_Lineid = "-1" Then BubbleEvent = False : Exit Sub
                            ocombo = objmatrix.Columns.Item("status").Cells.Item(Current_Lineid).Specific
                            If ocombo.Value.ToString.ToUpper <> "O" Then
                                objaddon.objapplication.SetStatusBarMessage("Status Closed/Draft row cannot be processed", SAPbouiCOM.BoMessageTime.bmt_Short, True)
                                BubbleEvent = False : Exit Sub
                            End If
                            If Current_Lineid = objmatrix.VisualRowCount Then
                                objaddon.objapplication.SetStatusBarMessage("No Next Month Found", SAPbouiCOM.BoMessageTime.bmt_Short, True)
                                BubbleEvent = False : Exit Sub
                            End If
                            For i As Integer = Current_Lineid + 1 To objmatrix.VisualRowCount
                                ocombo = objmatrix.Columns.Item("status").Cells.Item(i).Specific
                                If ocombo.Selected.Value = "O" Then Exit Sub
                            Next
                            objaddon.objapplication.SetStatusBarMessage("No Next Month Found", SAPbouiCOM.BoMessageTime.bmt_Short, True)
                            BubbleEvent = False : Exit Sub
                        Case "NEWM" 'Move to New Month
                            objmatrix = objform.Items.Item("mtloan").Specific
                            If Current_Lineid = "-1" Then BubbleEvent = False : Exit Sub
                            ocombo = objmatrix.Columns.Item("status").Cells.Item(Current_Lineid).Specific
                            If ocombo.Value.ToString.ToUpper <> "O" Then
                                objaddon.objapplication.SetStatusBarMessage("Status Closed/Draft row cannot be processed", SAPbouiCOM.BoMessageTime.bmt_Short, True)
                                BubbleEvent = False : Exit Sub
                            End If
                        Case "CPY"
                            objmatrix = objform.Items.Item("mtloan").Specific
                            If Current_Lineid = "-1" Then BubbleEvent = False : Exit Sub
                            ocombo = objmatrix.Columns.Item("status").Cells.Item(Current_Lineid).Specific
                            If ocombo.Value.ToString.ToUpper <> "O" Then
                                objaddon.objapplication.SetStatusBarMessage("Status Closed/Draft row cannot be processed", SAPbouiCOM.BoMessageTime.bmt_Short, True)
                                BubbleEvent = False : Exit Sub
                            End If
                    End Select
                Else
                    Select Case pval.MenuUID
                        Case "1281" 'Find Mode
                            objform.Items.Item("txtiempid").Click(SAPbouiCOM.BoCellClickType.ct_Regular)
                        Case "1282" ' Add Mode
                            objform.Items.Item("txtentry").Specific.string = objaddon.objglobalmethods.GetNextDocentry_Value("[@SMPR_OLOA]")
                            objform.Items.Item("txtdocdt").Specific.string = Now.Date.ToString("dd.MM.yyyy")
                            objform.Title = "Loan Application"
                            objmatrix = objform.Items.Item("mtloan").Specific
                            For i As Integer = 0 To objmatrix.Columns.Count - 1
                                If objmatrix.Columns.Item(i).UniqueID = "date" Or objmatrix.Columns.Item(i).UniqueID = "amount" Or objmatrix.Columns.Item(i).UniqueID = "chkded" Then
                                    objmatrix.Columns.Item(i).Editable = True
                                Else
                                    objmatrix.Columns.Item(i).Editable = False
                                End If
                            Next
                            objform.Items.Item("txtiempid").Click(SAPbouiCOM.BoCellClickType.ct_Regular)
                        Case "1292" 'Add Row
                            objmatrix = objform.Items.Item("mtloan").Specific
                            If objmatrix.VisualRowCount > 0 Then
                                If objmatrix.Columns.Item("date").Cells.Item(objmatrix.VisualRowCount).Specific.string <> "" Then
                                    objmatrix.AddRow(1)
                                    objmatrix.ClearRowData(objmatrix.VisualRowCount)
                                    objmatrix.Columns.Item("#").Cells.Item(objmatrix.VisualRowCount).Specific.string = objmatrix.VisualRowCount
                                    loanmatrix_roweditable(objmatrix, objmatrix.VisualRowCount, True)
                                    If objform.Mode = BoFormMode.fm_OK_MODE Then objform.Mode = BoFormMode.fm_UPDATE_MODE
                                End If
                            Else
                                objmatrix = objform.Items.Item("mtloan").Specific
                                objmatrix.AddRow(1)
                                objmatrix.ClearRowData(objmatrix.VisualRowCount)
                                objmatrix.Columns.Item("#").Cells.Item(1).Specific.string = 1
                                loanmatrix_roweditable(objmatrix, objmatrix.VisualRowCount, True)
                                If objform.Mode = BoFormMode.fm_OK_MODE Then objform.Mode = BoFormMode.fm_UPDATE_MODE
                            End If
                        Case "1293" 'Delete Row
                            objmatrix = objform.Items.Item("mtloan").Specific
                            For i As Integer = 1 To objmatrix.VisualRowCount
                                objmatrix.Columns.Item("#").Cells.Item(i).Specific.String = i
                            Next
                            If objform.Mode = BoFormMode.fm_OK_MODE Then objform.Mode = BoFormMode.fm_UPDATE_MODE
                            objform.Update()
                            objform.Refresh()
                        Case "NXTM" 'Move to Next Month
                            objaddon.objglobalmethods.RightClickMenu_Delete("1280", "NXTM")
                            objform.Freeze(True)
                            nextlineid = Current_Lineid + 1
                            objmatrix = objform.Items.Item("mtloan").Specific
                            For i As Integer = Current_Lineid + 1 To objmatrix.RowCount
                                ocombo = objmatrix.Columns.Item("status").Cells.Item(i).Specific
                                If ocombo.Selected.Value = "O" Then nextlineid = i : Exit For
                            Next
                            objmatrix.Columns.Item("amount").Cells.Item(nextlineid).Specific.string = Convert.ToDouble(objmatrix.Columns.Item("amount").Cells.Item(Current_Lineid).Specific.String) + Convert.ToDouble(objmatrix.Columns.Item("amount").Cells.Item(nextlineid).Specific.string)
                            objmatrix.Columns.Item("amount").Cells.Item(Current_Lineid).Specific.string = 0
                            ocombo = objmatrix.Columns.Item("status").Cells.Item(Current_Lineid).Specific
                            ocombo.Select("C", SAPbouiCOM.BoSearchKey.psk_ByValue)
                            objmatrix.Columns.Item("detail").Cells.Item(Current_Lineid).Specific.string = "Moved to Next Month"
                            objmatrix.Columns.Item("amount").Cells.Item(nextlineid).Click(SAPbouiCOM.BoCellClickType.ct_Regular)
                            loanmatrix_roweditable(objmatrix, Current_Lineid, False)
                            loanmatrix_roweditable(objmatrix, nextlineid, True)
                            objaddon.objapplication.Menus.Item("1300").Activate()
                            If objform.Mode = BoFormMode.fm_OK_MODE Then objform.Mode = BoFormMode.fm_UPDATE_MODE
                            Current_Lineid = -1
                            objform.Freeze(False)
                        Case "NEWM" 'Move to New Month
                            objaddon.objglobalmethods.RightClickMenu_Delete("1280", "NEWM")
                            Dim effdate As Date, maxdate As Date
                            objform.Freeze(True)
                            objmatrix = objform.Items.Item("mtloan").Specific
                            loanmatrix_roweditable(objmatrix, Current_Lineid, False)
                            maxdate = objmatrix.Columns.Item("date").Cells.Item(1).Specific.string
                            For i As Integer = 1 To objmatrix.VisualRowCount
                                effdate = objmatrix.Columns.Item("date").Cells.Item(i).Specific.string
                                If maxdate < effdate Then maxdate = effdate
                            Next
                            effdate = maxdate.AddMonths(1)
                            objmatrix.AddRow(1)
                            objmatrix.Columns.Item("#").Cells.Item(objmatrix.VisualRowCount).Specific.string = objmatrix.VisualRowCount
                            objmatrix.Columns.Item("amount").Cells.Item(objmatrix.VisualRowCount).Specific.string = Convert.ToDouble(objmatrix.Columns.Item("amount").Cells.Item(Current_Lineid).Specific.String)
                            objmatrix.Columns.Item("date").Cells.Item(objmatrix.VisualRowCount).Specific.string = effdate.ToString("dd/MM/yyyy")
                            ocombo = objmatrix.Columns.Item("status").Cells.Item(objmatrix.VisualRowCount).Specific
                            ocombo.Select("O", BoSearchKey.psk_ByValue)
                            objmatrix.Columns.Item("amount").Cells.Item(Current_Lineid).Specific.string = 0
                            ocombo = objmatrix.Columns.Item("status").Cells.Item(Current_Lineid).Specific
                            ocombo.Select("C", SAPbouiCOM.BoSearchKey.psk_ByValue)
                            chkpayroll = objmatrix.Columns.Item("chkded").Cells.Item(objmatrix.VisualRowCount).Specific
                            chkpayroll.Checked = True
                            objmatrix.Columns.Item("detail").Cells.Item(Current_Lineid).Specific.string = "Moved to New Month"
                            objmatrix.Columns.Item("amount").Cells.Item(Current_Lineid + 1).Click(SAPbouiCOM.BoCellClickType.ct_Regular)
                            objaddon.objapplication.Menus.Item("1300").Activate()
                            loanmatrix_roweditable(objmatrix, objmatrix.VisualRowCount, True)
                            If objform.Mode = BoFormMode.fm_OK_MODE Then objform.Mode = BoFormMode.fm_UPDATE_MODE
                            objform.Freeze(False)
                            Current_Lineid = -1
                            'Case "CPY"
                            '    objaddon.objglobalmethods.RightClickMenu_Delete("1280", "CPY")
                            '    objmatrix = objform.Items.Item("mtloan").Specific
                            '    objform.Freeze(True)
                            '    ocombo = objmatrix.Columns.Item("status").Cells.Item(Current_Lineid).Specific
                            '    ocombo.Select("D", SAPbouiCOM.BoSearchKey.psk_ByValue)
                            '    chkpayroll = objmatrix.Columns.Item("chkded").Cells.Item(Current_Lineid).Specific
                            '    chkpayroll.Item.Click(BoCellClickType.ct_Regular)
                            '    objmatrix.Columns.Item("detail").Cells.Item(Current_Lineid).Specific.string = "Cash Payment"
                            '    If Current_Lineid + 1 <= objmatrix.VisualRowCount Then objmatrix.Columns.Item("amount").Cells.Item(Current_Lineid + 1).Click(SAPbouiCOM.BoCellClickType.ct_Regular) Else objform.Items.Item("Item_35").Click(BoCellClickType.ct_Regular)
                            '    objaddon.objapplication.Menus.Item("1300").Activate()
                            '    loanmatrix_roweditable(objmatrix, Current_Lineid, False)
                            '    If objform.Mode = BoFormMode.fm_OK_MODE Then objform.Mode = BoFormMode.fm_UPDATE_MODE
                            '    objform.Freeze(False)
                            '    Current_Lineid = -1
                        Case "FHD" 'History
                            objaddon.objglobalmethods.RightClickMenu_Delete("1280", "FHD")
                            Link_objtype = "TRANOLAP_FHD"
                            Link_Value = objform.Items.Item("txtempid").Specific.string
                            Dim activeform As New FrmHistory
                            activeform.Show()
                        Case "SHD" 'History
                            objaddon.objglobalmethods.RightClickMenu_Delete("1280", "SHD")
                            Link_objtype = "TRANOLAP_SHD"
                            Link_Value = objform.Items.Item("txtempid").Specific.string
                            Link_Value_Additional = objform.Items.Item("txtlcode").Specific.string
                            Dim activeform As New FrmHistory
                            activeform.Show()
                    End Select
                End If
            Catch ex As Exception
                objaddon.objapplication.SetStatusBarMessage("Error in LoanMaster Menu Event" + ex.ToString, SAPbouiCOM.BoMessageTime.bmt_Medium, True)
            End Try
        End Sub

        Private Sub loanmatrix_roweditable(ByVal objmatrix As SAPbouiCOM.Matrix, ByVal rowno As Integer, ByVal editable As Boolean)
            objmatrix.CommonSetting.SetRowEditable(rowno, editable)
            objmatrix.Columns.Item("pamt").Editable = False
            objmatrix.Columns.Item("status").Editable = False
            objmatrix.Columns.Item("detail").Editable = False
            objmatrix.Columns.Item("trtype").Editable = False
            objmatrix.Columns.Item("docno").Editable = False
        End Sub
#End Region

#Region "Leave Application"

        Private Sub LeaveApplication_MenuEvent(ByVal pval As SAPbouiCOM.MenuEvent, ByVal BubbleEvent As Boolean)
            Try
                objform = objaddon.objapplication.Forms.ActiveForm
                If pval.BeforeAction = True Then
                    Select Case pval.MenuUID
                    End Select
                Else
                    Select Case pval.MenuUID
                        Case "1281" 'Find Mode
                            objform.Items.Item("txtiempid").Click(BoCellClickType.ct_Regular)
                        Case "1282" 'Add mode
                            objform.Items.Item("txtentry").Specific.string = objaddon.objglobalmethods.GetNextDocentry_Value("[@SMPR_OLVA]")
                            objform.Items.Item("txtddate").Specific.string = Now.Date.ToString("dd.MM.yyyy")
                            objform.Title = "Leave Application"
                            objform.Items.Item("txtiempid").Click(BoCellClickType.ct_Regular)
                        Case "HD" 'History
                            objaddon.objglobalmethods.RightClickMenu_Delete("1280", "HD")
                            Link_objtype = "TRANOLVA"
                            Link_Value = objform.Items.Item("txtempid").Specific.string
                            Dim activeform As New FrmHistory
                            activeform.Show()
                    End Select
                End If
            Catch ex As Exception
                objaddon.objapplication.SetStatusBarMessage("Error in Leave Application Menu Event" + ex.ToString, SAPbouiCOM.BoMessageTime.bmt_Medium, True)
            End Try
        End Sub

#End Region

#Region "Daily Attendance"

        Private Sub Dailyattendance_MenuEvent(ByRef pval As SAPbouiCOM.MenuEvent, ByRef BubbleEvent As Boolean)
            Try
                objform = objaddon.objapplication.Forms.ActiveForm
                If pval.BeforeAction = True Then
                    Select Case pval.MenuUID
                        Case "1293" 'Delete Row
                            objaddon.objapplication.SetStatusBarMessage("Use Delete Row Button to delete a Row", SAPbouiCOM.BoMessageTime.bmt_Short, True)
                            BubbleEvent = False
                        Case "1283", "1284" 'Remove & Cancel
                            objaddon.objapplication.SetStatusBarMessage("Remove or Cancel is not allowed in Daily Attendance", SAPbouiCOM.BoMessageTime.bmt_Short, True)
                            BubbleEvent = False
                    End Select
                Else
                    Select Case pval.MenuUID
                        Case "1281" 'Find Mode
                            objform.Items.Item("txtadate").Click(SAPbouiCOM.BoCellClickType.ct_Regular)
                        Case "1282" ' Add Mode
                            objform.Items.Item("txtdocdt").Specific.string = Now.Date.ToString("dd.MM.yyyy")
                            objform.Items.Item("txtdentry").Specific.string = objaddon.objglobalmethods.GetNextDocentry_Value("[@SMPR_ODAS]")
                            objform.ActiveItem = "txtadate"
                    End Select
                End If
            Catch ex As Exception
                objform.Freeze(False)
                objaddon.objapplication.SetStatusBarMessage("Error in DailyAttendance Menu Event" + ex.ToString, SAPbouiCOM.BoMessageTime.bmt_Medium, True)
            End Try
        End Sub

#End Region

#Region "Addition/Deduction"

        Private Sub Addition_Deduction_MenuEvent(ByRef pval As SAPbouiCOM.MenuEvent, ByRef BubbleEvent As Boolean)
            Try
                objform = objaddon.objapplication.Forms.ActiveForm
                If pval.BeforeAction = True Then
                    Select Case pval.MenuUID
                        Case "1293" 'Delete Row
                            Dim objmatrix As SAPbouiCOM.Matrix = objform.Items.Item("Item_17").Specific
                            If objmatrix.VisualRowCount = 1 Then
                                objaddon.objapplication.SetStatusBarMessage("This Row Cannot be Deleted.Only One row avaialble", SAPbouiCOM.BoMessageTime.bmt_Short, True)
                                BubbleEvent = False
                            End If
                        Case "1283" 'Remove & Cancel
                            objaddon.objapplication.SetStatusBarMessage("Remove not allowed in Addition/Deduction", SAPbouiCOM.BoMessageTime.bmt_Short, True)
                            BubbleEvent = False
                        Case "1284"
                            Dim ocombo As SAPbouiCOM.ComboBox = objform.Items.Item("cmbstatus").Specific
                            If ocombo.Selected.Value.ToString.ToUpper <> "O" Then
                                objaddon.objapplication.SetStatusBarMessage("Cancel not allowed for Closed Addition/Deduction", SAPbouiCOM.BoMessageTime.bmt_Short, True)
                                BubbleEvent = False
                            End If
                    End Select
                Else
                    Select Case pval.MenuUID
                        Case "1281" 'Find Mode
                            objform.Items.Item("txtdocno").Click(SAPbouiCOM.BoCellClickType.ct_Regular)
                        Case "1282" ' Add Mode
                            objform.Items.Item("txtdate").Specific.string = DateTime.Now.ToString("dd.MM.yyyy")
                            objform.Items.Item("txtentry").Specific.string = objaddon.objglobalmethods.GetNextDocentry_Value("[@SMPR_OPAD]")
                            objform.ActiveItem = "cmbperiod"
                        Case "1293" 'Delete Row
                            Dim objmatrix As SAPbouiCOM.Matrix = objform.Items.Item("Item_17").Specific
                            For i As Integer = objmatrix.VisualRowCount To 1 Step -1
                                objmatrix.Columns.Item("#").Cells.Item(i).Specific.String = i
                            Next
                        Case "1292" 'Addrow
                            Dim objmatrix As SAPbouiCOM.Matrix = objform.Items.Item("Item_17").Specific
                            If objmatrix.VisualRowCount > 0 Then If objmatrix.Columns.Item("trzid").Cells.Item(objmatrix.VisualRowCount).Specific.string = "" Then Exit Sub
                            objmatrix.AddRow(1)
                            objmatrix.ClearRowData(objmatrix.VisualRowCount)
                            objmatrix.Columns.Item("#").Cells.Item(objmatrix.VisualRowCount).Specific.string = objmatrix.VisualRowCount
                            objmatrix.Columns.Item("date").Cells.Item(objmatrix.VisualRowCount).Specific.string = objform.Items.Item("txttdate").Specific.string
                    End Select
                End If
            Catch ex As Exception
                objform.Freeze(False)
                objaddon.objapplication.SetStatusBarMessage("Error in Addition/Deduction Menu Event" + ex.ToString, SAPbouiCOM.BoMessageTime.bmt_Medium, True)
            End Try
        End Sub

#End Region

#Region "Air Ticket Issue Form"

        Private Sub AirTicket_Issue_MenuEvent(ByRef pval As SAPbouiCOM.MenuEvent, ByRef BubbleEvent As Boolean)
            Try
                objform = objaddon.objapplication.Forms.ActiveForm
                If pval.BeforeAction = True Then
                    Select Case pval.MenuUID
                        Case "1283" 'Remove & Cancel
                            objaddon.objapplication.SetStatusBarMessage("Remove or Cancel is not allowed in Air Ticket Issue Screen", SAPbouiCOM.BoMessageTime.bmt_Short, True)
                            BubbleEvent = False
                        Case "1284"
                            Dim ocombo As SAPbouiCOM.ComboBox = objform.Items.Item("cmbstatus").Specific
                            If ocombo.Selected.Value.ToString.ToUpper = "C" Then
                                objaddon.objapplication.SetStatusBarMessage("Cancel not allowed for Closed Air Ticket Claim", SAPbouiCOM.BoMessageTime.bmt_Short, True)
                                BubbleEvent = False
                            End If
                        Case "HD", "SP"
                    End Select
                Else
                    Select Case pval.MenuUID
                        Case "1281" 'Find Mode
                            objform.Items.Item("txtdocno").Click(SAPbouiCOM.BoCellClickType.ct_Regular)
                        Case "1282" ' Add Mode
                            objform.Freeze(True)
                            objform.Items.Item("txtentry").Specific.string = objaddon.objglobalmethods.GetNextDocentry_Value("[@SMPR_OTIS]")
                            objform.Items.Item("txtddate").Specific.string = DateTime.Now.ToString("dd.MM.yyyy")
                            objform.Items.Item("txttidate").Specific.string = DateTime.Now.ToString("dd.MM.yyyy")
                            objform.ActiveItem = "txttrzid"
                            objform.Freeze(False)
                        Case "HD"
                            objaddon.objglobalmethods.RightClickMenu_Delete("1280", "HD")
                            objaddon.objglobalmethods.RightClickMenu_Delete("1280", "SP")
                            Link_objtype = "OTIS_HD"
                            Link_Value = objform.Items.Item("txtempid").Specific.string
                            Dim activeform As New FrmHistory
                            activeform.Show()
                        Case "SP"
                            objaddon.objglobalmethods.RightClickMenu_Delete("1280", "HD")
                            objaddon.objglobalmethods.RightClickMenu_Delete("1280", "SP")
                            Link_objtype = "OTIS_SP"
                            Link_Value = objform.Items.Item("txtempid").Specific.string
                            Dim activeform As New FrmHistory
                            activeform.Show()
                    End Select
                End If
            Catch ex As Exception
                objform.Freeze(False)
                objaddon.objapplication.SetStatusBarMessage("Error in AirTicket Issue Menu Event" + ex.ToString, SAPbouiCOM.BoMessageTime.bmt_Medium, True)
            End Try
        End Sub

#End Region

#Region "Settlement"

        Private Sub Settlement_MenuEvent(ByRef pval As SAPbouiCOM.MenuEvent, ByRef BubbleEvent As Boolean)
            Try
                objform = objaddon.objapplication.Forms.ActiveForm
                If pval.BeforeAction = True Then
                    Select Case pval.MenuUID
                        Case "1283", "1284" 'Remove & Cancel
                            objaddon.objapplication.SetStatusBarMessage("Remove or Cancel is not allowed in Air Ticket Issue Screen", SAPbouiCOM.BoMessageTime.bmt_Short, True)
                            BubbleEvent = False
                        Case "1293"
                            Dim omatrix As SAPbouiCOM.Matrix
                            omatrix = objform.Items.Item("mtaddded").Specific
                            If omatrix.VisualRowCount = 1 Then objaddon.objapplication.SetStatusBarMessage("Only one row available.It Cannot be deleted", SAPbouiCOM.BoMessageTime.bmt_Short, True) : BubbleEvent = False
                    End Select
                Else
                    Select Case pval.MenuUID
                        Case "1293"
                            Dim omatrix As SAPbouiCOM.Matrix
                            omatrix = objform.Items.Item("mtaddded").Specific
                            For i As Integer = 1 To omatrix.VisualRowCount : omatrix.Columns.Item("#").Cells.Item(i).Specific.string = i : Next
                        Case "1281" 'Find Mode
                            objform.ActiveItem = "txtdocno"
                            'objform.Items.Item("txtdocno").Click(SAPbouiCOM.BoCellClickType.ct_Regular)
                        Case "1282" ' Add Mode
                            Dim ocombo As SAPbouiCOM.ComboBox
                            ocombo = objform.Items.Item("cmbtype").Specific
                            ocombo.Select("LS", SAPbouiCOM.BoSearchKey.psk_ByValue)
                            objform.Items.Item("txtdate").Specific.string = Now.Date.ToString("dd.MM.yyyy")
                            objform.Items.Item("txtdocdt").Specific.string = Now.Date.ToString("dd.MM.yyyy")
                            objform.Items.Item("txtentry").Specific.string = objaddon.objglobalmethods.GetNextDocentry_Value("[@SMPR_OLSE]")
                            objform.ActiveItem = "txttrzid"
                    End Select
                End If
            Catch ex As Exception
                objform.Freeze(False)
                objaddon.objapplication.SetStatusBarMessage("Error in AirTicket Issue Menu Event" + ex.ToString, SAPbouiCOM.BoMessageTime.bmt_Medium, True)
            End Try
        End Sub

#End Region

#Region "Payroll Process"

        Private Sub PayrollProcess_MenuEvent(ByRef pval As SAPbouiCOM.MenuEvent, ByRef BubbleEvent As Boolean)
            Try
                objform = objaddon.objapplication.Forms.ActiveForm
                If pval.BeforeAction = True Then
                    Select Case pval.MenuUID
                        Case "1283", "1284" 'Remove & Cancel
                            objaddon.objapplication.SetStatusBarMessage("Remove or Cancel is not allowed in Payroll Process Screen", SAPbouiCOM.BoMessageTime.bmt_Short, True)
                            BubbleEvent = False
                        Case "1293"
                            BubbleEvent = False
                    End Select
                Else
                    Select Case pval.MenuUID
                        Case "1281" 'Find Mode
                            objform.ActiveItem = "txtdocno"
                            'objform.Items.Item("txtdocno").Click(SAPbouiCOM.BoCellClickType.ct_Regular)
                        Case "1282" ' Add Mode
                            objform.Items.Item("txtdate").Specific.string = Now.Date.ToString("dd.MM.yyyy")
                            objform.Items.Item("txtlocc").Specific.string = "#"
                            objform.Items.Item("txtentry").Specific.string = objaddon.objglobalmethods.GetNextDocentry_Value("[@SMPR_OPRC]")
                            objform.ActiveItem = "cmbpay"
                        Case "PJE"
                            objaddon.objglobalmethods.RightClickMenu_Delete("1280", "PJE")
                            Link_objtype = "OPRC_PJE"
                            Link_Value = objform.Items.Item("txtentry").Specific.string
                            Dim activeform As New FrmHistory
                            activeform.Show()
                    End Select
                End If
            Catch ex As Exception
                objform.Freeze(False)
                objaddon.objapplication.SetStatusBarMessage("Error in Payroll Process Menu Event" + ex.ToString, SAPbouiCOM.BoMessageTime.bmt_Medium, True)
            End Try
        End Sub

#End Region

#Region "Account Determination"

        Private Sub Acct_Determination_MenuEvent(ByVal pval As SAPbouiCOM.MenuEvent, ByVal BubbleEvent As Boolean)
            Try
                objform = objaddon.objapplication.Forms.ActiveForm
                If pval.BeforeAction = True Then
                    Select Case pval.MenuUID
                        Case "1283", "1284"
                            objaddon.objapplication.SetStatusBarMessage("Account Determination Remove or Cancel is not allowed", SAPbouiCOM.BoMessageTime.bmt_Short, True)
                            BubbleEvent = False
                    End Select
                Else
                    Select Case pval.MenuUID
                        Case "1281"
                            objform.ActiveItem = "cmbtype"
                        Case "1282"
                            objform.Items.Item("txtcode").Specific.string = objaddon.objglobalmethods.GetNextCode_Value("[@SMPR_ACCT]")
                            objform.ActiveItem = "cmbtype"
                    End Select
                End If
            Catch ex As Exception
                objaddon.objapplication.SetStatusBarMessage("Error in Account Determination Menu Event" + ex.ToString, SAPbouiCOM.BoMessageTime.bmt_Medium, True)
            End Try
        End Sub

#End Region

#Region "Provision Process"

        Private Sub ProvisionProcess_MenuEvent(ByRef pval As SAPbouiCOM.MenuEvent, ByRef BubbleEvent As Boolean)
            Try
                objform = objaddon.objapplication.Forms.ActiveForm
                If pval.BeforeAction = True Then
                Else
                    Select Case pval.MenuUID
                        Case "PRJE"
                            Dim ogrid As SAPbouiCOM.Grid
                            ogrid = objform.Items.Item("grd").Specific
                            If ogrid.DataTable.GetValue(ogrid.DataTable.Columns.Count - 1, 0) = "" Then Exit Sub
                            objaddon.objglobalmethods.RightClickMenu_Delete("1280", "PRJE")
                            Link_objtype = "PROV_PJE"
                            Link_Value = ogrid.DataTable.GetValue(ogrid.DataTable.Columns.Count - 1, 0)
                            Dim activeform As New FrmHistory
                            activeform.Show()
                    End Select
                End If
            Catch ex As Exception
                objform.Freeze(False)
                objaddon.objapplication.SetStatusBarMessage("Error in Payroll Process Menu Event" + ex.ToString, SAPbouiCOM.BoMessageTime.bmt_Medium, True)
            End Try
        End Sub

#End Region
    End Class
End Namespace