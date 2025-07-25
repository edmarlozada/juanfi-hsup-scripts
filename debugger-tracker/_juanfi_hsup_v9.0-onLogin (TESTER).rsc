# JuanFi onLogin Tester v9.0b
# by: Chloe Renae & Edmar Lozada
# ------------------------------

if ([/ip hotspot user profile find name="hsup-TESTER"]="") do={
  /ip hotspot user profile add name="hsup-TESTER" keepalive-timeout=10m mac-cookie-timeout=5d
}
/system script environment remove [find]
if ([/system scheduler find name=tester]!="") do={
  execute [/system scheduler get [find name=tester] on-event]
}
/log info "JuanFi onLogin Tester..."
/log debu "JuanFi onLogin Tester..."
/system logging action set memory memory-lines=1
/system logging action set memory memory-lines=1000
/system logging action set disk disk-lines-per-file=1
/system logging action set disk disk-lines-per-file=1000

global setDebugger do={
  glob xUser "tester"
  glob xAddr "10.0.0.3"
  glob xMAC  "88:88:88:88:88:88"
  glob xDInt "bridge-Main"
  glob xRoot "hotspot"
  glob iHSUP "hsup-TESTER"
  glob xFMac "888888888888"
  if ([/system scheduler find name=tester]!="") do={
    execute [/system scheduler get [find name=tester] on-event]
  }
  /ip hotspot user remove [find name=$xUser]
  /ip hotspot user add name=$xUser password=$xUser profile=$iHSUP limit-uptime=$xTime email=$xMail comment=$xNote
}

  /ip hotspot user add name=tester password=tester profile=hsup-TESTER limit-uptime=10h email=new@gmail.com comment="10h,5,0,Vendo-01"
  /ip hotspot user set [find name=tester] limit-uptime=5h email=ext@gmail.com comment="10h,5,0,Vendo-01"
# ==============================

# NORMAL LOGIN NEW USER ( 1h UserTime & 5h Validity & Sales )
$setDebugger xTime=1h xMail="new@gmail.com" xNote="5h,5,0,Vendo-01"
global eUserLogin [parse [/ip hotspot user profile get [find name=$iHSUP] on-login]]
$eUserLogin username=$xUser address=$xAddr mac-address=$xMAC interface=$xDInt

# LOGIN ACTIVE USER
/ip hotspot active remove [find user=$xUser]
global eUserLogin [parse [/ip hotspot user profile get [find name=$iHSUP] on-login]]
$eUserLogin username=$xUser address=$xAddr mac-address=$xMAC interface=$xDInt

# LOGIN NEW USER ( 10s UserTime & 1h Validity )
$setDebugger xTime=10s xMail="new@gmail.com" xNote="1h,0,0,Vendo-01"
global eUserLogin [parse [/ip hotspot user profile get [find name=$iHSUP] on-login]]
$eUserLogin username=$xUser address=$xAddr mac-address=$xMAC interface=$xDInt

# LOGIN NEW USER ( 0 UserTime & 10s Validity )
$setDebugger xTime=0 xMail="new@gmail.com" xNote="10s,0,0,Vendo-01"
global eUserLogin [parse [/ip hotspot user profile get [find name=$iHSUP] on-login]]
$eUserLogin username=$xUser address=$xAddr mac-address=$xMAC interface=$xDInt

# LOGIN NEW USER ( 0 UserTime & 0 Validity )
$setDebugger xTime=0 xMail="new@gmail.com" xNote="0,0,0,Vendo-01"
global eUserLogin [parse [/ip hotspot user profile get [find name=$iHSUP] on-login]]
$eUserLogin username=$xUser address=$xAddr mac-address=$xMAC interface=$xDInt

# TEST LOGIN with UserTime<Validity ( 1h UserTime & 10s-Validity )
$setDebugger xTime=1h xMail="new@gmail.com" xNote="10s,0,0,Vendo-01"
global eUserLogin [parse [/ip hotspot user profile get [find name=$iHSUP] on-login]]
$eUserLogin username=$xUser address=$xAddr mac-address=$xMAC interface=$xDInt

# TEST LOGIN with UserTime=Validity ( 1h usertime & 1h validity )
$setDebugger xTime=1h xMail="new@gmail.com" xNote="1h,0,0,Vendo-01"
global eUserLogin [parse [/ip hotspot user profile get [find name=$iHSUP] on-login]]
$eUserLogin username=$xUser address=$xAddr mac-address=$xMAC interface=$xDInt

# NORMAL EXTEND USER ( 2h usertime / 4h validity )
/ip hotspot user set [find name=tester] limit-uptime=2h email=ext@gmail.com comment="4h,5,0,Vendo-01"
global eUserLogin [parse [/ip hotspot user profile get [find name=$iHSUP] on-login]]
$eUserLogin username=$xUser address=$xAddr mac-address=$xMAC interface=$xDInt

