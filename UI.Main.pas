unit UI.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Controls.Presentation, FMX.Layouts, FMX.ListBox, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo;

type
  TuiMain = class(TForm)
    lytSource: TLayout;
    edtSource: TEdit;
    lblSource: TLabel;
    EditButton1: TEditButton;
    memFilter: TMemo;
    lytFilter: TLayout;
    lblFilter: TLabel;
    lytResult: TLayout;
    lblResult: TLabel;
    memResult: TMemo;
    procedure edtSourceChangeTracking(Sender: TObject);
    procedure EditButton1Click(Sender: TObject);
    procedure memFilterChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function EnumDirectories(const APath, AFilter: string): TArray<string>;
    function DirNameForEnumVar(const APath: string): string;
    procedure DoRepaint;
  end;

var
  uiMain: TuiMain;

implementation

uses
  System.IOUtils, System.Generics.Collections;
{$R *.fmx}

function TuiMain.DirNameForEnumVar(const APath: string): string;
begin
  Result := Format('$(%s)', [TPath.GetFileName(APath)]);
end;

procedure TuiMain.DoRepaint;
begin
  memResult.Text := string.Join(';', EnumDirectories(edtSource.Text, memFilter.Text));
end;

procedure TuiMain.edtSourceChangeTracking(Sender: TObject);
begin
  if TDirectory.Exists(edtSource.Text) then
    DoRepaint;
end;

procedure TuiMain.EditButton1Click(Sender: TObject);
var
  Dir: string;
begin
  SelectDirectory('Caption', '', Dir);
  edtSource.Text := Dir;
end;

function TuiMain.EnumDirectories(const APath, AFilter: string): TArray<string>;
var
  LList: TList<string>;
  LDirNameEV: string;
begin
  LDirNameEV := DirNameForEnumVar(APath);
  LList := TList<string>.Create;
  try
    for var LFile in TDirectory.GetFiles(APath, TSearchOption.soAllDirectories,
      function(const Path: string; const SearchRec: TSearchRec): Boolean
      begin
        var
        a := TPath.GetExtension(SearchRec.Name) = '.pas';
        var
        b := True;
        for var LFilter in memFilter.Text.Split([' ', #13#10, ';']) do
          if string(Path).Contains(LFilter) then
          begin
            b := False;
            break;
          end;
        Result := a and b;
      end) do
    begin

      var
      LDir := TPath.GetDirectoryName(LFile);
      LDir := LDirNameEV + LDir.Remove(0, APath.Length);
      if not LList.Contains(LDir) then
        LList.Add(LDir);
      Result := LList.ToArray;
    end;
  finally
    LList.Free;
  end;
end;

procedure TuiMain.memFilterChange(Sender: TObject);
begin
  DoRepaint;
end;

end.
