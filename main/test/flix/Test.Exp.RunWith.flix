mod Test.Exp.RunWith {
    eff Print {
        def doIt(): Unit
    }

    eff Print2 {
        def doIt2(): Unit
    }

    eff Greet {
        def greet(name: String): Unit
    }

    eff Greet2 {
        def greet2(name: String): Unit
    }

    @Test
    def testRunWith01(): Unit = {
        run {
            Test.Exp.RunWith.Print.doIt()
        } with handler Print {
            def doIt(_cont) = ()
        }
    }

    @Test
    def testRunWith02(): Unit = {
        run {
            Test.Exp.RunWith.Print.doIt()
        } with handler Print {
            def doIt(_cont) = {
                run {
                    Test.Exp.RunWith.Print2.doIt2()
                } with handler Print2 {
                    def doIt2(_cont) = ()
                }
            }
        }
    }

    @Test
    def testRunWith03(): Unit = {
        let letsDoIt = () -> Test.Exp.RunWith.Print.doIt();
        run {
            letsDoIt()
        } with handler Print {
            def doIt(_cont) = ()
        }
    }

    @Test
    def testRunWith04(): Unit = {
        run {
            Test.Exp.RunWith.Greet.greet("Alice")
        } with handler Greet {
            def greet(_, _cont) = ()
        }
    }

    @Test
    def testRunWith05(): Unit = {
        run {
            Test.Exp.RunWith.Greet.greet("Duchess")
        } with handler Greet {
            def greet(name, _cont) = {
                run {
                    Test.Exp.RunWith.Greet2.greet2(name)
                } with handler Greet2 {
                    def greet2(_, _cont) = ()
                }
            }
        }
    }

    @Test
    def testRunWith06(): Unit = {
        def greetAll(names: List[String]) = match names {
            case Nil => ()
            case hd :: tl => {
                Test.Exp.RunWith.Greet.greet(hd);
                greetAll(tl)
            }
        };

        run {
            greetAll("Cheshire Cat" :: "Queen of Hearts" :: "White Rabbit" :: "Dormouse" :: Nil)
        } with handler Greet {
            def greet(_, _cont) = ()
        }
    }

    @Test
    def testRunWith07(): Unit = {
        run {
            Test.Exp.RunWith.Print.doIt()
        } with handler Print {
            def doIt(_cont) = ()
        } with handler Print {
            def doIt(_cont) = ()
        }
    }

    @Test
    def testRunWith08(): Unit = {
        run {
            Test.Exp.RunWith.Print.doIt()
        } with handler Print {
            def doIt(_cont) = {
                run {
                    Test.Exp.RunWith.Print2.doIt2()
                } with handler Print2 {
                    def doIt2(_cont) = ()
                } with handler Print2 {
                    def doIt2(_cont) = ()
                }
            }
        } with handler Print {
            def doIt(_cont) = ()
        }
    }

    @Test
    def testRunWith09(): Unit = {
        let f = () -> Test.Exp.RunWith.Print.doIt();
        run {
            f()
        } with handler Print {
            def doIt(_cont) = ()
        } with handler Print {
            def doIt(_cont) = ()
        }
    }

    @Test
    def testRunWith10(): Unit = {
        run {
            Test.Exp.RunWith.Greet.greet("Alice")
        } with handler Greet {
            def greet(_, _cont) = ()
        } with handler Greet {
            def greet(_, _cont) = ()
        }
    }

    @Test
    def testRunWith11(): Unit = {
        run {
            Test.Exp.RunWith.Greet.greet("Duchess")
        } with handler Greet {
            def greet(name, _cont) = {
                run {
                    Test.Exp.RunWith.Greet2.greet2(name)
                } with handler Greet2 {
                    def greet2(_, _cont) = ()
                }
            }
        } with handler Print { // Irrelevant effect but here to test the syntax
            def doIt(_) = ()
        }
    }

    @Test
    def testRunWith12(): Unit = {
        def greetAll(names: List[String]) = match names {
            case Nil => ()
            case hd :: tl => {
                Test.Exp.RunWith.Greet.greet(hd);
                greetAll(tl)
            }
        };

        run {
            greetAll("Cheshire Cat" :: "Queen of Hearts" :: "White Rabbit" :: "Dormouse" :: Nil)
        } with handler Greet {
            def greet(_, _cont) = ()
        } with handler Greet {
            def greet(_, _cont) = ()
        }
    }

    @Test
    def testRunWith13(): Unit = {
        let handle = handler Print {
            def doIt(_cont) = ()
        };
        run Test.Exp.RunWith.Print.doIt() with handle
    }

    @Test
    def testRunWith14(): Unit = {
        let handle = handler Print {
            def doIt(_cont) = {
                run Test.Exp.RunWith.Print2.doIt2() with g -> run {
                    g()
                } with handler Print2 {
                    def doIt2(_cont) = ()
                }
            }
        };
        run Test.Exp.RunWith.Print.doIt() with handle
    }

    @Test
    def testRunWith15(): Unit = {
        let letsDoIt = () -> Test.Exp.RunWith.Print.doIt();
        let handle = handler Print {
            def doIt(_cont) = ()
        };
        run letsDoIt() with handle
    }

    @Test
    def testRunWith16(): Unit = {
        def handle(x, f) = run {
            f(x)
        } with handler Greet {
            def greet(_, _cont) = ()
        };
        run Test.Exp.RunWith.Greet.greet("Alice") with handle(())
    }

    @Test
    def testRunWith17(): Unit = {
        let handler2 = f -> run {
            f()
        } with handler Greet2 {
            def greet2(_, _cont) = ()
        };
        def handler1(g, f) = run {
            f()
        } with handler Greet {
            def greet(name, _cont) = {
                run Test.Exp.RunWith.Greet2.greet2(name) with g
            }
        };
        run Test.Exp.RunWith.Greet.greet("Duchess") with handler1(handler2)
    }

    @Test
    def testRunWith18(): Unit = {
        def greetAll(names: List[String]) = match names {
            case Nil => ()
            case hd :: tl => {
                Test.Exp.RunWith.Greet.greet(hd);
                greetAll(tl)
            }
        };
        def handle(f) = run {
            f()
        } with handler Greet {
            def greet(_, _cont) = ()
        };

        run {
            greetAll("Cheshire Cat" :: "Queen of Hearts" :: "White Rabbit" :: "Dormouse" :: Nil)
        } with handle
    }

    @Test
    def testRunWith19(): Unit = {
        let handle = f -> run f() with handler Print {
            def doIt(_cont) = ()
        };
        run {
            Test.Exp.RunWith.Print.doIt()
        } with handle
        with handler Print {
            def doIt(_cont) = ()
        }
    }

    @Test
    def testRunWith20(): Unit = {
        let handle = f -> run f() with handler Print {
            def doIt(_cont) = ()
        };
        run {
            Test.Exp.RunWith.Print.doIt()
        } with handler Print {
            def doIt(_cont) = ()
        } with handle
    }

    def handler21(f: Unit -> Unit \ ef): Unit \ ef - Print =
        run f() with handler Print { def doIt(_cont) = () }

    @Test
    def testRunWith21(): Unit = {
        // handler21 is pulled out since it needs to be generalized over effects.
        run {
            Test.Exp.RunWith.Print.doIt()
        } with handler21
        with handler21
    }

    def handler22(f: Unit -> Unit \ ef): Unit \ ef - Print2 =
        run f() with handler Print2 { def doIt2(_cont) = () }

    @Test
    def testRunWith22(): Unit = {
        // handler22 is pulled out since it needs to be generalized over effects.
        run {
            Test.Exp.RunWith.Print.doIt()
        } with handler Print {
            def doIt(_cont) = {
                run {
                    Test.Exp.RunWith.Print2.doIt2()
                } with handler22 with handler22
            }
        } with handler Print {
            def doIt(_cont) = ()
        }
    }

    def handler23(x: t, f: Unit -> t \ ef): t \ ef - Print =
        run f() with handler Print { def doIt(_cont) = x }

    @Test
    def testRunWith23(): Unit = {
        let f = () -> Test.Exp.RunWith.Print.doIt();
        run {
            f()
        } with handler23(())
        with handler23(())
    }

    def handler24(x: String -> t \ ef1, f: Unit -> t \ ef2): t \ ef1 + (ef2 - Greet) =
        run f() with handler Greet { def greet(msg, _cont) = x(msg) }

    @Test
    def testRunWith24(): Unit = {
        run {
            Test.Exp.RunWith.Greet.greet("Alice")
        } with handler24(_ -> ())
        with handler24(_ -> ())
    }

    @Test
    def testRunWith25(): Unit = {
        let handle = handler Print { def doIt(_) = () };
        run {
            Test.Exp.RunWith.Greet.greet("Duchess")
        } with handler Greet {
            def greet(name, _cont) = {
                run {
                    Test.Exp.RunWith.Greet2.greet2(name)
                } with handler Greet2 {
                    def greet2(_, _cont) = ()
                }
            }
        } with handle // Irrelevant effect but here to test the syntax
    }

    def handler26(f: Unit -> Unit \ ef): Unit \ ef - Greet =
        run f() with handler Greet { def greet(_, _cont) = () }

    @Test
    def testRunWith26(): Unit = {
        def greetAll(names: List[String]) = match names {
            case Nil => ()
            case hd :: tl => {
                Test.Exp.RunWith.Greet.greet(hd);
                greetAll(tl)
            }
        };

        run {
            greetAll("Cheshire Cat" :: "Queen of Hearts" :: "White Rabbit" :: "Dormouse" :: Nil)
        } with handler26 with handler26
    }
}
