import pandas
import iris

def run():
    rs = iris.sql.exec('select ID,Price p1 ,Price*2 p2 from HoleFoods.Product')
    for row in rs:  
        print(row)

    df = iris.sql.exec('select ID,Price p1 ,Price*2 p2 from HoleFoods.Product').dataframe()
    print(df)
