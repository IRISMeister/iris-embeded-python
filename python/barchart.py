from pandas import DataFrame
import matplotlib.pyplot as plt

# put me in mgr\python\barchart.py
def buildGraph(filename, df, xSeriesName, ySeriesName):
	df.plot(x=xSeriesName, y=ySeriesName, kind='bar')
	plt.savefig(filename,format="svg")

def exampleDF():
	Data = {
		'Country': ['USA','Canada','Germany','UK','France'],
		'GDP_Per_Capita': [45000,42000,52000,49000,47000]
		}
	return DataFrame(Data,columns=['Country','GDP_Per_Capita'])