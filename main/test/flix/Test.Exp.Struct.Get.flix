struct Get[r] {
    fstName: String,
    lstName: String,
    mut age: Int32,
    cowboy: Bool
}
mod Get {

    @test
    def testStructGet01(): Bool =
        region rc {
            let s = new Get @ rc { fstName = "Lucky", lstName = "Luke", age = 42, cowboy = true };
            s->fstName == "Lucky" and s->lstName == "Luke" and s->age == 42 and s->cowboy == true
        }

    @test
    def testStructGet02(): String =
        region rc {
            let s = new Get @ rc { fstName = "Lucky", lstName = "Luke", age = 42, cowboy = true };
            s->lstName
        }

    @test
    def testStructGet03(): Int32 =
        region rc {
            let s = new Get @ rc { fstName = "Lucky", lstName = "Luke", age = 42, cowboy = true };
            s->age
        }

    @test
    def testStructGet04(): Bool =
        region rc {
            let s = new Get @ rc { fstName = "Lucky", lstName = "Luke", age = 42, cowboy = true };
            s->cowboy
        }

    @test
    def testStructMultiGet01(): Bool =
        region rc {
            let s = new Get @ rc { fstName = "Lucky", lstName = "Luke", age = 42, cowboy = true };
            let fstName = s->fstName;
            let lstName = s->lstName;
            let age = s->age;
            let cowboy = s->cowboy;
            fstName == "Lucky" and lstName == "Luke" and age == 42 and cowboy
        }

    @test
    def testStructMultiGet02(): Bool =
        region rc {
            let s = new Get @ rc { fstName = "Lucky", lstName = "Luke", age = 42, cowboy = true };
            let cowboy = s->cowboy;
            let age = s->age;
            let lstName = s->lstName;
            let fstName = s->fstName;
            fstName == "Lucky" and lstName == "Luke" and age == 42 and cowboy
        }

    @test
    def testStructMultiGet03(): Bool =
        region rc {
            let s = new Get @ rc { fstName = "Lucky", lstName = "Luke", age = 42, cowboy = true };
            let fstName1 = s->fstName;
            let fstName2 = s->fstName;
            let lstName1 = s->lstName;
            let lstName2 = s->lstName;
            fstName1 == "Lucky" and fstName2 == "Lucky" and lstName1 == "Luke" and lstName2 == "Luke"
        }

    @test
    def testStructMultiGet04(): Bool =
        region rc {
            let s = new Get @ rc { fstName = "Lucky", lstName = "Luke", age = 42, cowboy = true };
            let lstName1 = s->lstName;
            let fstName1 = s->fstName;
            let lstName2 = s->lstName;
            let fstName2 = s->fstName;
            fstName1 == "Lucky" and fstName2 == "Lucky" and lstName1 == "Luke" and lstName2 == "Luke"
        }

    @test
    def testStructPureGet01(): Bool = {
        let f = region rc {
            let s = new Get @ rc { fstName = "Lucky", lstName = "Luke", age = 42, cowboy = true };
            msg -> "${msg} ${s->fstName}"
        };
        f("Hello") == "Hello Lucky"
    }

    def getLastName(g: Get[rc]): String \ {} = g->lstName

    @test
    def testStructPureGet02(): Bool = {
        region rc {
            let s = new Get @ rc { fstName = "Lucky", lstName = "Luke", age = 42, cowboy = true };
            getLastName(s) == "Luke"
        }
    }
}

struct BinaryTree[t, r] {
    mut left: Option[BinaryTree[t, r]],
    mut right: Option[BinaryTree[t, r]],
    mut value: t
}

mod BinaryTree {
    def binaryTreeSum(tree: Option[BinaryTree[Int32, r]]): Int32 \ r =
        match tree {
            case None => 0
            case Some(t) => t->value + binaryTreeSum(t->left) + binaryTreeSum(t->right)
        }

    @test
    def binaryTree01(): Bool =
        region rc {
            let leaf = new BinaryTree @ rc {
                left = None,
                right = None,
                value = 3
            };
            let innernode = new BinaryTree @ rc {
                left = Some(leaf),
                right = Some(leaf),
                value = 4
            };
            let tree = new BinaryTree @ rc {
                left = Some(innernode),
                right = Some(innernode),
                value = 5
            };
            binaryTreeSum(Some(tree)) == 25
        }
}

struct Nested[v, r] {
    mut v: v
}
mod Nested {

    @test
    def nestedPut01(): Bool =
        region rc {
            let nested = new Nested @ rc { v = new Nested @ rc { v = new Nested @ rc {v = new Nested @ rc {v = 15}}}};
            nested->v->v->v->v == 15
        }

}
