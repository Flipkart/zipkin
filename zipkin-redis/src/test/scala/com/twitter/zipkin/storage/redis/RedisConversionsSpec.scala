/*
 * Copyright 2012 Tumblr Inc.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.twitter.zipkin.storage.redis

import com.twitter.zipkin.common.Span
import org.scalatest.{FunSuite, Matchers}

import scala.util.Random

class RedisConversionsSpec extends FunSuite with Matchers {
  val rand = new Random

  test("convert from a TraceLog and back") {
    val value = ExpiringValue(rand.nextLong(), rand.nextLong())
    chanBuf2ExpiringValue[Long](expiringValue2ChanBuf[Long](value)) should be (value)
  }

  test("convert from TimeRange and back") {
    val range = TimeRange(rand.nextLong(), rand.nextLong())
    decodeStartEnd(encodeStartEnd(range)) should be (range)
  }

  test("convert from long and back") {
    val long = rand.nextLong()
    chanBuf2Long(long2ChanBuf(long)) should be (long)
  }

  test("convert from double and back") {
    val double = rand.nextDouble()
    chanBuf2Double(double2ChanBuf(double)) should be (double)
  }

  test("convert from string and back") {
    val string = ((0 until (rand.nextInt(10) + 5)) map (_ => rand.nextPrintableChar())).mkString
    chanBuf2String(string2ChanBuf(string)) should be (string)
  }

  test("convert from span and back") {
    val span = Span(rand.nextLong(), rand.nextString(8), rand.nextLong(),
      Some(rand.nextLong()), List(), List())
    deserializeSpan(serializeSpan(span)) should be (span)
  }
}
