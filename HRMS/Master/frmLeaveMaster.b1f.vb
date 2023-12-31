﻿Option Strict Off
Option Explicit On
Imports SAPbouiCOM.Framework

Namespace HRMS
    <FormAttribute("MSTRLEVE", "Master/frmLeaveMaster.b1f")>
    Friend Class frmLeaveMaster
        Inherits UserFormBase
        Dim FormCount As Integer = 0
        Private WithEvents objform As SAPbouiCOM.Form

        Public Sub New()

        End Sub

        Public Overrides Sub OnInitializeComponent()
            Me.StaticText0 = CType(Me.GetItem("lblcode").Specific, SAPbouiCOM.StaticText)
            Me.EditText0 = CType(Me.GetItem("txtcode").Specific, SAPbouiCOM.EditText)
            Me.StaticText1 = CType(Me.GetItem("lblname").Specific, SAPbouiCOM.StaticText)
            Me.EditText1 = CType(Me.GetItem("txtname").Specific, SAPbouiCOM.EditText)
            Me.StaticText3 = CType(Me.GetItem("lblleaves").Specific, SAPbouiCOM.StaticText)
            Me.EditText3 = CType(Me.GetItem("txtleaves").Specific, SAPbouiCOM.EditText)
            Me.StaticText4 = CType(Me.GetItem("lblcarry").Specific, SAPbouiCOM.StaticText)
            Me.EditText4 = CType(Me.GetItem("txtcarry").Specific, SAPbouiCOM.EditText)
            Me.StaticText5 = CType(Me.GetItem("lblremarks").Specific, SAPbouiCOM.StaticText)
            Me.StaticText6 = CType(Me.GetItem("Item_12").Specific, SAPbouiCOM.StaticText)
            Me.ComboBox0 = CType(Me.GetItem("cmelvebsd").Specific, SAPbouiCOM.ComboBox)
            Me.CheckBox0 = CType(Me.GetItem("chkcarry").Specific, SAPbouiCOM.CheckBox)
            Me.CheckBox1 = CType(Me.GetItem("chkhalfday").Specific, SAPbouiCOM.CheckBox)
            Me.CheckBox2 = CType(Me.GetItem("chkpayable").Specific, SAPbouiCOM.CheckBox)
            Me.CheckBox3 = CType(Me.GetItem("chkactive").Specific, SAPbouiCOM.CheckBox)
            Me.EditText7 = CType(Me.GetItem("txtremarks").Specific, SAPbouiCOM.EditText)
            Me.Button0 = CType(Me.GetItem("1").Specific, SAPbouiCOM.Button)
            Me.Button1 = CType(Me.GetItem("2").Specific, SAPbouiCOM.Button)
            Me.CheckBox4 = CType(Me.GetItem("Item_0").Specific, SAPbouiCOM.CheckBox)
            Me.OnCustomInitialize()

        End Sub

        Public Overrides Sub OnInitializeFormEvents()
            'AddHandler DataLoadAfter, AddressOf Me.frmLeaveMaster_DataLoadAfter
        End Sub

        Private Sub OnCustomInitialize()
            Try
                objform = objaddon.objapplication.Forms.GetForm("MSTRLEVE", Me.FormCount)
                objform.EnableMenu("1283", False) 'Remove menu
                objform.EnableMenu("1284", False) 'Cancel Menu
                If objaddon.objcompany.UserName.ToString.ToUpper <> "MANAGER" Then objform.EnableMenu("6913", False) 'User Defined Field
                objform = objaddon.objapplication.Forms.ActiveForm
                objform.Freeze(True)
                form_format()
                If Link_Value.ToString <> "-1" And Link_objtype.ToString.ToUpper = "MSTRLEVE" Then
                    objform.Mode = SAPbouiCOM.BoFormMode.fm_FIND_MODE
                    EditText0.Value = Link_Value
                    objform.Items.Item("1").Click(SAPbouiCOM.BoCellClickType.ct_Regular)
                    Link_Value = "-1" : Link_objtype = "-1"
                End If
                objform.Freeze(False)
            Catch ex As Exception
                objform.Freeze(False)
            End Try
        End Sub

        Private Sub form_format()
            Try
                CheckBox0.Item.Height = CheckBox0.Item.Height + 3
                CheckBox1.Item.Height = CheckBox1.Item.Height + 3
                CheckBox2.Item.Height = CheckBox2.Item.Height + 3
                CheckBox3.Item.Height = CheckBox3.Item.Height + 3
                CheckBox4.Item.Height = CheckBox4.Item.Height + 3
            Catch ex As Exception

            End Try
        End Sub

#Region "Field Details"

        Private WithEvents StaticText0 As SAPbouiCOM.StaticText
        Private WithEvents EditText0 As SAPbouiCOM.EditText
        Private WithEvents StaticText1 As SAPbouiCOM.StaticText
        Private WithEvents EditText1 As SAPbouiCOM.EditText
        Private WithEvents StaticText3 As SAPbouiCOM.StaticText
        Private WithEvents EditText3 As SAPbouiCOM.EditText
        Private WithEvents StaticText4 As SAPbouiCOM.StaticText
        Private WithEvents EditText4 As SAPbouiCOM.EditText
        Private WithEvents StaticText5 As SAPbouiCOM.StaticText
        Private WithEvents StaticText6 As SAPbouiCOM.StaticText
        Private WithEvents ComboBox0 As SAPbouiCOM.ComboBox
        Private WithEvents CheckBox0 As SAPbouiCOM.CheckBox
        Private WithEvents CheckBox1 As SAPbouiCOM.CheckBox
        Private WithEvents CheckBox2 As SAPbouiCOM.CheckBox
        Private WithEvents CheckBox3 As SAPbouiCOM.CheckBox
        Private WithEvents EditText7 As SAPbouiCOM.EditText
        Private WithEvents Button0 As SAPbouiCOM.Button
        Private WithEvents CheckBox4 As SAPbouiCOM.CheckBox
        Private WithEvents Button1 As SAPbouiCOM.Button

#End Region

        Private Sub frmLeaveMaster_DataLoadAfter(ByRef pVal As SAPbouiCOM.BusinessObjectInfo) Handles Me.DataLoadAfter
            objform = objaddon.objapplication.Forms.GetForm("MSTRLEVE", Me.FormCount)
            If objform.Mode = SAPbouiCOM.BoFormMode.fm_OK_MODE And objform.Items.Item("txtcode").Enabled = True Then
                objform.Items.Item("txtname").Click(SAPbouiCOM.BoCellClickType.ct_Regular)
                objform.Items.Item("txtcode").Enabled = False
            End If
        End Sub

        Private Sub EditText4_LostFocusAfter(sboObject As Object, pVal As SAPbouiCOM.SBOItemEventArg) Handles EditText4.LostFocusAfter
            Dim ochk As SAPbouiCOM.CheckBox
            ochk = objform.Items.Item("chkcarry").Specific
            If Val(objform.Items.Item("txtcarry").Specific.string) Then ochk.Checked = True Else ochk.Checked = False
        End Sub


    End Class
End Namespace
