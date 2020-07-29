unit U_Utils;

interface

uses SysUtils, StrUtils;

function StrAsValue(const aStr: string): string;
function StrAsFloatEx(const aStr: string): extended;

implementation

function StrAsValue(const aStr: string): string;
begin
  result := ReplaceStr(aStr, '.', FormatSettings.DecimalSeparator);
  result := ReplaceStr(result, ',', FormatSettings.DecimalSeparator);
end;

function StrAsFloatEx(const aStr: string): extended;
begin
  result := StrToFloat(StrAsValue(aStr));
end;

end.
