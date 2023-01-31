Class MyApps.Installer
{

ClassMethod setup(ByRef tVars) As %Status
{
  New $NAMESPACE
  Set oldns=$NAMESPACE
  Set tSC='$$$OK
  Try {

#If 1
    Set $NAMESPACE="%SYS"

    #; enable callin. This is required only if you want to try callin.py
    kill prop
    Set tSC=##class(Security.Services).Get("%service_callin",.prop)
    Set prop("Enabled")=1
    Set tSC=##class(Security.Services).Modify("%service_callin",.prop)

    #; install ZPM
    Do ##class(Security.SSLConfigs).Create("z")
    Set r=##class(%Net.HttpRequest).%New(),r.Server="pm.community.intersystems.com",r.SSLConfiguration="z",r.Https=1
    Set tSC=r.Get("/packages/zpm/latest/installer")
    $$$ThrowOnError(tSC)
    Set tSC=$system.OBJ.LoadStream(r.HttpResponse.Data,"c")
    $$$ThrowOnError(tSC)
#EndIf

    #; Load sample datasets.
    Set $NAMESPACE="USER"
    zpm "install samples-bi"
    zpm "install bdb-nytaxi"

  } Catch(e) {
	  Set tSC=e.AsStatus()
    zw tSC
  }
  Set $NAMESPACE=oldns
  Return tSC
}

ClassMethod appsetup(ByRef tVars) As %Status
{
  Set tSC='$$$OK
  Try {
    Set tSC=$SYSTEM.OBJ.ImportDir("/home/irisowner/src","*","ck",.errorlog,1)

  } Catch(e) {
	  Set tSC=e.AsStatus()
    zw tSC
  }
  Return tSC
}

}
