unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, System.UITypes,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, SyncObjs,
  Vcl.Samples.Spin;

type
  TMyThread = class(TThread)
  private
    FLastNumber: Int64;
    FMaxCount: Int64;
    FResult: Int64;
    FName: string;
    FPresentation: boolean;
    function IsPrimeNumber: boolean;
  protected
    procedure Execute; override;
    constructor Create(MaxCount: Int64; TermProc: TNotifyEvent;
      Presentation: boolean = False);
    procedure SaveResult;
    procedure GetLast;
  public
    property LastNumber: Int64 write FLastNumber;
    property Name: string write FName;
    property Presentation: boolean write FPresentation;
  end;

type
  TForm1 = class(TForm)
    btnGo: TButton;
    Label1: TLabel;
    seCount: TSpinEdit;
    seThread: TSpinEdit;
    Label2: TLabel;
    cbPresentation: TCheckBox;
    procedure btnGoClick(Sender: TObject);
  private
    procedure ThreadTerm(Sender: TObject);
    procedure Run(count: integer);
  public

  end;

var
  Form1: TForm1;
  StartedThread: integer;
  LastDig: Int64;

implementation

procedure WriteStringToTextFile(AFileName: string; Msg: string);
var
  AFile: TextFile;
begin
  try
    AssignFile(AFile, AFileName);
    if FileExists(AFileName) then
      Append(AFile)
    else
      Rewrite(AFile);
    Write(AFile, AnsiString(Msg));
    CloseFile(AFile);
  except
    on E: Exception do
    begin
      // При записи лога не показывать ошибку
    end;
  end;
end;

{$R *.dfm}

{ TMyThread }

function TMyThread.IsPrimeNumber: boolean;
var
  iter: integer;
begin
  //Определяем простое ли это число

  result := true;
  if FLastNumber < 2 then
  begin
    result := False;
    exit;
  end;

  iter := 2;
  while (iter < FLastNumber) and (not Terminated) do
  begin
    if (FLastNumber mod iter) = 0 then
    begin
      result := False;
      exit;
    end;
    Inc(iter);
  end;
  //
end;

constructor TMyThread.Create(MaxCount: Int64; TermProc: TNotifyEvent;
  Presentation: boolean);
begin
  //Создание потока
  inherited Create(true);

  InterlockedIncrement(StartedThread);

  Name := 'Thread_' + IntToStr(StartedThread);
  FMaxCount := MaxCount;
  FreeOnTerminate := true;
  OnTerminate := TermProc;
  FPresentation := Presentation;
end;

procedure TMyThread.GetLast;
begin
  //Получаем последний проверенный
  FLastNumber := LastDig;
end;

procedure TMyThread.SaveResult;
begin
  //Сохраним, если нам всё нравится
  if FResult > LastDig then
  begin
    LastDig := FResult;

    WriteStringToTextFile(self.FName + '.txt', IntToStr(FResult) + ' ');
    WriteStringToTextFile('Result.txt', IntToStr(FResult) + ' ');
  end;

  //Опциональное замедление
  if FPresentation then
    sleep(Random(201));
end;

procedure TMyThread.Execute;
begin
  //Работаем

  Synchronize(GetLast);

  while FLastNumber <= FMaxCount do
  begin
    Inc(FLastNumber);

    if IsPrimeNumber then
    begin
      FResult := FLastNumber;
      Synchronize(SaveResult);
    end;

  end;
end;

procedure TForm1.ThreadTerm(Sender: TObject);
begin
  //И раз-два, закончили
  InterlockedDecrement(StartedThread);

  if StartedThread = 0 then
    MessageDlg('Готово!', TMsgDlgType.mtInformation, [mbOk], 0);
end;

procedure TForm1.btnGoClick(Sender: TObject);
var
  i: integer;
begin
  LastDig := -1;

  for i := 0 to seThread.Value - 1 do
  begin
    Run(seCount.Value);
  end;
end;

procedure TForm1.Run(count: integer);
var
  NewThread: TMyThread;
begin
  NewThread := TMyThread.Create(count, ThreadTerm, cbPresentation.Checked);
  NewThread.Start;
end;

end.
