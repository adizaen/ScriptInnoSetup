; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "Aplikasi Toko"
#define MyAppVersion "1.0"
#define MyAppPublisher "Adi Zaenul"
#define MyAppExeName "Store.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{EB10173C-981F-4EA1-A7B6-E9FCA25C94C6}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={autopf}\{#MyAppName}
DisableProgramGroupPage=yes
; Uncomment the following line to run in non administrative install mode (install for current user only.)
;PrivilegesRequired=lowest
OutputDir=D:\Program
OutputBaseFilename=MasterSetup
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Code]
var
  dotNetNeeded: boolean;

function IsDotNetDetected(version: string; service: cardinal): boolean;
// Indicates whether the specified version and service pack of the .NET Framework is installed.
//
// version -- Specify one of these strings for the required .NET Framework version:
//    'v1.1.4322'     .NET Framework 1.1
//    'v2.0.50727'    .NET Framework 2.0
//    'v3.0'          .NET Framework 3.0
//    'v3.5'          .NET Framework 3.5
//    'v4\Client'     .NET Framework 4.0 Client Profile
//    'v4\Full'       .NET Framework 4.0 Full Installation
//
// service -- Specify any non-negative integer for the required service pack level:
//    0               No service packs required
//    1, 2, etc.      Service pack 1, 2, etc. required
var
    key: string;
    install, serviceCount: cardinal;
    success: boolean;
begin
    key := 'SOFTWARE\Microsoft\NET Framework Setup\NDP\' + version;

    // .NET 4.0 uses value InstallSuccess in subkey Setup
    if Pos('v4.0', version) = 1 then begin
        success := RegQueryDWordValue(HKLM, key + '\Setup', 'InstallSuccess', install);
    end else begin
        success := RegQueryDWordValue(HKLM, key, 'Install', install);
    end;

    result := success and (install = 1) and (serviceCount >= service);
end;

function InitializeSetup(): Boolean;
begin
  dotNetNeeded := IsDotNetDetected('v4.5', 0);
  result := true;    
end;

function CheckDotNet(): boolean;
begin
    Result:=false;

    if (dotNetNeeded) then
        Result:=true;
end;

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: installmysql; Description: "Install MySQL"; GroupDescription: "Proses Tambahan"; Flags: checkedonce

[Files]
Source: "D:\Eskul SMK\Store\Store\bin\Debug\Store.exe"; DestDir: "{app}"; Flags: ignoreversion
;daftar file MySQL ODBC 3.51
Source: "C:\Program Files (x86)\MySQL\Connector ODBC 3.51\myodbc3.dll"; DestDir: {sys}; Flags: onlyifdoesntexist
Source: "C:\Program Files (x86)\MySQL\Connector ODBC 3.51\myodbc3S.dll"; DestDir: {sys}; Flags: onlyifdoesntexist
Source: "C:\Program Files (x86)\MySQL\Connector ODBC 3.51\myodbc3.lib"; DestDir: {sys}; Flags: onlyifdoesntexist
Source: "C:\Program Files (x86)\MySQL\Connector ODBC 3.51\myodbc3S.lib"; DestDir: {sys}; Flags: onlyifdoesntexist
Source: "C:\Program Files (x86)\MySQL\Connector ODBC 3.51\myodbc3i.exe"; DestDir: {sys}; Flags: onlyifdoesntexist
 

Source: "D:\Program\MySQL Connector ODBC 3.51.30.msi"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\xampp\mysql\bin\*"; DestDir: {app}\mysql\bin; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "C:\xampp\mysql\data\*"; DestDir: {app}\mysql\data; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "C:\xampp\mysql\scripts\*"; DestDir: {app}\mysql\scripts; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "C:\xampp\mysql\share\*"; DestDir: {app}\mysql\share; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "C:\xampp\mysql\*"; DestDir: {app}\mysql; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "D:\Eskul SMK\Store\Store\bin\Debug\exec.cmd"; DestDir: {app}\mysql\bin; Flags: ignoreversion
Source: "D:\Eskul SMK\Store\Store\bin\Debug\lks.sql"; DestDir: {app}\mysql\bin; Flags: ignoreversion
Source: "D:\Eskul SMK\Store\Store\bin\Debug\Store.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Eskul SMK\Store\Store\bin\Debug\Store.exe.config"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Eskul SMK\Store\Store\bin\Debug\Store.pdb"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Eskul SMK\Store\Store\bin\Debug\Store.xml"; DestDir: "{app}"; Flags: ignoreversion
; NOTE: Don't use "Flags: ignoreversion" on any shared system files
; NET Framework 4.5
Source: "D:\Program\.NET Framework 4.5.exe"; DestDir: {tmp}; Flags: ignoreversion deleteafterinstall; Check: CheckDotNet

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[INI]
Filename:{app}\mysql\bin\my.ini; Section: mysqld; Key:basedir; String: {app}\mysql\bin; Tasks: installmysql
Filename:{app}\mysql\bin\my.ini; Section: mysqld; Key:datadir; String: {app}\mysql\data; Tasks: installmysql

[Run]
Filename: {tmp}\.NET Framework 4.5.exe; Parameters: "/q"; WorkingDir: {tmp}; Check: CheckDotNet; StatusMsg: "Instalasi DotNET Framework 4.5"
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent
;install service MySQL
Filename: "{app}\mysql\bin\mysqld.exe"; Parameters: "install ""MySQL"""; StatusMsg: "Sedang menginstall service MySQL ..."; Flags: runhidden; MinVersion: 0,5.01.2600sp2; Tasks: installmysql

