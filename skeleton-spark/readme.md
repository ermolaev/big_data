# Maven
Родом из 2000-х, тогда в моде был XML, `pow.xml` не человеко читаем, чтобы понять как соберется проект нужно капитально вникать в конфигурационный файл.

- заводится и работает с пол пинка
- простая и понятная документация
- дефакто стандарт сборки в мире Java
- есть DSL https://github.com/takari/polyglot-maven

```
mvn io.takari.polyglot:polyglot-translate-plugin:translate -Dinput=pom.xml -Doutput=pom.rb
mvn clean package -DskipTests
```

```
ls target/test-streaming-0.1-SNAPSHOT.jar -sh
99M target/test-streaming-0.1-SNAPSHOT.jar

ls target_without_test/test-streaming-0.1-SNAPSHOT.jar -sh
97M target_without_test/test-streaming-0.1-SNAPSHOT.jar
```
# Аргументы для компиляции
https://docs.oracle.com/javase/8/docs/technotes/tools/windows/javac.htm

`-Xlint` Показывает все рекомендованные предупреждения.

`-deprecation` - Предупреждает об использовании устаревших элементов

http://www.scala-lang.org/files/archive/nightly/docs-2.10.2/manual/html/scalac.html


`-explaintypes` - Более подробная информация об ошибках

`-Xfatal-warnings` - Остановка компиляции при любых предупреждениях


# Gradle
- Сильно меняется API, много - The plugins DSL is currently incubating.
- не работает из коробки сборка JAR файла с зависимостями, подключил shadowJar (до этого пробывал fatJar, работает ужасно долго, получил ошибку -archive contains more than 65535, побороть не смог)
- гигантская документация https://docs.gradle.org/current/userguide/userguide.html, за 5 минут не разберешся
- итоговый JAR файл стал весить 190M

```
gradle init --type pom
gradle shadowJar
```

# SBT
- конвертер pom -> sbt, https://github.com/ajozwik/mvn2sbt
```
git clone https://github.com/ajozwik/mvn2sbt.git
cd mvn2sbt
scala Eff.sc /home/ermolaev/big_data/skeleton-spark
set javaOptions +="[-Dscala.version=2.11.0] [-Dsbt.version=0.13.9]"; converter/run /home/ermolaev/big_data/skeleton-spark'
```
- сборка в супер-jar - https://github.com/sbt/sbt-assembly
- не умееет разруливать зависимости (shading), как это делают Maven, Gradle, пришлось некоторым зависимостям прописать provided, не проходил тест при указании зависимости `'org.apache.hadoop-common_2.10' % "provided"`, ошибка как https://issues.apache.org/jira/browse/SPARK-1693
- конфигурационный файл самый удобный
- размер итогового jar файла 60M
- в spark уже встроена scala, значит можем её не компилировать, экономия 10M
- пожалуй мой выбор

43516197
# Nexus Repository Manager 3.0 (Milestone 7 Release)
```
cd ~/soft
wget http://download.sonatype.com/nexus/3/nexus-3.0.0-m7-unix.tar.gz
tar xvzf nexus-3.0.0-m7-unix.tar.gz
rm -rf nexus-3.0.0-m7-unix.tar.gz
./nexus run
~/soft/nexus-3.0.0-b2016011501/bin/nexus run
```
войти как администратор `admin:admin123`

```
mvn release:clean
# делаем комит версии для которой должны собрать пакет, если был коммит версии без SNAPSHOT, то в pom.xml SNAPSHOT нужно проставить
mvn release:prepare
mvn release:perform
```

- Nexus 3 версии выдавал не понятные ошибки по которым не понятно было что у меня сделано не так, пришлось установить 2 версию, с ней все норм, интерфейсы сильно отличаются
- Какой минимальный интервал выполнения проверки репозитория? `1 час`
- Какие файлы загружает в репозиторий maven? `артефакты`

- Какие настройки надо задать, что б загрузить файл в нексус,требующий аутентификации, с помощью maven ?

`cat ~/.m2/settings.xml`
```
<settings>
	<servers>
		<server>
			<id>nexus</id>
			<username>admin</username>
			<password>admin123</password>
		</server>
	 </servers>
</settings>
<mirrors>
	<mirror>
		<id>nexus</id>
		<mirrorOf>*</mirrorOf>
		<url>http://localhost:8081/nexus/content/repositories/central</url>
	</mirror>
</mirrors>
```
pom.xml
```
<scm>
  <connection>scm:git:git@github.com:ermolaev/big_data.git</connection>
  <url>scm:git:git@github.com:ermolaev/big_data.git</url>
  <developerConnection>scm:git:git@github.com:ermolaev/big_data.git</developerConnection>
  <tag>0.6</tag>
</scm>
<distributionManagement>
  <repository>
    <id>nexus</id>
    <name>testrepo releases repository</name>
    <url>http://localhost:8081/nexus/content/repositories/testrepo</url>
  </repository>
  <snapshotRepository>
    <id>nexus</id>
    <name>jazzteam snapshot repository</name>
    <url>http://localhost:8081/nexus/content/repositories/snapshots</url>
  </snapshotRepository>
</distributionManagement>
```

- в нексус заливаются только снапшеты, как залить обычный релиз не понял
