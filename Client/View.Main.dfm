object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Task Manager - BDMG'
  ClientHeight = 650
  ClientWidth = 1000
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 1000
    Height = 55
    Align = alTop
    BevelOuter = bvNone
    Color = 2105376
    TabOrder = 0
    object lblTitle: TLabel
      Left = 0
      Top = 0
      Width = 1000
      Height = 55
      Align = alClient
      Alignment = taCenter
      Caption = 'Task Manager - BDMG'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -21
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      ExplicitWidth = 218
      ExplicitHeight = 30
    end
  end
  object pnlForm: TPanel
    Left = 0
    Top = 55
    Width = 300
    Height = 595
    Align = alLeft
    BevelOuter = bvNone
    Color = clWhitesmoke
    TabOrder = 1
    object lblTitulo: TLabel
      Left = 16
      Top = 16
      Width = 38
      Height = 15
      Caption = 'T'#237'tulo *'
    end
    object lblDescricao: TLabel
      Left = 16
      Top = 72
      Width = 51
      Height = 15
      Caption = 'Descri'#231#227'o'
    end
    object lblStatus: TLabel
      Left = 16
      Top = 184
      Width = 32
      Height = 15
      Caption = 'Status'
    end
    object lblPrioridade: TLabel
      Left = 16
      Top = 240
      Width = 82
      Height = 15
      Caption = 'Prioridade (1-5)'
    end
    object edtTitle: TEdit
      Left = 16
      Top = 36
      Width = 268
      Height = 23
      TabOrder = 0
    end
    object memDescription: TMemo
      Left = 16
      Top = 92
      Width = 268
      Height = 80
      ScrollBars = ssVertical
      TabOrder = 1
    end
    object cmbStatus: TComboBox
      Left = 16
      Top = 204
      Width = 268
      Height = 23
      Style = csDropDownList
      TabOrder = 2
    end
    object spnPriority: TSpinEdit
      Left = 16
      Top = 260
      Width = 268
      Height = 24
      MaxValue = 5
      MinValue = 1
      TabOrder = 3
      Value = 1
    end
    object btnSave: TButton
      Left = 16
      Top = 308
      Width = 268
      Height = 35
      Caption = 'Salvar Tarefa'
      TabOrder = 4
      OnClick = btnSaveClick
    end
    object btnClear: TButton
      Left = 16
      Top = 352
      Width = 268
      Height = 35
      Caption = 'Limpar'
      TabOrder = 5
      OnClick = btnClearClick
    end
  end
  object pgcMain: TPageControl
    Left = 300
    Top = 55
    Width = 700
    Height = 595
    ActivePage = tabTasks
    Align = alClient
    TabOrder = 2
    object tabTasks: TTabSheet
      Caption = 'Tarefas'
      object pnlToolbar: TPanel
        Left = 0
        Top = 0
        Width = 692
        Height = 40
        Align = alTop
        BevelOuter = bvNone
        Color = clWhitesmoke
        TabOrder = 0
        object btnRefresh: TButton
          Left = 8
          Top = 6
          Width = 100
          Height = 28
          Caption = 'Atualizar'
          TabOrder = 0
          OnClick = btnRefreshClick
        end
        object btnNew: TButton
          Left = 116
          Top = 6
          Width = 120
          Height = 28
          Caption = 'Nova Tarefa'
          TabOrder = 1
          OnClick = btnNewClick
        end
        object btnEdit: TButton
          Left = 244
          Top = 6
          Width = 130
          Height = 28
          Caption = 'Editar Selecionada'
          TabOrder = 2
          OnClick = btnEditClick
        end
        object btnDelete: TButton
          Left = 382
          Top = 6
          Width = 130
          Height = 28
          Caption = 'Excluir Selecionada'
          TabOrder = 3
          OnClick = btnDeleteClick
        end
      end
      object lvTasks: TListView
        Left = 0
        Top = 40
        Width = 692
        Height = 525
        Align = alClient
        Columns = <
          item
            Caption = 'ID'
            Width = 40
          end
          item
            Caption = 'T'#237'tulo'
            Width = 160
          end
          item
            Caption = 'Status'
            Width = 90
          end
          item
            Caption = 'Prioridade'
            Width = 75
          end
          item
            Caption = 'Criado em'
            Width = 130
          end
          item
            Caption = 'Conclu'#237'do em'
            Width = 130
          end>
        GridLines = True
        ReadOnly = True
        RowSelect = True
        TabOrder = 1
        ViewStyle = vsReport
      end
    end
    object tabStats: TTabSheet
      Caption = 'Estat'#237'sticas'
      object pnlStats: TPanel
        Left = 146
        Top = 100
        Width = 400
        Height = 280
        BevelOuter = bvNone
        Color = clWhite
        TabOrder = 0
        object lblTotalVal: TLabel
          Left = 0
          Top = 16
          Width = 24
          Height = 40
          Alignment = taCenter
          Caption = '--'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -29
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblTotalDesc: TLabel
          Left = 0
          Top = 58
          Width = 80
          Height = 15
          Alignment = taCenter
          Caption = 'Total de Tarefas'
        end
        object lblAvgVal: TLabel
          Left = 0
          Top = 90
          Width = 24
          Height = 40
          Alignment = taCenter
          Caption = '--'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -29
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblAvgDesc: TLabel
          Left = 0
          Top = 132
          Width = 172
          Height = 15
          Alignment = taCenter
          Caption = 'M'#233'dia de Prioridade (Pendentes)'
        end
        object lblCompletedVal: TLabel
          Left = 0
          Top = 164
          Width = 24
          Height = 40
          Alignment = taCenter
          Caption = '--'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -29
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblCompletedDesc: TLabel
          Left = 0
          Top = 206
          Width = 157
          Height = 15
          Alignment = taCenter
          Caption = 'Conclu'#237'das nos '#250'ltimos 7 dias'
        end
        object btnLoadStats: TButton
          Left = 100
          Top = 232
          Width = 200
          Height = 35
          Caption = 'Carregar Estat'#237'sticas'
          TabOrder = 0
          OnClick = btnLoadStatsClick
        end
      end
    end
  end
end
