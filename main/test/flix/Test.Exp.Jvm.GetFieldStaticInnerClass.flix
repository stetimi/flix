mod Test.Exp.Jvm.GetFieldStaticInnerClass {

    import dev.flix.test.TestClass$_StaticNestedClass
    import java.lang.Object

    @test
    def testGetBoolField01(): Bool \ IO =
        import java_get_field dev.flix.test.TestClass$_StaticNestedClass.boolField: Bool \ IO as getField;
        let o: TestClass$_StaticNestedClass = new TestClass$_StaticNestedClass();
        getField(o) == true

    @test
    def testGetCharField01(): Bool \ IO =
        import java_get_field dev.flix.test.TestClass$_StaticNestedClass.charField: Char \ IO as getField;
        let o: TestClass$_StaticNestedClass = new TestClass$_StaticNestedClass();
        getField(o) == 'A'

    @test
    def testGetFloat32Field01(): Bool \ IO =
        import java_get_field dev.flix.test.TestClass$_StaticNestedClass.float32Field: Float32 \ IO as getField;
        let o: TestClass$_StaticNestedClass = new TestClass$_StaticNestedClass();
        getField(o) == 123.456f32

    @test
    def testGetFloat64Field01(): Bool \ IO =
        import java_get_field dev.flix.test.TestClass$_StaticNestedClass.float64Field: Float64 \ IO as getField;
        let o: TestClass$_StaticNestedClass = new TestClass$_StaticNestedClass();
        getField(o) == 123.456f64

    @test
    def testGetInt8Field01(): Bool \ IO =
        import java_get_field dev.flix.test.TestClass$_StaticNestedClass.int8Field: Int8 \ IO as getField;
        let o: TestClass$_StaticNestedClass = new TestClass$_StaticNestedClass();
        getField(o) == 127i8

    @test
    def testGetInt16Field01(): Bool \ IO =
        import java_get_field dev.flix.test.TestClass$_StaticNestedClass.int16Field: Int16 \ IO as getField;
        let o: TestClass$_StaticNestedClass = new TestClass$_StaticNestedClass();
        getField(o) == 127i16

    @test
    def testGetInt32Field01(): Bool \ IO =
        import java_get_field dev.flix.test.TestClass$_StaticNestedClass.int32Field: Int32 \ IO as getField;
        let o: TestClass$_StaticNestedClass = new TestClass$_StaticNestedClass();
        getField(o) == 127i32

    @test
    def testGetInt64Field01(): Bool \ IO =
        import java_get_field dev.flix.test.TestClass$_StaticNestedClass.int64Field: Int64 \ IO as getField;
        let o: TestClass$_StaticNestedClass = new TestClass$_StaticNestedClass();
        getField(o) == 127i64

    @test
    def testGetStringField01(): Bool \ IO =
        import java_get_field dev.flix.test.TestClass$_StaticNestedClass.stringField: String \ IO as getField;
        let o: TestClass$_StaticNestedClass = new TestClass$_StaticNestedClass();
        getField(o) == "Hello World"

    @test
    def testGetPureField01(): Bool =
        import java_get_field dev.flix.test.TestClass$_StaticNestedClass.stringField: String \ {} as getField;
        let o: TestClass$_StaticNestedClass = unsafe new TestClass$_StaticNestedClass();
        getField(o) == "Hello World"

    @test
    def testGetObjectField01(): Object \ IO =
        import java_get_field dev.flix.test.TestClass$_StaticNestedClass.stringField: Object \ IO as getField;
        let o: TestClass$_StaticNestedClass = new TestClass$_StaticNestedClass();
        getField(o)
}
