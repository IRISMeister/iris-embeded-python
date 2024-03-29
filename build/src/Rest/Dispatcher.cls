/// curl -u "appuser:sys" -H "Content-Type: application/json" http://localhost:52773/csp/user-rest/get
/// curl -u "appuser:sys" -H "Content-Type: application/json" http://localhost:52773/csp/user-rest/getp
/// curl -u "appuser:sys" -X POST -H "Content-Type: application/json" -d "@req.json" http://localhost:52773/csp/user-rest/post/123
/// curl -u "appuser:sys" -X POST -H "Content-Type: application/json" -d "@req.json" http://localhost:52773/csp/user-rest/postp/123
Class Rest.Dispatcher Extends %CSP.REST
{

Parameter CONVERTINPUTSTREAM = 1;

Parameter CHARSET = "utf-8";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
  <Route Url="/get" Method="get" Call="Get" />
  <Route Url="/getp" Method="get" Call="GetPython" />
  <Route Url="/post/:p1" Method="post" Call="Post" />
  <Route Url="/postp/:p1" Method="post" Call="PostPython" />
</Routes>
}

ClassMethod Get() As %Status
{
    Do ##class(%REST.Impl).%SetHeader("Content-Type","application/json")
	Set ret={"A": "apple", "B": "banana", "C": "carrot", "D": "drink", "E": "egg"}
    Do ret.%ToJSON()
    Return $$$OK
}

ClassMethod GetPython() [ Language = python ]
{
	import json,iris
	
	iris.cls('%REST.Impl')._SetHeader("Content-Type","application/json")
	sample_dict = {'A': 'apple', 'B': 'banana', 'C': 'carrot', 'D': 'drink', 'E': '卵'}
	jsonstring=json.dumps(sample_dict,ensure_ascii=False)
	iris.cls('%REST.Impl')._WriteResponse(jsonstring)
	return True
}

ClassMethod Post(p1 = "") As %Status
{
    Do ##class(%REST.Impl).%SetHeader("Content-Type","application/json")
    Set req={}.%FromJSON(%request.Content)
	Set ret={"p1": (p1),"A": "apple", "B": "banana", "C": "carrot", "D": "drink", "E": "卵", "F": (req.name)}
    Do ret.%ToJSON()
    Return $$$OK
}

ClassMethod PostPython(p1 = "") [ Language = python ]
{
	import json,iris

	req=iris.cls('Rest.Common').GetRequestContent()
	req_dict=json.loads(req)

	iris.cls('%REST.Impl')._SetHeader("Content-Type","application/json")
	sample_dict = {'p1': str(p1) ,'A': 'apple', 'B': 'banana', 'C': 'carrot', 'D': 'drink', 'E': '卵', "F": req_dict['name']}
	jsonstring=json.dumps(sample_dict,ensure_ascii=False)
	iris.cls('%REST.Impl')._WriteResponse(jsonstring)
	return True
}

}
