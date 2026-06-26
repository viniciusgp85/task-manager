unit View.Main;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.JSON,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  Vcl.ExtCtrls,
  Vcl.Samples.Spin,
  Client.Service.Task;

type
  TfrmMain = class(TForm)
    pnlTop          : TPanel;
    lblTitle        : TLabel;
    pnlForm         : TPanel;
    lblTitulo       : TLabel;
    edtTitle        : TEdit;
    lblDescricao    : TLabel;
    memDescription  : TMemo;
    lblStatus       : TLabel;
    cmbStatus       : TComboBox;
    lblPrioridade   : TLabel;
    spnPriority     : TSpinEdit;
    btnSave         : TButton;
    btnClear        : TButton;
    pgcMain         : TPageControl;
    tabTasks        : TTabSheet;
    tabStats        : TTabSheet;
    pnlToolbar      : TPanel;
    btnRefresh      : TButton;
    btnNew          : TButton;
    btnEdit         : TButton;
    btnDelete       : TButton;
    lvTasks         : TListView;
    pnlStats        : TPanel;
    lblTotalVal     : TLabel;
    lblTotalDesc    : TLabel;
    lblAvgVal       : TLabel;
    lblAvgDesc      : TLabel;
    lblCompletedVal : TLabel;
    lblCompletedDesc: TLabel;
    btnLoadStats    : TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnLoadStatsClick(Sender: TObject);
  private
    FEditingId: Integer;
    procedure CarregarTarefas;
    procedure PreencherLista(const AJSON: TJSONArray);
    procedure LimparFormulario;
    procedure ModoEdicao(const AAtivo: Boolean);
    procedure PopularComboStatus;
    function  ValidarFormulario: Boolean;
    function  ObterStatusSelecionado: string;
    procedure SelecionarStatus(const AStatus: string);
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

{ Inicialização }

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FEditingId := 0;
  PopularComboStatus;
  CarregarTarefas;
end;

procedure TfrmMain.PopularComboStatus;
begin
  cmbStatus.Items.Clear;
  cmbStatus.Items.Add('Pending');
  cmbStatus.Items.Add('InProgress');
  cmbStatus.Items.Add('Done');
  cmbStatus.ItemIndex := 0;
end;

{ Helpers de status }

function TfrmMain.ObterStatusSelecionado: string;
begin
  if cmbStatus.ItemIndex >= 0 then
    Result := cmbStatus.Items[cmbStatus.ItemIndex]
  else
    Result := 'Pending';
end;

procedure TfrmMain.SelecionarStatus(const AStatus: string);
var
  LIdx: Integer;
begin
  // Garante que o combo está populado antes de selecionar
  if cmbStatus.Items.Count = 0 then
    PopularComboStatus;

  LIdx := cmbStatus.Items.IndexOf(AStatus);

  if LIdx >= 0 then
    cmbStatus.ItemIndex := LIdx
  else
    cmbStatus.ItemIndex := 0;
end;

{ Listagem }

procedure TfrmMain.CarregarTarefas;
var
  LArray: TJSONArray;
begin
  try
    LArray := TTaskClientService.GetAll;
    try
      PreencherLista(LArray);
    finally
      LArray.Free;
    end;
  except
    on E: Exception do
      ShowMessage('Erro ao carregar tarefas: ' + E.Message);
  end;
end;

procedure TfrmMain.PreencherLista(const AJSON: TJSONArray);
var
  LItem       : TListItem;
  LTarefa     : TJSONObject;
  LCompleted  : TJSONValue;
  I           : Integer;
begin
  lvTasks.Items.BeginUpdate;
  try
    lvTasks.Items.Clear;
    for I := 0 to AJSON.Count - 1 do
    begin
      LTarefa := AJSON.Items[I] as TJSONObject;
      LItem   := lvTasks.Items.Add;

      LItem.Caption := LTarefa.GetValue<string>('id');
      LItem.SubItems.Add(LTarefa.GetValue<string>('title'));
      LItem.SubItems.Add(LTarefa.GetValue<string>('status'));
      LItem.SubItems.Add(LTarefa.GetValue<string>('priority'));
      LItem.SubItems.Add(LTarefa.GetValue<string>('createdAt'));

      LCompleted := LTarefa.GetValue('completedAt');
      if (LCompleted = nil) or (LCompleted is TJSONNull) then
        LItem.SubItems.Add('—')
      else
        LItem.SubItems.Add(LCompleted.Value);
    end;
  finally
    lvTasks.Items.EndUpdate;
  end;
end;

{ Validação }

function TfrmMain.ValidarFormulario: Boolean;
begin
  Result := False;

  if Trim(edtTitle.Text) = '' then
  begin
    ShowMessage('O campo Título é obrigatório.');
    edtTitle.SetFocus;
    Exit;
  end;

  if cmbStatus.ItemIndex < 0 then
  begin
    ShowMessage('Selecione um Status para a tarefa.');
    cmbStatus.SetFocus;
    Exit;
  end;

  Result := True;
