//scalaVersion in Global := "2.10"

def ProjectName(name: String,path:String): Project =  Project(name, file(path))

resolvers in Global ++= Seq(Resolver.mavenLocal,
           "https://repository.apache.org/content/repositories/releases/" at "https://repository.apache.org/content/repositories/releases/" ,
           "http://scala-tools.org/repo-releases" at "http://scala-tools.org/repo-releases" ,
           "https://repo.maven.apache.org/maven2" at "https://repo.maven.apache.org/maven2"
         )

val `com.datastax.cassandra_cassandra-driver-core` = "com.datastax.cassandra" % "cassandra-driver-core" % "2.1.4"

val `com.datastax.spark_spark-cassandra-connector_2.10` = "com.datastax.spark" % "spark-cassandra-connector_2.10" % "1.3.0"

val `com.github.nscala-time_nscala-time_2.10` = "com.github.nscala-time" % "nscala-time_2.10" % "2.0.0"

val `com.holdenkarau_spark-testing-base_2.10` = "com.holdenkarau" % "spark-testing-base_2.10" % "1.4.1_0.1.1"

val `com.twitter_parquet-hadoop` = "com.twitter" % "parquet-hadoop" % "1.6.0"

val `com.twitter_parquet-hive-bundle` = "com.twitter" % "parquet-hive-bundle" % "1.6.0"

val `mysql_mysql-connector-java` = "mysql" % "mysql-connector-java" % "5.1.28"

val `org.apache.hadoop_hadoop-common` = "org.apache.hadoop" % "hadoop-common" % "2.6.0"

val `org.apache.spark_spark-hive_2.10` = "org.apache.spark" % "spark-hive_2.10" % "1.3.0"

val `org.apache.spark_spark-core_2.10` = "org.apache.spark" % "spark-core_2.10" % "1.5.2"

val `org.apache.spark_spark-streaming_2.10` = "org.apache.spark" % "spark-streaming_2.10" % "1.5.2"

val `org.apache.spark_spark-streaming-kafka_2.10` = "org.apache.spark" % "spark-streaming-kafka_2.10" % "1.5.2"

val `org.apache.spark_spark-sql_2.10` = "org.apache.spark" % "spark-sql_2.10" % "1.5.2"

val `org.scala-lang_scala-library` = "org.scala-lang" % "scala-library" % "2.10.4"

val `org.scalamock_scalamock-scalatest-support_2.10` = "org.scalamock" % "scalamock-scalatest-support_2.10" % "3.2"

val `org.scalanlp_breeze_2.10` = "org.scalanlp" % "breeze_2.10" % "0.9"

val `org.scalatest_scalatest_2.10` = "org.scalatest" % "scalatest_2.10" % "2.2.4"

val `org.scalaz_scalaz-core_2.10` = "org.scalaz" % "scalaz-core_2.10" % "7.1.3"

val `org.slf4j_slf4j-api` = "org.slf4j" % "slf4j-api" % "1.7.5"


version := "0.1-SNAPSHOT"

name := "test-streaming"

organization := "ermolaev"

libraryDependencies in Global ++= Seq(`org.slf4j_slf4j-api` % "provided" ,
   `org.scalaz_scalaz-core_2.10`,
   `org.scalatest_scalatest_2.10`,
   `org.scalanlp_breeze_2.10`,
   `org.scalamock_scalamock-scalatest-support_2.10` % "test" ,
   `org.scala-lang_scala-library` % "provided" ,
   `org.apache.spark_spark-streaming_2.10` % "provided" ,
   `org.apache.spark_spark-streaming-kafka_2.10` % "provided",
   `org.apache.spark_spark-sql_2.10` % "provided" ,
   `org.apache.spark_spark-hive_2.10` % "provided",
   `org.apache.spark_spark-core_2.10` % "provided" ,
   `mysql_mysql-connector-java`,
   `com.twitter_parquet-hive-bundle` % "provided" ,
   `com.twitter_parquet-hadoop` % "provided" ,
   `com.holdenkarau_spark-testing-base_2.10` % "test" ,
   `com.github.nscala-time_nscala-time_2.10`,
   `com.datastax.spark_spark-cassandra-connector_2.10`,
   `com.datastax.cassandra_cassandra-driver-core`)



scalacOptions ++= Seq(
  "-Xfatal-warnings",
  "-Xlint",
  "-deprecation",
  "-explaintypes"
)

assemblyOption in assembly := (assemblyOption in assembly).value.copy(includeScala = false)
