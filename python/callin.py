import sys
sys.path += ['/usr/irissys/lib/python','/usr/irissys/mgr/python']
import iris

prod=iris.cls('HoleFoods.Product')._OpenId('SKU-101')
print(prod.Name,prod.Price)

## will throw <UNIMPLEMENTED> if calling by $ python3 python/callin.py
## Use $ /usr/irissys/bin/irispython python/callin.py , instead.
rs=iris.sql.exec("select Price p1 from HoleFoods.Product")
for idx,row in enumerate(rs):
   print(f"[{idx}]:{row}")
