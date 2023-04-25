import pandas as pd
from sqlalchemy import create_engine
engine = create_engine("iris://_SYSTEM:SYS@localhost:1972/USER")

# create fake dataframes with a bunch of columns types
# and a bunch of rows
# columns types are: int, float, string, datetime, bool
df = pd.DataFrame({
    'int': [1, 2, 3, 4, 5],
    'float': [1.1, 2.2, 3.3, 4.4, 5.5],
    'string': ['a', 'b', 'c', 'd', 'e'],
    'datetime': pd.date_range('20130101', periods=5),
    'bool': [True, False, True, False, True]
})

# create a table in IRIS
df.to_sql('iris_table', engine, if_exists='replace', schema='sqlalchemy')

# read the table back from IRIS 
df2 = pd.read_sql('select * from sqlalchemy.iris_table', engine)

# print the dataframe
print(df2)

# print the table types in iris with sql type and class type
sql_def = """
SELECT Tables.TABLE_SCHEMA, Tables.TABLE_NAME, Columns.COLUMN_NAME, Columns.DATA_TYPE, Prop.Type
FROM INFORMATION_SCHEMA.TABLES AS Tables
INNER JOIN INFORMATION_SCHEMA.COLUMNS AS Columns 
    ON (Columns.TABLE_SCHEMA = Tables.TABLE_SCHEMA) AND (Columns.TABLE_NAME = Tables.TABLE_NAME)
INNER JOIN %Dictionary.CompiledProperty AS Prop 
    ON (Prop.parent = Tables.CLASSNAME and Prop.Name = Columns.COLUMN_NAME)
WHERE Tables.TABLE_NAME = 'iris_table' and Tables.TABLE_SCHEMA = 'sqlalchemy'"""

# execute the sql
df3 = pd.read_sql(sql_def, engine)

# print the dataframe
print(df3)