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
