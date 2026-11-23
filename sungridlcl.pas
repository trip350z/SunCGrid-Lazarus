{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit SunGridLCL;

{$warn 5023 off : no warning about unused units}
interface

uses
  SunCGrid, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('SunCGrid', @SunCGrid.Register);
end;

initialization
  RegisterPackage('SunGridLCL', @Register);
end.
