Class Test.ObjectScript
{

ClassMethod new()
{
	#; https://openpyxl.readthedocs.io/en/stable/
	set openpyxl=##class(%SYS.Python).Import("openpyxl")

	set wb = openpyxl.Workbook()
	set ws=wb."create_sheet"()
	set ws.title="Python"
	set cell=ws.cell(1,1) ; A1
	set cell.value=123    ; 数値
	do wb.save("/home/irisowner/rsc/a.xlsx")
}

ClassMethod modify()
{
	set openpyxl=##class(%SYS.Python).Import("openpyxl")

	;; method名に _ がついているので前後を " で囲む
	set wb = openpyxl."load_workbook"("/home/irisowner/rsc/a.xlsx")
	//set ws=wb."get_sheet_by_name"("Python")  // deprecated
	Set ws=wb."__getitem__"("Python")
	set cell=ws.cell(1,1) ; A1
	set cell.value=cell.value+1    ; 数値
	do wb.save("/home/irisowner/rsc/a.xlsx")
}

ClassMethod modify2()
{
	; 事前にCellに名前の定義("aaa")がされていて、その値が数値(100など)である/home/irisowner/Book1.xlsxが必要。
	; そのCellの内容を+1する。
	set openpyxl=##class(%SYS.Python).Import("openpyxl")

	set wb = openpyxl."load_workbook"("/home/irisowner/rsc/Book1.xlsx")
	Set ws=wb."__getitem__"("Sheet1")
	Set caddr=wb."defined_names"."__getitem__"("aaa")."attr_text" ; caddr="Sheet1!$B$1"
	Set caddr=$P(caddr,"!",2) ; これはIRISの文字列であることに留意
	Set cell=ws."__getitem__"(caddr)
	set cell.value=cell.value+1
	do wb.save("/home/irisowner/rsc/Book1.xlsx")

	; 下記のpythonと等価の処理。
	/*
	import openpyxl

	wb=openpyxl.load_workbook("c:/temp/Book1.xlsx")
	ws=wb["Sheet1"]
	cell=ws[wb.defined_names['aaa'].attr_text.split('!')[1]]
	cell.value=cell.value+1
	wb.save("c:/temp/Book1.xlsx")
	*/	
}

}
