package com.test.core.streaming
import com.holdenkarau.spark.testing._
import org.apache.spark.streaming._
import org.apache.spark.streaming.dstream._
import org.apache.spark._
import org.apache.spark.SparkContext._

import org.scalatest.exceptions.TestFailedException
import org.scalatest._
import org.scalamock.scalatest.MockFactory

import Matchers._
import com.test.core.streaming.Fake._

class FakeTest extends StreamingSuiteBase with ShouldMatchers with MockFactory {
  test("fakecalc test"){
    fakecalc() should equal (1.0)
  }
}
