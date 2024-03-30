/*
 * Copyright 2022 Magnus Madsen
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
mod Assert {

    ///
    /// Asserts that `expected` must equal `actual`.
    ///
    /// Aborts execution if the two values are un-equal.
    ///
    pub def eq(expected: a, actual: a): Bool with Eq[a], ToString[a] = masked_cast({
        if (expected == actual)
            true
        else {
            use Console.{green, red};
            println("Assertion Error");
            println("  Expected: ${green(expected)}");
            println("  Actual:   ${red(actual)}");
            println("");
            ?assertEq
        }
    })

    pub def eqHandlingIndexOutOfBounds(expected: a, f: Unit -> a \ IndexOutOfBounds): Bool with Eq[a], ToString[a] =
        try {
            Assert.eq(expected, f())
        } with IndexOutOfBounds {
            def throw(_, _) = false
        }

    pub def throwsIndexOutOfBounds(expectedMsg: String, f: Unit -> a \ IndexOutOfBounds): Bool =
        try {
            discard f();
            false
        } with IndexOutOfBounds {
            def throw(msg, _k) = Assert.eq(expectedMsg, msg)
        }
}
