# iris-embeded-python

Use _SYSTEM / SYS as a credential.

```
$ docker compose up -d
```

全て実行
```
$ docker compose exec iris iris session iris "runall"
```

個別実行
```
$ docker compose exec iris iris session iris "##class(Test.Python).test1()"
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

RESTコール (実験コードです)
```
$ curl -u "appuser:sys" -H "Content-Type: application/json" http://localhost:52773/csp/user-rest/getp | jq
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    70  100    70    0     0   9417      0 --:--:-- --:--:-- --:--:-- 10000
{
  "A": "apple",
  "B": "banana",
  "C": "carrot",
  "D": "drink",
  "E": "卵"
}
$ curl -u "appuser:sys" -X POST -H "Content-Type: application/json" -d "@req.json" http://localhost:52773/csp/user-rest/postp/123 | jq

% Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   119  100    83  100    36  10918   4735 --:--:-- --:--:-- --:--:-- 17000
{
  "p1": "123",  
  "A": "apple",
  "B": "banana",
  "C": "carrot",
  "D": "drink",
  "E": "卵",
  "F": "あいうえお"
}
```

ObjestScriptからのopenpyxl使用例
```
$ docker compose exec iris iris session iris "##class(Test.ObjectScript).new()"
$ docker compose exec iris iris session iris "##class(Test.ObjectScript).modify()"
$ docker compose exec iris iris session iris "##class(Test.ObjectScript).modify2()"
$ docker compose cp iris:/home/irisowner/rsc/ /mnt/c/temp
```
Windowsでc:\temp\rsc\a.xlsx, Book1.xlsxを開く。

# shellで実行する場合

## IRIS内部から

```
$ iris session iris
USER>:py
>>> import pandas
```

## Python環境から

```
irisowner@iris:~$ venv/bin/python3
Python 3.12.3 (main, Feb  4 2025, 14:48:35) [GCC 13.3.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import pandas
>>> import iris
```

# IRISにおけるPythonの設定確認

merge.cpfでCPF_PythonPathを指定しています。これをしないと、pip installしたライブラリをIRIS内のpythonシェル内から見つけることが出来ません。

>pip installしたライブラリ=Dockerfileで記述しています。

```
USER>do ##class(%SYS.Python).GetPythonInfo(.info)
USER>w

info("AllowAnyPythonForIntegratedML")=0
info("BuildVersion")="3.12.3 (main, Sep 11 2024, 14:17:37) [GCC 13.2.0]"
info("BuildVersionShort")="3.12.3"
info("CPF_PythonPath")="/home/irisowner/venv/lib/python3.12/site-packages"    <==merge.cpfで指定
info("CPF_PythonRuntimeLibrary")=""
info("CPF_PythonRuntimeLibraryVersion")=""
info("IRISInsidePython")=2
info("PythonInsideIRIS")=7
info("RunningLibrary")=""
info("RunningVersion")="Not Loaded"
info("iris_site.py_platform")="dockerubuntux64"
USER>
```

# Debug

CLIベースのブレークポイント設定/デバッグは可能。
```
USER>w ##class(Test.Debug).Test1py()
> /usr/irissys/mgr/user/Debug(5)Test1py()
```