end;

{ Formulário }

procedure TfrmMain.LimparFormulario;
begin
  FEditingId := 0;
  edtTitle.Clear;
  memDescription.Clear;
  PopularComboStatus;
  spnPriority.Value := 1;
  ModoEdicao(False);
end;

procedure TfrmMain.ModoEdicao(const AAtivo: Boolean);
begin
  if AAtivo then
  begin
    btnSave.Caption  := 'Atualizar Tarefa';
    btnClear.Caption := 'Cancelar Edição';
  end
  else
  begin
    btnSave.Caption  := 'Salvar Tarefa';
    btnClear.Caption := 'Limpar';
  end;
end;

{ Eventos dos botões do formulário }

procedure TfrmMain.btnSaveClick(Sender: TObject);
var
  LJSON  : TJSONObject;
  LResult: TJSONObject;
begin
  if not ValidarFormulario then
    Exit;

  LJSON := TJSONObject.Create;
  try
    LJSON.AddPair('title',       Trim(edtTitle.Text));
    LJSON.AddPair('description', Trim(memDescription.Text));
    LJSON.AddPair('status',      ObterStatusSelecionado);
    LJSON.AddPair('priority',    TJSONNumber.Create(spnPriority.Value));

    try
      if FEditingId = 0 then
      begin
        LResult := TTaskClientService.Insert(LJSON);
        LResult.Free;
        ShowMessage('Tarefa cadastrada com sucesso!');
      end
      else
      begin
        LResult := TTaskClientService.Update(FEditingId, LJSON);
        LResult.Free;
        ShowMessage('Tarefa atualizada com sucesso!');
      end;

      LimparFormulario;
      CarregarTarefas;
    except
      on E: Exception do
        ShowMessage('Erro ao salvar tarefa: ' + E.Message);
    end;
  finally
    LJSON.Free;
  end;
end;

procedure TfrmMain.btnClearClick(Sender: TObject);
begin
  LimparFormulario;
end;

{ Eventos dos botões da lista }

procedure TfrmMain.btnRefreshClick(Sender: TObject);
begin
  CarregarTarefas;
end;

procedure TfrmMain.btnNewClick(Sender: TObject);
begin
  LimparFormulario;
  edtTitle.SetFocus;
end;

procedure TfrmMain.btnEditClick(Sender: TObject);
var
  LId    : Integer;
  LTarefa: TJSONObject;
begin
  if not Assigned(lvTasks.Selected) then
  begin
    ShowMessage('Selecione uma tarefa na lista para editar.');
    Exit;
  end;

  LId := StrToIntDef(lvTasks.Selected.Caption, 0);
  if LId = 0 then
    Exit;

  try
    LTarefa := TTaskClientService.GetById(LId);
    try
      FEditingId := LId;

      edtTitle.Text       := LTarefa.GetValue<string>('title');
      memDescription.Text := LTarefa.GetValue<string>('description');
      spnPriority.Value   := LTarefa.GetValue<Integer>('priority');

      // Garante que o combo está populado e seleciona o status correto
      SelecionarStatus(LTarefa.GetValue<string>('status'));

      ModoEdicao(True);
      edtTitle.SetFocus;
    finally
      LTarefa.Free;
    end;
  except
    on E: Exception do
      ShowMessage('Erro ao carregar tarefa: ' + E.Message);
  end;
end;

procedure TfrmMain.btnDeleteClick(Sender: TObject);
var
  LId: Integer;
begin
  if not Assigned(lvTasks.Selected) then
  begin
    ShowMessage('Selecione uma tarefa na lista para excluir.');
    Exit;
  end;

  LId := StrToIntDef(lvTasks.Selected.Caption, 0);
  if LId = 0 then
    Exit;

  if MessageDlg(
    'Deseja realmente excluir a tarefa selecionada?',
    mtConfirmation, [mbYes, mbNo], 0
  ) <> mrYes then
    Exit;

  try
    TTaskClientService.Delete(LId);
    ShowMessage('Tarefa excluída com sucesso!');
    LimparFormulario;
    CarregarTarefas;
  except
    on E: Exception do
      ShowMessage('Erro ao excluir tarefa: ' + E.Message);
  end;
end;

{ Estatísticas }

procedure TfrmMain.btnLoadStatsClick(Sender: TObject);
var
  LStats: TJSONObject;
begin
  try
    LStats := TTaskClientService.GetStats;
    try
      lblTotalVal.Caption     := LStats.GetValue<string>('totalTasks');
      lblAvgVal.Caption       := LStats.GetValue<string>('avgPriorityPending');
      lblCompletedVal.Caption := LStats.GetValue<string>('completedLast7Days');
    finally
      LStats.Free;
    end;
  except
    on E: Exception do
      ShowMessage('Erro ao carregar estatísticas: ' + E.Message);
  end;
end;

end.
