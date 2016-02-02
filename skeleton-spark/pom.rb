project 'Kafka Spark Streaming' do

  model_version '4.0.0'
  id 'ermolaev:test-streaming:0.1-SNAPSHOT'
  packaging 'jar'

  repository( :id => 'apache release',
              :url => 'https://repository.apache.org/content/repositories/releases/' )
  repository( :id => 'scala-tools.org',
              :name => 'Scala-tools Maven2 Repository',
              :url => 'http://scala-tools.org/repo-releases' )

  plugin_repository( :id => 'scala-tools.org',
                     :name => 'Scala-tools Maven2 Repository',
                     :url => 'http://scala-tools.org/repo-releases' )

  properties( 'spark.core.version' => '1.5.2',
              'gson.version' => '2.2.4',
              'guava.version' => '13.0.1',
              'slf4j.version' => '1.7.5',
              'scala.version' => '2.10.4',
              'app.main.class' => 'com.test.core.streaming.Fake',
              'hadoop.version' => '2.6.0',
              'project.build.sourceEncoding' => 'UTF-8' )

  jar( 'org.apache.spark:spark-core_2.10:${spark.core.version}',
       :scope => 'provided',
       :exclusions => 'org.slf4j:slf4j-log4j12' )
  jar 'com.github.nscala-time:nscala-time_2.10:2.0.0'
  jar 'mysql:mysql-connector-java:5.1.28'
  jar 'org.scalaz:scalaz-core_2.10:7.1.3'
  jar 'org.scalatest:scalatest_2.10:2.2.4'
  jar( 'com.holdenkarau:spark-testing-base_2.10:1.4.1_0.1.1',
       :scope => 'test' )
  jar( 'org.apache.spark:spark-streaming_2.10:${spark.core.version}',
       :scope => 'provided',
       :exclusions => 'org.slf4j:slf4j-log4j12' )
  jar( 'org.apache.spark:spark-streaming-kafka_2.10:${spark.core.version}',
       :exclusions => 'org.slf4j:slf4j-log4j12' )
  jar( 'org.apache.hadoop:hadoop-common:${hadoop.version}',
       :scope => 'provided' )
  jar( 'org.slf4j:slf4j-api:${slf4j.version}',
       :scope => 'provided' )
  jar( 'org.scalamock:scalamock-scalatest-support_2.10:3.2',
       :scope => 'test' )
  jar 'org.scalanlp:breeze_2.10:0.9'
  jar( 'org.scala-lang:scala-library:${scala.version}',
       :scope => 'provided' )
  jar( 'com.twitter:parquet-hadoop:1.6.0',
       :scope => 'provided' )
  jar( 'com.twitter:parquet-hive-bundle:1.6.0',
       :scope => 'provided' )
  jar( 'org.apache.spark:spark-sql_2.10:${spark.core.version}',
       :scope => 'provided' )
  jar 'com.datastax.spark:spark-cassandra-connector_2.10:1.3.0'
  jar 'org.apache.spark:spark-hive_2.10:1.3.0'
  jar 'com.datastax.cassandra:cassandra-driver-core:2.1.4'

  overrides do
    plugin( 'net.alchim31.maven:scala-maven-plugin:3.2.1',
            'recompileMode' =>  'incremental' ) do
      execute_goals( 'add-source', 'compile',
                     :id => 'scala-compile-first',
                     :phase => 'process-resources' )
      execute_goals( 'add-source', 'testCompile',
                     :id => 'scala-test-compile',
                     :phase => 'process-test-resources' )
    end

    plugin( :compiler, '3.1',
            'source' =>  '1.7',
            'target' =>  '1.7',
            'compilerArgs' => [ '-Xfatal-warnings',
                                '-Xlint',
                                '-deprecation',
                                '-explaintypes' ] )
  end

  plugin 'net.alchim31.maven:scala-maven-plugin' do
    execute_goals( 'add-source', 'compile',
                   :id => 'scala-compile-first',
                   :phase => 'process-resources' )
    execute_goals( 'add-source', 'testCompile',
                   :id => 'scala-test-compile',
                   :phase => 'process-test-resources' )
  end

  plugin( 'org.scoverage:scoverage-maven-plugin:1.1.1',
          'scalaVersion' =>  '${scala.version}',
          'aggregate' =>  'true',
          'report' =>  'report',
          'highlighting' =>  'true' ) do
    execute_goals 'report'
  end

  plugin( 'org.scalastyle:scalastyle-maven-plugin:0.6.0',
          'verbose' =>  'false',
          'failOnViolation' =>  'true',
          'includeTestSourceDirectory' =>  'true',
          'failOnWarning' =>  'false',
          'sourceDirectory' =>  '${basedir}/src/main/scala',
          'testSourceDirectory' =>  '${basedir}/src/test/scala',
          'configLocation' =>  '${basedir}/lib/scalastyle_config.xml',
          'outputFile' =>  '${project.basedir}/scalastyle-output.xml',
          'outputEncoding' =>  'UTF-8' ) do
    execute_goals 'check'
  end

  plugin( 'org.scalatest:scalatest-maven-plugin:1.0',
          'reportsDirectory' =>  '${project.build.directory}/surefire-reports',
          'junitxml' =>  '.',
          'filereports' =>  'WDF TestSuite.txt' ) do
    execute_goals( 'test',
                   :id => 'test' )
  end

  plugin( :shade, '1.4',
          'createDependencyReducedPom' =>  'true' ) do
    execute_goals( 'shade',
                   :phase => 'package',
                   'transformers' => [ xml( '<transformer implementation="org.apache.maven.plugins.shade.resource.ServicesResourceTransformer"/>' ),
                                       xml( '<transformer implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer">
  <mainClass></mainClass>
</transformer>' ) ],
                   'filters' => [ { 'artifact' =>  '*:*',
                                    'excludes' => [ 'META-INF/*.SF',
                                                    'META-INF/*.DSA',
                                                    'META-INF/*.RSA' ] } ] )
  end

  plugin :resources, '2.7' do
    execute_goals( 'copy-resources',
                   :id => 'copy-resources',
                   :phase => 'validate',
                   'outputDirectory' =>  '${basedir}/target/classes/conf',
                   'resources' => [ { 'directory' =>  'resources/test/' },
                                    { 'directory' =>  'resources/main/scala/' },
                                    { 'directory' =>  'resources/conf',
                                      'filtering' =>  'true' } ] )
  end

end
