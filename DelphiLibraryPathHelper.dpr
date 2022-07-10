program DelphiLibraryPathHelper;

uses
  System.StartUpCopy,
  FMX.Forms,
  UI.Main in 'UI.Main.pas' {uiMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TuiMain, uiMain);
  Application.Run;
end.
