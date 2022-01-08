unit optionsDialog;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  IniFiles;

type

  { TOptions }

  TOptions = class(TForm)
    ButtonCancel: TButton;
    CheckBox1: TCheckBox;
    CheckGroup1: TCheckGroup;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    procedure ButtonCancelClick(Sender: TObject);
    procedure CheckGroup1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    function getMin1:integer;
    function getMax1:integer;
    function getMin2:integer;
    function getMax2:integer;
    function getOperations:string;
    function getGraterGrater:boolean;
    function noOperation:boolean;
    procedure saveOptions;
  public
     property Min1:integer read getMin1;
     property Max1:integer read getMax1;
     property Min2:integer read getMin2;
     property Max2:integer read getMax2;
     property Operations:string read getOperations;
     property FirstGrater:boolean read getGraterGrater;
  end;

var
  Options: TOptions; INIFile:TINIFile;

implementation

{$R *.lfm}

{ TOptions }

procedure TOptions.saveOptions;
begin
  INIFile.WriteInteger('Options', 'Min1', Min1);
  INIFile.WriteInteger('Options', 'Max1', Max1);
  INIFile.WriteInteger('Options', 'Min2', Min2);
  INIFile.WriteInteger('Options', 'Max2', Max2);
  INIFile.WriteBool('Options', 'Operation0', CheckGroup1.Checked[0]);
  INIFile.WriteBool('Options', 'Operation1', CheckGroup1.Checked[1]);
  INIFile.WriteBool('Options', 'Operation2', CheckGroup1.Checked[2]);
  INIFile.WriteBool('Options', 'Operation3', CheckGroup1.Checked[3]);
  INIFile.WriteBool('Options', 'FirstGrater', CheckBox1.Checked);
end;

function TOptions.getGraterGrater:boolean;
begin
  result := CheckBox1.Checked;
end;

function TOptions.getMin1:integer;
begin
  getMin1 := StrToInt(Edit1.Text);
end;

function TOptions.getMax1:integer;
begin
  getMax1 := StrToInt(Edit2.Text);
end;

function TOptions.getMin2:integer;
begin
  getMin2 := StrToInt(Edit3.Text);
end;

function TOptions.getMax2:integer;
begin
  getMax2 := StrToInt(Edit4.Text);
end;

function TOptions.getOperations:string;
var i,n:integer;
begin
  result := '';
  n := CheckGroup1.Items.Count;
  for i:=0 to n-1 do
     if CheckGroup1.Checked[i]
     then result := result + CheckGroup1.Items[i];
end;

procedure TOptions.ButtonCancelClick(Sender: TObject);
begin
  if noOperation
  then begin
    showMessage('Не може да изключите всички действия!');
    exit;
  end;
  saveOptions;
  Close;
end;

procedure TOptions.CheckGroup1Click(Sender: TObject);
begin

end;

function TOptions.noOperation:boolean;
var i:integer;
begin
  result := false;
  for i:=0 to CheckGroup1.Items.Count-1
  do result := result or CheckGroup1.Checked[i];
  result := Not result;
end;

procedure TOptions.FormCreate(Sender: TObject);
var path:string;
begin
  path := ExtractFilePath(Application.ExeName);
  INIFile := TIniFile.Create(path + '/Zara4ki.ini');
  Edit1.Text := INIFile.ReadString('Options', 'Min1', '1');
  Edit2.Text := INIFile.ReadString('Options', 'Max1', '5');
  Edit3.Text := INIFile.ReadString('Options', 'Min2', '1');
  Edit4.Text := INIFile.ReadString('Options', 'Max2', '5');
  CheckGroup1.Checked[0] := INIFile.ReadBool('Options', 'Operation0', true);
  CheckGroup1.Checked[1] := INIFile.ReadBool('Options', 'Operation1', false);
  CheckGroup1.Checked[2] := INIFile.ReadBool('Options', 'Operation2', false);
  CheckGroup1.Checked[3] := INIFile.ReadBool('Options', 'Operation3', false);
  CheckBox1.Checked := INIFile.ReadBool('Options', 'FirstGrater', false);
end;

end.

