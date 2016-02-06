package ermolaev.streaming


import java.util.HashMap

import org.apache.kafka.clients.producer.{KafkaProducer, ProducerConfig, ProducerRecord}

import org.apache.spark.SparkConf
import org.apache.spark.streaming._
import org.apache.spark.streaming.kafka._
import org.apache.log4j.Logger


object SimpleKafka {
  def main(args: Array[String]) {
    if (args.length < 1) {
      System.err.println("Необходимо указать kafka topic")
      System.exit(1)
    }

    // Create context with 2 second batch interval
    val sparkConf = new SparkConf().setAppName("Kafka")
    val ssc = new StreamingContext(sparkConf, Seconds(10))

    // Create direct kafka stream with brokers and topics
    val (zkQuorum, group) = ("localhost:2181", "spark-kafka-consumer")
    val topicMap = args(0).split(",").map((_, 1)).toMap
    val messages = KafkaUtils.createStream(ssc, zkQuorum, group, topicMap)

    messages.map(_._2).print()


    val Log = Logger.getLogger(SimpleKafka.this.getClass().getSimpleName())
    Log.error("DEBUG info:" + zkQuorum)


    sys.ShutdownHookThread {
      println("Gracefully stopping Application...")
      ssc.stop(stopSparkContext = true, stopGracefully = true) // или --conf spark.streaming.stopGracefullyOnShutdown=true
      println("Application stopped gracefully")
    }


    // Start the computation
    ssc.start()
    ssc.awaitTermination()
  }
}
