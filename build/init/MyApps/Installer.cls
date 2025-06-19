Class MyApps.Installer
{

XData setup [ XMLNamespace = INSTALLER ]
{
<Manifest>
  <User Username="appuser" PasswordVar="appuserpwd" Roles="" Namespace="" Routine="" ExpirationDate="" Enabled="1" Comment="appilication user"/>

  <Namespace Name="user" Create="no">
    <CSPApplication Url="/csp/user-rest" Directory="${CSPDIR}user" Resource=""/>
  </Namespace>
</Manifest>
}

ClassMethod setupMethod(ByRef pVars, pLogLevel As %Integer = 3, pInstaller As %Installer.Installer, pLogger As %Installer.AbstractLogger) As %Status [ CodeMode = objectgenerator, Internal ]
{
  Quit ##class(%Installer.Manifest).%Generate(%compiledclass, %code, "setup")
}

ClassMethod setup(ByRef tVars) As %Status
{
  New $NAMESPACE
  Set oldns=$NAMESPACE
  Set tSC='$$$OK
  Try {
    Set tVars("appuserpwd")="sys"
    Set tSC=..setupMethod(.tVars)

    Set $NAMESPACE="%SYS"
#If 1

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
    zpm "enable -map -globally"
    zpm "enable -community"
#EndIf

    Kill props
    Set webapp="/csp/user-rest"
    Set tSC = ##Class(Security.Applications).Get(webapp,.props)
    $$$ThrowOnError(tSC)
    Set props("DispatchClass")="Rest.Dispatcher"
    Set props("Recurse")=1  // need this for UrlMap /path/:p1 to work
    Set props("Resource")=""
    Set props("DeepSeeEnabled")=0
    Set props("MatchRoles")=":%DB_USER"
    Set props("NameSpace")="USER"
    Kill props("Type")
    Set tSC = ##Class(Security.Applications).Modify(webapp,.props)
    $$$ThrowOnError(tSC)

    #; Load sample datasets.
    Set $NAMESPACE="USER"
    zpm "install samples-bi"
    #; zpm "install bdb-nytaxi"

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
