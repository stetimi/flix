/*
 * Copyright 2020 Magnus Madsen
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
package ca.uwaterloo.flix.api.lsp

import ca.uwaterloo.flix.language.ast.{SourceLocation, SourcePosition}
import ca.uwaterloo.flix.util.Result
import ca.uwaterloo.flix.util.Result.{Err, Ok}
import org.eclipse.lsp4j
import org.json4s.*
import org.json4s.JsonDSL.*

/**
  * Companion object for [[Position]].
  */
object Position {

  /**
    * Returns a position from the given source location `loc` using its beginning line and col.
    */
  def fromBegin(loc: SourceLocation): Position =
    Position(loc.beginLine, loc.beginCol)

  /**
    * Returns a position from the given source location `loc` using its ending line and col.
    */
  def fromEnd(loc: SourceLocation): Position =
    Position(loc.endLine, loc.endCol)

  /**
    * Returns a position from the given LSP `Position` `pos`.
    * NB: LSP line and column numbers are zero-indexed, but Flix uses one-indexed numbers internally.
    */
  def fromLsp4j(pos: lsp4j.Position): Position =
    Position(pos.getLine + 1, pos.getCharacter + 1)

  /**
    * Returns a position from the given source position `pos`.
    */
  def from(pos: SourcePosition): Position = Position(pos.lineOneIndexed, pos.colOneIndexed)

  /**
    * Tries to parse the given `json` value as a [[Position]].
    */
  def parse(json: JValue): Result[Position, String] = {
    // NB: LSP line and column numbers are zero-indexed, but Flix uses one-indexed numbers internally.
    val lineResult: Result[Int, String] = json \\ "line" match {
      case JInt(i) => Ok(i.toInt + 1) // Flix uses 1-indexed line numbers.
      case v => Err(s"Unexpected non-integer line number: '$v'.")
    }
    val characterResult: Result[Int, String] = json \\ "character" match {
      case JInt(i) => Ok(i.toInt + 1) // Flix uses one-indexed column numbers.
      case v => Err(s"Unexpected non-integer character: '$v'.")
    }
    for {
      line <- lineResult
      character <- characterResult
    } yield Position(line, character)
  }
}

/**
  * Represent a one-indexed position representation of an LSP `Position`.
  *
  * @param line      Line position in a document (one-indexed).
  * @param character Character offset on a line in a document (one-indexed).
  */
case class Position(line: Int, character: Int) extends Ordered[Position] {
  // NB: LSP line and column numbers are zero-indexed, but Flix uses one-indexed numbers internally.
  def toJSON: JValue = ("line" -> (line - 1)) ~ ("character" -> (character - 1))

  // NB: LSP line and column numbers are zero-indexed, but Flix uses one-indexed numbers internally.
  def toLsp4j: lsp4j.Position = new lsp4j.Position(line - 1, character - 1)

  def compare(that: Position): Int = {
    val lineComparison = this.line.compare(that.line)
    if (lineComparison != 0) lineComparison else this.character.compare(that.character)
  }

  /**
    * Returns `true` if `this` position is contained by the given source location `loc`
    * This check is inclusive for both ends.
    */
  def containedBy(loc: SourceLocation): Boolean =
    loc.beginLine <= line && line <= loc.endLine &&
      loc.beginCol <= character && character <= loc.endCol
}
