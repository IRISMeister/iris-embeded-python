# iris-embeded-python

Use _SYSTEM / SYS as a credential.

```
$ docker-compose up -d
```

全て実行
```
$ docker-compose exec iris iris session iris "runall"
```

個別実行
```
$ docker-compose exec iris iris session iris "##class(Test.Python).test1()"
<class 'pandas.core.frame.DataFrame'>
         id    p1     p2
0   SKU-101  11.8   23.6
1   SKU-192  11.8   23.6
2   SKU-195  51.8  103.6
3   SKU-199  79.8  159.6
4   SKU-203  15.8   31.6
5   SKU-204  17.0   34.0
6   SKU-222  23.8   47.6
7   SKU-223  19.8   39.6
8   SKU-287   7.8   15.6
9   SKU-296   7.8   15.6
10  SKU-451   4.6    9.2
11  SKU-601  91.8  183.6
12  SKU-708  19.8   39.6
13  SKU-709  15.8   31.6
14  SKU-712  23.8   47.6
15  SKU-900  35.8   71.6
16  SKU-928  27.8   55.6
<class 'numpy.ndarray'>
float64
[[ 11.8  23.6]
 [ 11.8  23.6]
 [ 51.8 103.6]
 [ 79.8 159.6]
 [ 15.8  31.6]
 [ 17.   34. ]
 [ 23.8  47.6]
 [ 19.8  39.6]
 [  7.8  15.6]
 [  7.8  15.6]
 [  4.6   9.2]
 [ 91.8 183.6]
 [ 19.8  39.6]
 [ 15.8  31.6]
 [ 23.8  47.6]
 [ 35.8  71.6]
 [ 27.8  55.6]]
      p1     p2       id
0   11.8   23.6  SKU-101
1   11.8   23.6  SKU-192
2   51.8  103.6  SKU-195
3   79.8  159.6  SKU-199
4   15.8   31.6  SKU-203
5   17.0   34.0  SKU-204
6   23.8   47.6  SKU-222
7   19.8   39.6  SKU-223
8    7.8   15.6  SKU-287
9    7.8   15.6  SKU-296
10   4.6    9.2  SKU-451
11  91.8  183.6  SKU-601
12  19.8   39.6  SKU-708
13  15.8   31.6  SKU-709
14  23.8   47.6  SKU-712
15  35.8   71.6  SKU-900
16  27.8   55.6  SKU-928
```

RESTコール
```
$ curl -u "appuser:sys" -X POST -H "Content-Type: application/json" -d "@req.json" http://localhost:52773/csp/user-rest/postp | jq

% Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   119  100    83  100    36  10918   4735 --:--:-- --:--:-- --:--:-- 17000
{
  "A": "apple",
  "B": "banana",
  "C": "carrot",
  "D": "drink",
  "E": "卵",
  "F": "あいうえお"
}
```

