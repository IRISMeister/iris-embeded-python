FROM containers.intersystems.com/intersystems/iris-community:2025.1
ARG COMMIT_ID="unknown"

#USER root
#ENV DEBIAN_FRONTEND noninteractive
#RUN apt-get update && apt-get install -y tzdata
### IRIS itself doesn't require ja language pack
#RUN apt-get update && apt-get install -y language-pack-ja && update-locale LANG=ja_JP.UTF-8
#USER irisowner

ENV SRCDIR=src
ENV INITDIR=init

COPY --chown=$ISC_PACKAGE_IRISUSER:$ISC_PACKAGE_IRISGROUP init/ $INITDIR/

RUN iris start $ISC_PACKAGE_INSTANCENAME \ 
 && printf 'Do ##class(Config.NLS.Locales).Install("jpuw") h\n' | iris session $ISC_PACKAGE_INSTANCENAME -U %SYS \
 && printf 'Set tSC=$system.OBJ.Load("'$HOME/$INITDIR'/MyApps/Installer.cls","ck") Do:+tSC=0 $SYSTEM.Process.Terminate($JOB,1) h\n' | iris session $ISC_PACKAGE_INSTANCENAME \
 && printf 'Set tSC=##class(MyApps.Installer).setup() Do:+tSC=0 $SYSTEM.Process.Terminate($JOB,1) h\n' | iris session $ISC_PACKAGE_INSTANCENAME \
 && iris stop $ISC_PACKAGE_INSTANCENAME quietly

# separated app related code because "zpm install samples-bi" takes too long.
COPY --chown=$ISC_PACKAGE_IRISUSER:$ISC_PACKAGE_IRISGROUP src/ $SRCDIR/
COPY --chown=$ISC_PACKAGE_IRISUSER:$ISC_PACKAGE_IRISGROUP sql/ sql/
COPY --chown=$ISC_PACKAGE_IRISUSER:$ISC_PACKAGE_IRISGROUP Samples-Data/ Samples-Data/
RUN iris start $ISC_PACKAGE_INSTANCENAME \ 
 && printf 'Set tSC=##class(MyApps.Installer).appsetup() Do:+tSC=0 $SYSTEM.Process.Terminate($JOB,1) h\n' | iris session $ISC_PACKAGE_INSTANCENAME \
 && iris stop $ISC_PACKAGE_INSTANCENAME quietly

RUN iris start $ISC_PACKAGE_INSTANCENAME nostu quietly \
 && printf "kill ^%%SYS(\"JOURNAL\") kill ^SYS(\"NODE\") h\n" | iris session $ISC_PACKAGE_INSTANCENAME -B | cat \
 && iris stop $ISC_PACKAGE_INSTANCENAME quietly bypass \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/journal.log \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/IRIS.WIJ \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/iris.ids \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/alerts.log \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/journal/* \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/messages.log \
 && touch $ISC_PACKAGE_INSTALLDIR/mgr/messages.log \
 && echo $COMMIT_ID > $HOME/commit.txt

COPY --chown=$ISC_PACKAGE_IRISUSER:$ISC_PACKAGE_IRISGROUP rsc/ rsc/

# python(irispythonではなく)からSQLのクエリコンパイラを実行する際に必要なライブラリを加えるため
#ENV LD_LIBRARY_PATH=$ISC_PACKAGE_INSTALLDIR/bin:$LD_LIBRARY_PATH
ENV LD_LIBRARY_PATH=$ISC_PACKAGE_INSTALLDIR/bin

RUN python3 -m venv venv && venv/bin/pip install pandas numpy_financial matplotlib scikit-learn boto3 geopy openpyxl
# Community developed sqlalchemy driver.
RUN venv/bin/pip install sqlalchemy
RUN venv/bin/pip install sqlalchemy-iris https://github.com/intersystems-community/intersystems-irispython/releases/download/3.9.2/intersystems_iris-3.9.2-py3-none-any.whl

