$AppList = get-package -name "*microsoft office*"
$array = ($AppList | Select-Object Name)
if ($array -match 'Microsoft Office*'){.\o15-ctrremove.diagcab}else {'Office is not installed'}