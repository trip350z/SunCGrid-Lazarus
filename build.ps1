param(
  [ValidateSet('win32', 'gtk2', 'qt5', 'qt6', 'cocoa')]
  [string]$WidgetSet = 'win32',
  [string]$LazBuild = 'lazbuild'
)
$ErrorActionPreference = 'Stop'
Push-Location $PSScriptRoot
try {
  $demoProject = if ($WidgetSet -eq 'cocoa') { 'demo/SunGridDemoMac.lpi' } else { 'demo/SunGridDemo.lpi' }
  foreach ($project in @('sungridlcl.lpk', $demoProject, 'tests/SunGridSmoke.lpi')) {
    & $LazBuild '--build-all' "--widgetset=$WidgetSet" $project
    if ($LASTEXITCODE -ne 0) { throw "Build failed: $project (exit $LASTEXITCODE)" }
  }
} finally {
  Pop-Location
}
