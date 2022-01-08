unit mainform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ActnList, ComCtrls, OptionsDialog, LCLType;

type

  { TForm1 }

  TForm1 = class(TForm)
    ActionClose: TAction;
    ImageList1: TImageList;
    Label5: TLabel;
    Label6: TLabel;
    SetOptions: TAction;
    ActionList1: TActionList;
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Memo1: TMemo;
    Timer1: TTimer;
    Timer2: TTimer;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButtonClose: TToolButton;
    procedure ActionCloseExecute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure SetOptionsExecute(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private
    A,B,C,aLength,Correct,Errors:integer;
    Operation:char;
    LastProblem,NextProblem:string;
    procedure NexProblem;
    procedure ViewProgress(i:integer; l:TLabel);
  public

  end;

const version = '0.3';

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.ViewProgress(i:integer; l:TLabel);
var newCaption:string; j:integer;
begin
   newCaption := '';
   for j:=1 to i do newCaption := newCaption + '|';
   newCaption := newCaption + ' ' + IntToStr(i);
   l.caption := NewCaption;
end;

procedure TForm1.Memo1Change(Sender: TObject);
var value,errorPos:integer;
begin
   if(Length(Memo1.Text)<aLength) then exit;
   Val(Memo1.Text,value,errorPos);
   if((errorPos=0) and (value = C))
   then begin
      Image2.Visible := true;
      Image1.Visible := false;
      inc(Correct);
      ViewProgress(Correct, Label5);
   end
   else if Length(Memo1.Text)>0 then begin
      Image1.Visible := true;
      Image2.Visible := false;
      inc(Errors);
      ViewProgress(Errors, Label6);
   end;
   Timer1.Enabled := true;
   Timer2.Enabled := false;
   Timer2.Enabled := true;
end;

procedure TForm1.SetOptionsExecute(Sender: TObject);
begin
  Options.ShowModal;
  NexProblem;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  NexProblem;
  Timer1.Enabled := false;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
  Image1.Hide;
  Image2.Hide;
  Timer2.Enabled:=false;
end;

procedure TForm1.NexProblem;
var repetitions:integer;
begin
  LastProblem := NextProblem;
  repetitions := 0;
  repeat
   inc(repetitions);
   Operation := Options.Operations[ 1 + Random(length(Options.Operations)) ];
   if Operation='/' then begin
      C := Options.Min2 + Random(Options.Max2 - Options.Min2 + 1);
      B := Options.Min2 + Random(Options.Max2 - Options.Min2 + 1);
      A := B * C;
   end
   else begin
        if Options.FirstGrater AND (Operation='-')
        then B := Options.Min2 + Random(Options.Max2 - Options.Min2)
        else B := Options.Min2 + Random(Options.Max2 - Options.Min2 + 1);
        if Options.FirstGrater AND (Operation='-')
        then A := B + 1 + Random(Options.Max1 - B)
        else A := Options.Min1 + Random(Options.Max1 - Options.Min1 + 1);
   end;
   case Operation of
   '+': C := A + B;
   '-': C := A - B;
   '*': C := A * B;
   ':': C := A div B;
   else
     C := 0;
   end;
   Label1.Caption:=IntToStr(A);
   if Operation='*' then Label2.Caption:='.'
   else Label2.Caption:=Operation;
   Label3.Caption:=IntToStr(B);
   NextProblem := Label1.Caption + Label2.Caption + Label3.Caption;
 until (NextProblem<>LastProblem) OR (repetitions>10);
 aLength:=Length(IntToStr(C));
 Memo1.Text:='';
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  Memo1.SetFocus;
  Memo1.SelectAll;
end;

procedure TForm1.ActionCloseExecute(Sender: TObject);
begin
  Close;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  {$IfDef Windows}
     SetOptions.ShortCut:=KeyToShortCut(VK_O, [ssCtrl]) ;
     ActionClose.ShortCut:=KeyToShortCut(VK_F4, [ssAlt]) ;
  {$EndIf}
  Randomize;
  Timer1.Enabled := false;
  Timer2.Enabled := false;
  Font.Color:=clFuchsia;
  Label5.Font.Color:=clGreen;
  Label6.Font.Color:=clRed;
  Correct := 0;
  Errors := 0;
  Caption := Caption + ' - версия ' + version;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  NexProblem;
end;

end.

