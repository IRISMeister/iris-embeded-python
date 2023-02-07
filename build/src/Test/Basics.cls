Class Test.Basics Extends %RegisteredObject
{

/* Example of how Classes in ObjectScript interact with Python */

/* Accessing other properties in this class from Python */
Property VariableMessage As %String [ InitialExpression = "How are you?" ];

// Can we read a global that was set in ObjectScript from Python?

Method Test1a() As %Numeric [ Language = python ]
{
    import iris

    foo = iris.gref("^Test")
    return foo.get()==42
}

// Can we read a global that was set in ObjectScript from Python?

Method Test1b() As %Numeric [ Language = python ]
{
    self.WriteTestGlobal()
    return 1
}

// Can we access Properties?

Method Test2a() As %Numeric [ Language = python ]
{
	foo = self.VariableMessage
	return (foo=="How are you?")
}

// Can we update Properties?

Method Test2b() As %Numeric [ Language = python ]
{
    self.VariableMessage = "Test2b"
    foo = self.VariableMessage
    return (foo=="Test2b")
}

ClassMethod Test3a() As %String [ Language = python ]
{
	return "abc"
}

ClassMethod Test3b(addr As %String) As %SYS.Python [ Language = python ]
{
	from geopy.geocoders import Nominatim
	geolocator = Nominatim(user_agent="IrisGeoApp")
	try:
		location = geolocator.geocode(addr)
	except:
		print("Not able to find location")
	return location
}

/* Example of how to manipulate globals in Python */
Method SetTestGlobal(val As %Numeric)
{
    SET ^Test=val
    quit $$$OK
}

Method GetTestGlobal() As %Numeric
{
    quit ^Test
}

Method WriteTestGlobal() As %Status
{
    write !, "こんにちは", !
    write ^Test,!
    quit $$$OK
}

/// Example of how to make SQL calls from Python
Method Sql() As %Numeric [ Language = python ]
{
    import iris

    stmt = iris.sql.prepare("select top 5 Name, Super, TimeCreated from %Dictionary.ClassDefinition WHERE Name %STARTSWITH ?")
    rs = stmt.execute("%Net.")
    for idx, row in enumerate(rs):
        print(f"[{idx}]: {row}")
    return 1
}

}