;jalankan service MySQL
Filename: {sys}\net.exe; Parameters: "start ""MySQL"""; StatusMsg: "Sedang menjalankan service MySQL ..."; Flags: runhidden; MinVersion: 0.0,4.0.1381; Tasks: installmysql

;mendaftarkan port default mysql (3306) ke firewall
Filename: "{sys}\netsh.exe"; Parameters: "firewall add portopening TCP 3306 ""Port MySQL"""; StatusMsg: "Sedang mendaftarkan port MySQL ..."; Flags: runhidden; MinVersion: 0,5.01.2600sp2
Filename: "{sys}\netsh.exe"; Parameters: "firewall set service type = fileandprint mode = enable"; StatusMsg: "Mengaktifkan File and Printer Sharing ..."; Flags: runhidden; MinVersion: 0,5.01.2600sp2

;mengganti password default root (blank). ex : masterkey
Filename: "{app}\mysql\bin\mysqladmin.exe"; Parameters: "-uroot "; StatusMsg: "Mengganti password root"; Flags: runhidden; MinVersion: 0,5.01.2600sp2

;menghapus user default1 (user=blank, password=blank)
Filename: "{app}\mysql\bin\mysql.exe"; Parameters: "-uroot -e ""DELETE FROM mysql.user WHERE Host='127.0.0.1' AND User=''"""; Flags: runhidden; MinVersion: 0,5.01.2600sp2
Filename: "{app}\mysql\bin\mysql.exe"; Parameters: "-uroot -e ""FLUSH PRIVILEGES"""; Flags: runhidden; MinVersion: 0,5.01.2600sp2

;menghapus user default2 (user=root, password=blank)
Filename: "{app}\mysql\bin\mysql.exe"; Parameters: "-uroot -e ""DELETE FROM mysql.user WHERE Host='127.0.0.1' AND User='root'"""; Flags: runhidden; MinVersion: 0,5.01.2600sp2
Filename: "{app}\mysql\bin\mysql.exe"; Parameters: "-uroot -e ""FLUSH PRIVILEGES"""; Flags: runhidden; MinVersion: 0,5.01.2600sp2

;set agar user root bisa login dari mesin lain (kalo diperlukan)
Filename: "{app}\mysql\bin\mysql.exe"; Parameters: "-uroot -e ""GRANT ALL PRIVILEGES ON *.* TO root@'%' IDENTIFIED BY ''"""; Flags: runhidden; MinVersion: 0,5.01.2600sp2
Filename: "{app}\mysql\bin\mysql.exe"; Parameters: "-uroot -e ""FLUSH PRIVILEGES"""; Flags: runhidden; MinVersion: 0,5.01.2600sp2

;membuat database kosong
Filename: "{app}\mysql\bin\mysql.exe"; Parameters: "-uroot -e ""CREATE DATABASE lks"""; Flags: runhidden; MinVersion: 0,5.01.2600sp2

;menjalankan file batch exec.cmd untuk melakukan proses undump
Filename: "{app}\mysql\bin\exec.cmd"; Flags: runhidden; MinVersion: 0,5.01.2600sp2

;install driver myodbc
Filename: "{sys}\myodbc3i.exe"; Parameters: "-a -d -t""MySQL ODBC 3.51 Driver;DRIVER={sys}\myodbc3.dll;SETUP={sys}\myodbc3S.dll"""; StatusMsg: "Tunggu sedang mendaftarkan driver MySQL Connector ODBC 3.51"; Flags: runhidden
 
;install dsn-koneksiODBC
Filename: "{sys}\myodbc3i.exe"; Parameters: "-a -su -t""DSN=koneksiODBC;DRIVER=MySQL ODBC 3.51 Driver;SERVER=127.0.0.1;DATABASE=lks;UID=root;PWD="" -w"; Flags: runhidden; StatusMsg: "Tunggu sedang membuat DSN-koneksiODBC"

[UninstallRun]
Filename: {sys}\net.exe; Parameters: "stop ""MySQL"""; StatusMsg: "Menghentikan Service MySQL ..."; Flags: runhidden; MinVersion: 0.0,4.0.1381
Filename: "{app}\mysql\bin\mysqld.exe"; Parameters: "remove ""MySQL"""; StatusMsg: "Sedang menghapus service MySQL ..."; Flags: runhidden; MinVersion: 0,5.01.2600sp2

;uninstall driver myodbc
Filename: "{sys}\myodbc3i.exe"; Parameters: "-s -r -su -n""koneksiODBC"""; StatusMsg: "Tunggu sedang menghapus DSN-koneksiODBC"; Flags: runhidden
 
;hapus dsn-albasi
Filename: "{sys}\myodbc3i.exe"; Parameters: "-d -r -n""MySQL ODBC 3.51 Driver"""; StatusMsg: "Tunggu sedang menghapus driver MySQL Connector ODBC 3.51"; Flags: runhidden

[UninstallDelete]
Type: files; Name: {app}\mysql\bin\*.*
Type: files; Name: {app}\mysql\Docs\*.*
Type: files; Name: {app}\mysql\lib\*.*
Type: files; Name: {app}\mysql\share\*.*

Type: files; Name: {sys}\myodbc3S.dll
Type: files; Name: {sys}\myodbc3S.lib
Type: files; Name: {sys}\myodbc3.dll
Type: files; Name: {sys}\myodbc3.lib
Type: files; Name: {sys}\myodbc3i.exe

[Registry]
;mencatat lokasi instalasi program, ini dibutuhkan jika kita ingin membuat paket instalasi update
Root: HKCU; Subkey: "Software\Aplikasi Toko\SPBB"; ValueName: "installDir"; ValueType: String; ValueData: {app}; Flags: uninsdeletevalue