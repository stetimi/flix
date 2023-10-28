/*
 * Copyright 2017 Magnus Madsen
 * Copyright 2021 Jonathan Lindegaard Starup
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

package ca.uwaterloo.flix.language.phase.jvm

import ca.uwaterloo.flix.api.Flix
import ca.uwaterloo.flix.language.ast.ReducedAst._
import ca.uwaterloo.flix.language.ast.{SourceLocation, Symbol}
import ca.uwaterloo.flix.runtime.CompilationResult
import ca.uwaterloo.flix.util.InternalCompilerException

import java.lang.reflect.InvocationTargetException

object JvmBackend {

  /**
    * Emits JVM bytecode for the given AST `root`.
    */
  def run(root: Root)(implicit flix: Flix): CompilationResult = flix.phase("JvmBackend") {

    // Put the AST root into implicit scope.
    implicit val r: Root = root

    // Generate all classes.
    val allClasses = flix.subphase("CodeGen") {

      //
      // First, collect information and types needed to generate classes.
      //

      // Compute the set of namespaces in the program.
      val namespaces = JvmOps.namespacesOf(root)

      // Compute the set of flattened types in the program.
      // All inner types will also be present in the set.
      val types = JvmOps.typesOf(root)

      // Filter the program types into different sets
      val erasedRefTypes = JvmOps.getErasedRefsOf(types)
      val erasedExtendTypes = JvmOps.getErasedRecordExtendsOf(types)
      val erasedFunctionTypes = JvmOps.getErasedArrowsOf(types)

      //
      // Second, generate classes.
      //

      val mainClass = GenMainClass.gen()

      val namespaceClasses = GenNamespaceClasses.gen(namespaces)

      // Generate function classes.
      val functionInterfaces = erasedFunctionTypes.map(genClass).toMap
      val functionClasses = GenFunctionClasses.gen(root.defs)
      val closureAbstractClasses = GenClosureAbstractClasses.gen(types)
      val closureClasses = GenClosureClasses.gen(root.defs)

      // Generate enum classes.
      val enumInterfaces = GenEnumInterfaces.gen(root.enums.values)
      val tagClasses = GenTagClasses.gen(root.enums.values.flatMap(_.cases.values))

      val tupleClasses = GenTupleClasses.gen(types)

      // Generate record classes.
      val recordInterfaces = Map(genClass(BackendObjType.Record))
      val recordEmptyClasses = Map(genClass(BackendObjType.RecordEmpty))
      val recordExtendClasses = erasedExtendTypes.map(genClass).toMap

      val refClasses = erasedRefTypes.map(genClass).toMap

      val lazyClasses = GenLazyClasses.gen(types)

      val anonClasses = GenAnonymousClasses.gen(root.anonClasses)

      val unitClass = Map(genClass(BackendObjType.Unit))

      // Generate error classes.
      val flixErrorClass = Map(genClass(BackendObjType.FlixError))
      val rslClass = Map(genClass(BackendObjType.ReifiedSourceLocation))
      val holeErrorClass = Map(genClass(BackendObjType.HoleError))
      val matchErrorClass = Map(genClass(BackendObjType.MatchError))

      val globalClass = Map(genClass(BackendObjType.Global))

      val regionClass = Map(genClass(BackendObjType.Region))

      val uncaughtExceptionHandlerClass = Map(genClass(BackendObjType.UncaughtExceptionHandler))

      // Generate effect runtime classes.
      val resultInterface = Map(genClass(BackendObjType.Result))
      val valueClass = Map(genClass(BackendObjType.Value))
      val frameInterface = Map(genClass(BackendObjType.Frame))
      val thunkAbstractClass = Map(genClass(BackendObjType.Thunk))
      val suspensionClass = Map(genClass(BackendObjType.Suspension))
      val framesInterface = Map(genClass(BackendObjType.Frames))
      val framesConsClass = Map(genClass(BackendObjType.FramesCons))
      val framesNilClass = Map(genClass(BackendObjType.FramesNil))
      val resumptionInterface = Map(genClass(BackendObjType.Resumption))
      val resumptionConsClass = Map(genClass(BackendObjType.ResumptionCons))
      val resumptionNilClass = Map(genClass(BackendObjType.ResumptionNil))
      val handlerInterface = Map(genClass(BackendObjType.Handler))
      val effectCallClass = Map(genClass(BackendObjType.EffectCall))

      // Collect all the classes and interfaces together.
      List(
        mainClass,
        namespaceClasses,
        functionInterfaces,
        functionClasses,
        closureAbstractClasses,
        closureClasses,
        enumInterfaces,
        tagClasses,
        tupleClasses,
        recordInterfaces,
        recordEmptyClasses,
        recordExtendClasses,
        refClasses,
        lazyClasses,
        anonClasses,
        unitClass,
        flixErrorClass,
        rslClass,
        holeErrorClass,
        matchErrorClass,
        globalClass,
        regionClass,
        uncaughtExceptionHandlerClass,
        resultInterface,
        valueClass,
        frameInterface,
        thunkAbstractClass,
        suspensionClass,
        framesInterface,
        framesConsClass,
        framesNilClass,
        resumptionInterface,
        resumptionConsClass,
        resumptionNilClass,
        handlerInterface,
        effectCallClass
      ).reduce(_ ++ _)
    }

    // Write each class (and interface) to disk.
    // NB: In interactive and test mode we skip writing the files to disk.
    if (flix.options.output.nonEmpty) {
      flix.subphase("WriteClasses") {
        for ((_, jvmClass) <- allClasses) {
          flix.subtask(jvmClass.name.toBinaryName, sample = true)
          JvmOps.writeClass(flix.options.output.get, jvmClass)
        }
      }
    }

    // Collect code size for performance tracking.
    val outputBytes = allClasses.map(_._2.bytecode.length).sum

    val loadClasses = flix.options.loadClassFiles

    if (!loadClasses) {
      // Do not load any classes.
      new CompilationResult(root, None, Map.empty, flix.getTotalTime, outputBytes)
    } else {
      // Loads all the generated classes into the JVM and initializes the method field of defs.
      // Returns the main of `Main.class` if it exists.
      val main = Loader.load(allClasses)

      // Return the compilation result.
      new CompilationResult(root, main, getCompiledDefs(root), flix.getTotalTime, outputBytes)
    }
  }

  private def genClass(g: Generatable)(implicit flix: Flix): (JvmName, JvmClass) = {
    (g.jvmName, JvmClass(g.jvmName, g.genByteCode()))
  }

  /**
    * Returns a map from non-closure definition symbols to executable functions (backed by JVM backend).
    */
  private def getCompiledDefs(root: Root)(implicit flix: Flix): Map[Symbol.DefnSym, () => AnyRef] =
    root.defs.foldLeft(Map.empty[Symbol.DefnSym, () => AnyRef]) {
      case (macc, (_, defn)) if defn.cparams.nonEmpty =>
        macc
      case (macc, (sym, _)) =>
        val args: Array[AnyRef] = Array(null)
        macc + (sym -> (() => link(sym, root).apply(args)))
    }

  /**
    * Returns a function object for the given definition symbol `sym`.
    */
  private def link(sym: Symbol.DefnSym, root: Root)(implicit flix: Flix): java.util.function.Function[Array[AnyRef], AnyRef] = {
    // Retrieve the definition and its type.
    val defn = root.defs.getOrElse(sym, throw InternalCompilerException(s"Linking error: '$sym' cannot be found in root defs", SourceLocation.Unknown))
    // Check that the method is initialized.
    if (defn.method == null) throw InternalCompilerException(s"Linking error: '$sym' has an uninitialized method.", SourceLocation.Unknown)

    // Construct the reflected function.
    (args: Array[AnyRef]) => {
      // Construct the arguments array.
      val argsArray = if (args.isEmpty) Array(null) else args
      val parameterCount = defn.method.getParameterCount
      val argumentCount = argsArray.length
      if (argumentCount != parameterCount) {
        throw new RuntimeException(s"Expected $parameterCount arguments, but got: $argumentCount for method ${defn.method.getName}.")
      }

      // Perform the method call using reflection.
      try {
        // Call the method passing the arguments.
        val result = defn.method.invoke(null, argsArray: _*)
        result
      } catch {
        case e: InvocationTargetException =>
          // Rethrow the underlying exception.
          throw e.getTargetException
      }
    }
  }

}
