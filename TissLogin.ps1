# **
# * TU WIEN TISS Login Bot
# * based on Selenium-Powershell wrapper by Adam Driscoll (https://github.com/adamdriscoll)
# **

Import-Module (Join-Path $PSScriptRoot "vendor/Selenium.psm1")
filter timestamp {"$(Get-Date -Format G): $_"}

# import config data
Try{
    $config = Get-Content -Raw -Path $PSScriptRoot/config.json | ConvertFrom-Json
    
    $matrikelnummer = $config.credentials.matrikelnummer
    $passwort = $config.credentials.passwort
    $kurs = $config.scriptsetup.kurs
    $semester = $config.scriptsetup.semester
    $prfgNummer = $config.scriptsetup.prfgNummer
    $preferredSlot = $config.scriptsetup.preferredSlot
    $sleepTime = $config.scriptsetup.sleepTime
    $promptBeforeAction = $config.scriptsetup.promptBeforeAction
}
Catch{
    Write-Error "Fehlerhafte Konfigurationsdatei!"
    exit
}

#launch browser and login  
$Driver = Start-SeChrome
Enter-SeUrl -Driver $Driver -Url "https://iu.zid.tuwien.ac.at/AuthServ.authenticate?app=76"
$user = Find-SeElement -Driver $Driver -Name "name"
$pw = Find-SeElement -Driver $Driver -Name "pw"
Send-SeKeys -Element $user -Keys $matrikelnummer
Send-SeKeys -Element $pw -Keys $passwort
$loginButton = Find-SeElement -Driver $Driver -XPath "//input[@type='submit']"
Invoke-SeClick -Element $loginButton

# we are logged in - call the exam overview
$examlink = "https://tiss.tuwien.ac.at/education/course/examDateList.xhtml?courseNr="+$kurs+"&semester="+$semester
Enter-SeUrl -Driver $Driver -Url $examLink

#exam registration buttons are hidden - so all exams have to be expanded and shown first
$expandLink = Find-SeElement -Driver $Driver -Id "examDateListForm:j_id_4o"
Invoke-SeClick -Element $expandLink

#select requested exam - has to be the n-1 th number of available exams
$regString = "examDateListForm:j_id_4t:"+($prfgNummer-1)+":j_id_9c"
$regButton = Find-SeElement -Driver $Driver -XPath "//*[@id='$regString']"
if($promptBeforeAction -ne 0) {
    Read-Host -Prompt "Login erfolgreich - Taste druecken, um Bot zu starten (Strg+C fuer Abbruch)"
}

#reload page until registration button is found
while($regButton -eq $null) {
    Write-Host ("Button noch nicht gefunden " | timestamp)
    $examlink = "https://tiss.tuwien.ac.at/education/course/examDateList.xhtml?courseNr="+$kurs+"&semester="+$semester
    Enter-SeUrl -Driver $Driver -Url $examLink

    #exam registration buttons are hidden - so all exams have to be expanded and shown first
    $expandLink = Find-SeElement -Driver $Driver -Id "examDateListForm:j_id_4o"
    Invoke-SeClick -Element $expandLink

    $regButton = Find-SeElement -Driver $Driver -XPath "//*[@id='$regString']"
    # wait until reload of page
    Start-Sleep -m $sleepTime
}
Write-Host ("Button gefunden " | timestamp)
Invoke-SeClick -Element $regButton

#confirm registration

#check whether there are slots available - if yes select the preferred one
$slotsavailable = Find-SeElement -Driver $Driver -XPath "//*[@id='regForm:subgrouplist']"
if($slotsavailable -ne $null) {
    Invoke-SeClick -Element $slotsavailable
    for($i=1; $i -le ($preferredSlot-1); $i++) {
        $slotsavailable.SendKeys([OpenQA.Selenium.Keys]::Down)
    }
    $slotsavailable.SendKeys([OpenQA.Selenium.Keys]::Enter)
}

$confirmButton = Find-SeElement -Driver $Driver -XPath "//*[@id='regForm:j_id_2u']"
Invoke-SeClick -Element $confirmButton
$kurs_dot = $kurs.Substring(0,3) + "." + $kurs.Substring(3)
Write-Host("Anmeldung zur Pruefung im Kurs "+$kurs_dot+" war erfolgreich " | timestamp)
Read-Host -Prompt "Beliebige Taste druecken zum Beenden."