/ip hotspot active remove [find user=$xUser]
/ip hotspot cookie remove [find user=$xUser]
/ip hotspot cookie remove [find mac-address=$xMAC]
/ip hotspot user set [find name=$xUser] limit-uptime=2h email="extend@gmail.com" comment="4h,0,1,Vendo-01"
global eUserLogin [parse [/ip hotspot user profile get [find name=$iHSUP] on-login]]
$eUserLogin username=$xUser address=$xAddr mac-address=$xMAC interface=$xDInt

# EXTEND USER w/o SCHEDULER ( 2h usertime / 4h validity )
$setDebugger xTime=1h xMail="new@gmail.com" xNote="2h,0,0,Vendo-01"
global eUserLogin [parse [/ip hotspot user profile get [find name=$iHSUP] on-login]]
$eUserLogin username=$xUser address=$xAddr mac-address=$xMAC interface=$xDInt

/ip hotspot active remove [find user=$xUser]
/system scheduler remove [find name=$xUser]
/ip hotspot user set [find name=$xUser] limit-uptime=2h email="extend@gmail.com" comment="4h,0,1,Vendo-01"
global eUserLogin [parse [/ip hotspot user profile get [find name=$iHSUP] on-login]]
$eUserLogin username=$xUser address=$xAddr mac-address=$xMAC interface=$xDInt

# LOGIN NEW USER with other VENDO ( 1h UserTime & 2h Validity & iVendTag=Vendo-02 ) iVendTag=Vendo-02
$setDebugger xTime=1h xMail="new@gmail.com" xNote="2h,5,0,Vendo-02"
global eUserLogin [parse [/ip hotspot user profile get [find name=$iHSUP] on-login]]
$eUserLogin username=$xUser address=$xAddr mac-address=$xMAC interface=$xDInt

# ------------------------------

# blank mail ( 0 UserTime & 10s Validity )
$setDebugger xTime=0 xNote="10s,0,0,Vendo-01"
global eUserLogin [parse [/ip hotspot user profile get [find name=$iHSUP] on-login]]
$eUserLogin username=$xUser address=$xAddr mac-address=$xMAC interface=$xDInt

# invalid mail ( 0 UserTime & 10s Validity )
$setDebugger xTime=0 xMail="invalid@gmail.com" xNote="10s,0,0,Vendo-01"
global eUserLogin [parse [/ip hotspot user profile get [find name=$iHSUP] on-login]]
$eUserLogin username=$xUser address=$xAddr mac-address=$xMAC interface=$xDInt

# test active user with invalid eMail then with/without scheduler ( 0 UserTime & 1h Validity )
$setDebugger xTime=0 xMail="new@gmail.com" xNote="1h,0,0,Vendo-01"
global eUserLogin [parse [/ip hotspot user profile get [find name=$iHSUP] on-login]]
$eUserLogin username=$xUser address=$xAddr mac-address=$xMAC interface=$xDInt

# ( invalid xMail with scheduler )
/ip hotspot user set [find name=$xUser] email="invalid@gmail.com"
global eUserLogin [parse [/ip hotspot user profile get [find name=$iHSUP] on-login]]
$eUserLogin username=$xUser address=$xAddr mac-address=$xMAC interface=$xDInt

# ( invalid xMail without scheduler )
/system scheduler remove [find name=$xUser]
/ip hotspot user set [find name=$xUser] email="invalid@gmail.com"
global eUserLogin [parse [/ip hotspot user profile get [find name=$iHSUP] on-login]]
$eUserLogin username=$xUser address=$xAddr mac-address=$xMAC interface=$xDInt

# invalid new user comment ( 0 UserTime )
$setDebugger xTime=0 xMail="new@gmail.com" xNote="invalid comment"
global eUserLogin [parse [/ip hotspot user profile get [find name=$iHSUP] on-login]]
$eUserLogin username=$xUser address=$xAddr mac-address=$xMAC interface=$xDInt

# ------------------------------

# Auto Create Sales ( 0 UserTime & 10s Validity )
/system script remove [find name~"income"]
/system script remove [find name~"Sales"]
$setDebugger xTime=0 xMail="new@gmail.com" xNote="10s,1,0,Vendo-01"
global eUserLogin [parse [/ip hotspot user profile get [find name=$iHSUP] on-login]]
$eUserLogin username=$xUser address=$xAddr mac-address=$xMAC interface=$xDInt

# Auto Create Path ( 0 UserTime & 10s Validity )
/file remove [find name="$xRoot/data"]
/file remove [find name="$xRoot/xData"]
$setDebugger xTime=0 xMail="new@gmail.com" xNote="10s,0,0,Vendo-01"
global eUserLogin [parse [/ip hotspot user profile get [find name=$iHSUP] on-login]]
$eUserLogin username=$xUser address=$xAddr mac-address=$xMAC interface=$xDInt

if ([/system scheduler find name="<JuanFi-Reset-Sales>"]!="") do={
  [parse [/system scheduler get [find name="<JuanFi-Reset-Sales>"] on-event]]
}

# ------------------------------
