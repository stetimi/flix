/*
 * Copyright 2024 Magnus Madsen, Herluf Baggesen
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package flix.fuzzers

import ca.uwaterloo.flix.TestUtils
import ca.uwaterloo.flix.api.Flix
import ca.uwaterloo.flix.language.ast.shared.SecurityContext
import org.scalatest.funsuite.AnyFunSuite

import java.nio.file.{Files, Paths}

class FuzzPrefixes extends AnyFunSuite with TestUtils {

  /**
    * The number of prefixes to compile for each program.
    */
  private val N: Int = 100

  test("simple-card-game") {
    val filepath = Paths.get("examples/larger-examples/simple-card-game.flix")
    val input = Files.readString(filepath)
    compilePrefixes(input)
  }

  test("the-ast-typing-problem-with-polymorphic-records") {
    val filepath = Paths.get("examples/records/the-ast-typing-problem-with-polymorphic-records.flix")
    val input = Files.readString(filepath)
    compilePrefixes(input)
  }

  test("ford-fulkerson") {
    val filepath = Paths.get("examples/larger-examples/datalog/ford-fulkerson.flix")
    val input = Files.readString(filepath)
    compilePrefixes(input)
  }

  /**
    * We break the given string `input` down into N prefixes and compile each of them.
    * For example, if N is 100 and the input has length 300 then we create prefixes of length 3, 6, 9, ...
    * The program may not be valid: We just care that it does not crash the compiler.
    */
  private def compilePrefixes(input: String): Unit = {
    val length = input.length
    val step = length / N

    val flix = new Flix()
    flix.compile()
    for (i <- 1 until N) {
      val e = Math.min(i * step, length)
      val prefix = input.substring(0, e)
      // We use the same name for all inputs to simulate editing a file
      flix.addSourceCode("<input>", prefix)(SecurityContext.AllPermissions)
      flix.compile() // We simply care that this does not crash.
    }
  }

}
