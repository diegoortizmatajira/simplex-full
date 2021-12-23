object frmPrincipal: TfrmPrincipal
  Left = 247
  Top = 199
  Width = 643
  Height = 467
  ActiveControl = txtVariables
  Caption = 'Simplex - Universidad Industrial de Santander'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 8
    Top = 16
    Width = 615
    Height = 417
    ActivePage = TabSheet1
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Ingreso de Datos'
      object Label1: TLabel
        Left = 8
        Top = 6
        Width = 55
        Height = 26
        Caption = 'Número de Variables'
        WordWrap = True
      end
      object Label2: TLabel
        Left = 152
        Top = 6
        Width = 64
        Height = 26
        Caption = 'Número de Restricciones'
        WordWrap = True
      end
      object Label3: TLabel
        Left = 8
        Top = 72
        Width = 80
        Height = 13
        Caption = 'Función Objetivo'
      end
      object Label4: TLabel
        Left = 8
        Top = 144
        Width = 64
        Height = 13
        Caption = 'Restricciones'
      end
      object txtVariables: TEdit
        Left = 72
        Top = 10
        Width = 41
        Height = 21
        TabOrder = 0
        Text = '2'
      end
      object udVariables: TUpDown
        Left = 113
        Top = 10
        Width = 15
        Height = 21
        Associate = txtVariables
        Min = 1
        Max = 10
        Position = 2
        TabOrder = 1
        Wrap = False
      end
      object txtRestricciones: TEdit
        Left = 224
        Top = 10
        Width = 41
        Height = 21
        TabOrder = 2
        Text = '3'
      end
      object udRestricciones: TUpDown
        Left = 265
        Top = 10
        Width = 15
        Height = 21
        Associate = txtRestricciones
        Min = 1
        Max = 10
        Position = 3
        TabOrder = 3
        Wrap = False
      end
      object grObjetivo: TStringGrid
        Left = 8
        Top = 88
        Width = 591
        Height = 46
        Anchors = [akLeft, akTop, akRight]
        ColCount = 2
        DefaultColWidth = 70
        DefaultRowHeight = 20
        RowCount = 2
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goEditing, goTabs]
        ParentFont = False
        TabOrder = 5
      end
      object grRestricciones: TStringGrid
        Left = 8
        Top = 160
        Width = 591
        Height = 217
        Anchors = [akLeft, akTop, akRight, akBottom]
        ColCount = 2
        DefaultColWidth = 70
        DefaultRowHeight = 20
        RowCount = 2
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goEditing, goTabs]
        ParentFont = False
        TabOrder = 6
      end
      object Button1: TButton
        Left = 8
        Top = 40
        Width = 73
        Height = 24
        Action = actAplicarCantidades
        TabOrder = 7
      end
      object Button2: TButton
        Left = 88
        Top = 40
        Width = 121
        Height = 24
        Action = actGenerarMatriz
        TabOrder = 8
      end
      object radObjetivo: TRadioGroup
        Left = 312
        Top = 8
        Width = 169
        Height = 65
        Caption = 'Objetivo'
        ItemIndex = 0
        Items.Strings = (
          'Maximizar'
          'Minimizar')
        TabOrder = 4
      end
      object Button4: TButton
        Left = 216
        Top = 40
        Width = 73
        Height = 25
        Caption = 'Ejemplo'
        TabOrder = 9
        OnClick = Button4Click
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Tabla Simplex'
      ImageIndex = 1
      object grMatriz: TStringGrid
        Left = 8
        Top = 56
        Width = 591
        Height = 325
        Anchors = [akLeft, akTop, akRight, akBottom]
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
        ParentFont = False
        TabOrder = 0
      end
      object Button3: TButton
        Left = 8
        Top = 8
        Width = 129
        Height = 25
        Action = actAjustarTabla
        TabOrder = 1
      end
      object Button5: TButton
        Left = 144
        Top = 8
        Width = 137
        Height = 25
        Action = actIterar
        TabOrder = 2
      end
      object Button6: TButton
        Left = 288
        Top = 8
        Width = 129
        Height = 25
        Action = actSolucionar
        TabOrder = 3
      end
    end
  end
  object ActionList1: TActionList
    Left = 24
    Top = 248
    object actAplicarCantidades: TAction
      Caption = '&Aplicar'
      ShortCut = 16449
      OnExecute = actAplicarCantidadesExecute
    end
    object actGenerarMatriz: TAction
      Caption = '&Generar Matriz'
      ShortCut = 16455
      OnExecute = actGenerarMatrizExecute
    end
    object actMostrarMatriz: TAction
      Caption = 'actMostrarMatriz'
      OnExecute = actMostrarMatrizExecute
    end
    object actAjustarTabla: TAction
      Caption = 'Ajustar Tabla (Ctrl + F1)'
      ShortCut = 16496
      OnExecute = actAjustarTablaExecute
    end
    object actIterar: TAction
      Caption = 'Iterar (Ctrl + F2)'
      ShortCut = 16497
      OnExecute = actIterarExecute
    end
    object actSolucionar: TAction
      Caption = 'Solucionar (Ctrl + F3)'
      ShortCut = 16498
      OnExecute = actSolucionarExecute
    end
  end
end
