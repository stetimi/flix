mod IndexOutOfBounds {
    pub def toResult(f: Unit -> a \ {e, IndexOutOfBounds}): Result[String, a] = try {
        Ok(f())
    } with IndexOutOfBounds {
        def throw(msg, _) = Err(msg)
    }
}
