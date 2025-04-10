/*
 * Copyright 2023 Xavier deSouza
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

mod TestMutPriorityQueue {

    /////////////////////////////////////////////////////////////////////////////
    // emptyWithCapacity                                                       //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def emptyWithCapacity01(): Bool = region rc {
        let mq: MutPriorityQueue[Int32, rc] = MutPriorityQueue.emptyWithCapacity(rc, 10);
        MutPriorityQueue.toString(mq) == "MutPriorityQueue {}"
    }

    @test
    def emptyWithCapacity02(): Bool = region rc {
        let mq: MutPriorityQueue[Int32, rc] = MutPriorityQueue.emptyWithCapacity(rc, -1);
        MutPriorityQueue.toString(mq) == "MutPriorityQueue {}"
    }

    @test
    def emptyWithCapacity03(): Bool = region rc {
        let mq: MutPriorityQueue[Int32, rc] = MutPriorityQueue.emptyWithCapacity(rc, 0);
        MutPriorityQueue.enqueue(4, mq);
        MutPriorityQueue.enqueue(5, mq);
        MutPriorityQueue.toString(mq) == "MutPriorityQueue {5, 4}"
    }

    /////////////////////////////////////////////////////////////////////////////
    // toString                                                                //
    /////////////////////////////////////////////////////////////////////////////

    @Test
    def testToString01(): Bool = region rc {
        let mq = (MutPriorityQueue.empty(rc) : MutPriorityQueue[Char, rc]);
        MutPriorityQueue.toString(mq) == "MutPriorityQueue {}"
    }

    @Test
    def testToString02(): Bool = region rc {
        let mq = MutPriorityQueue.empty(rc);
        MutPriorityQueue.enqueue(3, mq);
        MutPriorityQueue.toString(mq) == "MutPriorityQueue {3}"
    }

    @Test
    def testToString03(): Bool = region rc {
        let mq = MutPriorityQueue.empty(rc);
        MutPriorityQueue.enqueueAll(1 :: 2 :: 3 :: 4 :: 5 :: 6 :: 7 :: 8 :: Nil, mq);
        MutPriorityQueue.dequeue(mq);
        MutPriorityQueue.dequeue(mq);
        MutPriorityQueue.toString(mq) == "MutPriorityQueue {6, 4, 5, 1, 3, 2}"
    }

    /////////////////////////////////////////////////////////////////////////////
    // new                                                                     //
    /////////////////////////////////////////////////////////////////////////////

    @Test
    def testEmpty01(): Bool = region rc {
        let mq = MutPriorityQueue.empty(rc);
        MutPriorityQueue.size(mq) == 0
    }

    /////////////////////////////////////////////////////////////////////////////
    // size                                                                    //
    /////////////////////////////////////////////////////////////////////////////

    @Test
    def testSize01(): Bool = region rc {
        let mq = MutPriorityQueue.empty(rc);
        MutPriorityQueue.size(mq) == 0
    }

    @Test
    def testSize02(): Bool = region rc {
        let mq = MutPriorityQueue.empty(rc);
        MutPriorityQueue.enqueueAll("a" :: "b" :: "c" :: "d" :: "e" :: Nil, mq);
        MutPriorityQueue.size(mq) == 5
    }

    @Test
    def testSize03(): Bool = region rc {
        let mq = MutPriorityQueue.empty(rc);
        MutPriorityQueue.enqueueAll(1 :: 2 :: 3 :: 4 :: 5 :: 6 :: 7 :: 8 :: Nil, mq);
        MutPriorityQueue.dequeue(mq);
        MutPriorityQueue.size(mq) == 7
    }

    /////////////////////////////////////////////////////////////////////////////
    // isEmpty                                                                 //
    /////////////////////////////////////////////////////////////////////////////

    @Test
    def testIsEmpty01(): Bool = region rc {
        let mq = MutPriorityQueue.empty(rc);
        MutPriorityQueue.isEmpty(mq)
    }

    @Test
    def testIsEmpty02(): Bool = region rc {
        let mq = MutPriorityQueue.empty(rc);
        MutPriorityQueue.enqueue("a", mq);
        not MutPriorityQueue.isEmpty(mq)
    }

    @Test
    def testIsEmpty03(): Bool = region rc {
        let mq = MutPriorityQueue.empty(rc);
        MutPriorityQueue.enqueueAll(1 :: 2 :: 3 :: Nil, mq);
        MutPriorityQueue.dequeue(mq);
        MutPriorityQueue.dequeue(mq);
        MutPriorityQueue.dequeue(mq);
        MutPriorityQueue.isEmpty(mq)
    }

    @Test def testIsEmpty04(): Bool = region rc {
        let mq = MutPriorityQueue.empty(rc);
        MutPriorityQueue.enqueueAll(1 :: 2 :: Nil, mq);
        MutPriorityQueue.dequeue(mq);
        MutPriorityQueue.dequeue(mq);
        MutPriorityQueue.enqueue(1, mq);
        not MutPriorityQueue.isEmpty(mq)
    }

    /////////////////////////////////////////////////////////////////////////////
    // nonEmpty                                                                //
    /////////////////////////////////////////////////////////////////////////////

    @Test
    def testNonEmpty01(): Bool = region rc {
        let mq = MutPriorityQueue.empty(rc);
        not MutPriorityQueue.nonEmpty(mq)
    }

    @Test
    def testNonEmpty02(): Bool = region rc {
        let mq = MutPriorityQueue.empty(rc);
        MutPriorityQueue.enqueue("a", mq);
        MutPriorityQueue.nonEmpty(mq)
    }

    @Test
    def testNonEmpty03(): Bool = region rc {
        let mq = MutPriorityQueue.empty(rc);
        MutPriorityQueue.enqueueAll(1 :: 2 :: 3 :: Nil, mq);
        MutPriorityQueue.dequeue(mq);
        MutPriorityQueue.dequeue(mq);
        MutPriorityQueue.dequeue(mq);
        not MutPriorityQueue.nonEmpty(mq)
    }

    @Test
    def testNonEmpty04(): Bool = region rc {
        let mq = MutPriorityQueue.empty(rc);
        MutPriorityQueue.enqueueAll(1 :: 2 :: Nil, mq);
        MutPriorityQueue.dequeue(mq);
        MutPriorityQueue.dequeue(mq);
        MutPriorityQueue.enqueue(1, mq);
        MutPriorityQueue.nonEmpty(mq)
    }

    /////////////////////////////////////////////////////////////////////////////
    // peek                                                                    //
    /////////////////////////////////////////////////////////////////////////////

    @Test
    def testPeek01(): Bool = region rc {
        let mq = MutPriorityQueue.empty(rc);
        MutPriorityQueue.enqueue(3, mq);
        MutPriorityQueue.dequeue(mq);
        MutPriorityQueue.peek(mq) == None
    }

    @Test
    def testPeek02(): Bool = region rc {
        let mq = MutPriorityQueue.empty(rc);
        MutPriorityQueue.enqueue(1, mq);
        MutPriorityQueue.peek(mq) == Some(1)
    }

    @Test
    def testPeek03(): Bool = region rc {
        let mq = MutPriorityQueue.empty(rc);
        MutPriorityQueue.enqueueAll(1 :: 9 :: 2 :: 8 :: 3 :: 7 :: Nil, mq);
        MutPriorityQueue.dequeue(mq);
        MutPriorityQueue.peek(mq) == Some(8)
    }

    @Test
    def testPeek04(): Bool = region rc {
        let mq = (MutPriorityQueue.empty(rc) : MutPriorityQueue[Int32, rc]);
        MutPriorityQueue.peek(mq) == None
    }

    @Test
    def testPeek05(): Bool = region rc {
        let mq = MutPriorityQueue.empty(rc);
        MutPriorityQueue.enqueue(5, mq);
        MutPriorityQueue.enqueue(5, mq);
        MutPriorityQueue.dequeue(mq);
        MutPriorityQueue.peek(mq) == Some(5)
    }

    /////////////////////////////////////////////////////////////////////////////
    // enqueue                                                                 //
    /////////////////////////////////////////////////////////////////////////////

    @Test
    def testEnqueue01(): Bool = region rc {
        let mq = MutPriorityQueue.empty(rc);
        MutPriorityQueue.enqueue("a", mq);
        MutPriorityQueue.size(mq) == 1
    }

    @Test
    def testEnqueue02(): Bool = region rc {
        let mq = MutPriorityQueue.empty(rc);
        MutPriorityQueue.enqueue(3, mq);
        MutPriorityQueue.enqueue(2, mq);
        MutPriorityQueue.toString(mq) == "MutPriorityQueue {3, 2}"
    }

    @Test
    def testEnqueue03(): Bool = region rc {
        let mq = MutPriorityQueue.empty(rc);
        MutPriorityQueue.enqueue(2, mq);
        MutPriorityQueue.enqueue(3, mq);
        MutPriorityQueue.toString(mq) == "MutPriorityQueue {3, 2}"
    }

    @Test
    def testEnqueue04(): Bool = region rc {
        let mq = MutPriorityQueue.empty(rc);
        MutPriorityQueue.enqueue("a", mq);
        MutPriorityQueue.enqueue("b", mq);
        MutPriorityQueue.enqueue("c", mq);
        MutPriorityQueue.enqueue("a", mq);
        MutPriorityQueue.enqueue("a", mq);
        MutPriorityQueue.peek(mq) == Some("c")
    }

    @Test
    def testEnqueue05(): Bool = region rc {
        let mq = MutPriorityQueue.empty(rc);
        MutPriorityQueue.enqueue(3, mq);
        MutPriorityQueue.enqueue(4, mq);
        MutPriorityQueue.enqueue(5, mq);
        MutPriorityQueue.enqueue(6, mq);
        MutPriorityQueue.enqueue(10, mq);
        MutPriorityQueue.enqueue(5, mq);
        MutPriorityQueue.enqueue(7, mq);
        MutPriorityQueue.enqueue(14, mq);
        MutPriorityQueue.enqueue(20, mq);
        MutPriorityQueue.peek(mq) == Some(20)
    }

    /////////////////////////////////////////////////////////////////////////////
    // dequeue                                                                 //
    /////////////////////////////////////////////////////////////////////////////

    @Test
    def testDequeue01(): Bool = region rc {
        let mq = (MutPriorityQueue.empty(rc) : MutPriorityQueue[Int32, rc]);
        MutPriorityQueue.dequeue(mq);
        MutPriorityQueue.size(mq) == 0
    }

    @Test
    def testDequeue02(): Bool = region rc {
        let mq = (MutPriorityQueue.empty(rc) : MutPriorityQueue[Int32, rc]);
        MutPriorityQueue.dequeue(mq) == None
    }

    @Test
    def testDequeue03(): Bool = region rc {
        let mq = MutPriorityQueue.empty(rc);
        MutPriorityQueue.enqueueAll(1 :: 2 :: 3 :: 4 :: 5 :: Nil, mq);
        MutPriorityQueue.dequeue(mq);
        MutPriorityQueue.dequeue(mq);
        MutPriorityQueue.size(mq) == 3
    }

    @Test
    def testDequeue04(): Bool = region rc {
        let mq = MutPriorityQueue.empty(rc);
        MutPriorityQueue.enqueueAll(1 :: 2 :: 3 :: 4 :: 5 :: Nil, mq);
        MutPriorityQueue.dequeue(mq);
        MutPriorityQueue.dequeue(mq) == Some(4)
    }

    @Test
    def testDequeue05(): Bool = region rc {
        let mq = MutPriorityQueue.empty(rc);
        MutPriorityQueue.enqueueAll(1 :: 2 :: 3 :: Nil, mq);
        MutPriorityQueue.dequeue(mq);
        MutPriorityQueue.dequeue(mq);
        MutPriorityQueue.dequeue(mq);
        MutPriorityQueue.size(mq) == 0
    }

    /////////////////////////////////////////////////////////////////////////////
    // enqueueAll                                                              //
    /////////////////////////////////////////////////////////////////////////////

    @Test
    def testEnqueueAll01(): Bool = region rc {
        let mq = (MutPriorityQueue.empty(rc) : MutPriorityQueue[Int32, rc]);
        MutPriorityQueue.enqueueAll(Nil, mq);
        MutPriorityQueue.toString(mq) == "MutPriorityQueue {}"
    }

    @Test
    def testEnqueueAll02(): Bool = region rc {
        let mq = MutPriorityQueue.empty(rc);
        MutPriorityQueue.enqueueAll(Nil, mq);
        MutPriorityQueue.enqueueAll(1 :: Nil, mq);
        MutPriorityQueue.toString(mq) == "MutPriorityQueue {1}"
    }

    @Test
    def testEnqueueAll03(): Bool = region rc {
        let mq = MutPriorityQueue.empty(rc);
        MutPriorityQueue.enqueueAll(Nil, mq);
        MutPriorityQueue.enqueueAll(1 :: 2 :: 3 :: Nil, mq);
        MutPriorityQueue.enqueueAll(4 :: 5 :: 6 :: Nil, mq);
        MutPriorityQueue.toString(mq) == "MutPriorityQueue {6, 4, 5, 1, 3, 2}"
    }

    @Test
    def testEnqueueAll04(): Bool = region rc {
        let mq = MutPriorityQueue.empty(rc);
        MutPriorityQueue.enqueueAll(Nil, mq);
        MutPriorityQueue.enqueueAll(1 :: 2 :: 3 :: 4 :: 5 :: 6 :: 7 :: 8 :: Nil, mq);
        MutPriorityQueue.enqueueAll(Nil, mq);
        MutPriorityQueue.toString(mq) == "MutPriorityQueue {8, 7, 6, 4, 3, 2, 5, 1}"
    }

    /////////////////////////////////////////////////////////////////////////////
    // iterator                                                                //
    /////////////////////////////////////////////////////////////////////////////

    @Test
    def testIterator01(): Bool = region rc {
        let mq = MutPriorityQueue.empty(rc);
        let it = MutPriorityQueue.iterator(rc, mq);
        let sum = Ref.fresh(rc, 0);
        Iterator.forEach(x -> Ref.put(Ref.get(sum) + x, sum), it);
        Ref.get(sum) == 0
    }

    @Test
    def testIterator02(): Bool = region rc {
        let mq = MutPriorityQueue.empty(rc);
        MutPriorityQueue.enqueueAll(1 :: Nil, mq);
        let it = MutPriorityQueue.iterator(rc, mq);
        Iterator.toList(it) == 1 :: Nil
    }

    @Test
    def testIterator03(): Bool = region rc {
        let mq = MutPriorityQueue.empty(rc);
        MutPriorityQueue.enqueueAll("a" :: "c" :: "g" :: "t" :: Nil, mq);
        let it = MutPriorityQueue.iterator(rc, mq);
        let str = Ref.fresh(rc, "");
        Iterator.forEach(x -> Ref.put(String.concat(x, Ref.get(str)), str), it);
        Ref.get(str) == "acgt"
    }

    /////////////////////////////////////////////////////////////////////////////
    // toList                                                                  //
    /////////////////////////////////////////////////////////////////////////////

    @Test
    def testToList01(): Bool = region rc {
        let mq = (MutPriorityQueue.empty(rc) : MutPriorityQueue[Int32, rc]);
        MutPriorityQueue.toList(mq) == Nil
    }

    @Test
    def testToList02(): Bool = region rc {
        let mq = MutPriorityQueue.empty(rc);
        MutPriorityQueue.enqueue(1, mq);
        MutPriorityQueue.toList(mq) == 1 :: Nil
    }

    @Test
    def testToList03(): Bool = region rc {
        let mq = MutPriorityQueue.empty(rc);
        MutPriorityQueue.enqueueAll(1 :: 2 :: Nil, mq);
        MutPriorityQueue.toList(mq) == 2 :: 1 :: Nil
    }

    @Test
    def testToList04(): Bool = region rc {
        let mq = MutPriorityQueue.empty(rc);
        MutPriorityQueue.enqueueAll(1 :: 2 :: Nil, mq);
        MutPriorityQueue.toList(mq) == 2 :: 1 :: Nil
    }

    @Test
    def testToList05(): Bool = region rc {
        let mq = MutPriorityQueue.empty(rc);
        MutPriorityQueue.enqueueAll(1 :: 2 :: 3 :: 4 :: 5 :: 6 :: 7 :: 8 :: Nil, mq);
        MutPriorityQueue.toList(mq) == 8 :: 7 :: 6 :: 4 :: 3 :: 2 :: 5 :: 1 :: Nil
    }

    @Test
    def testToList06(): Bool = region rc {
        let mq = MutPriorityQueue.empty(rc);
        MutPriorityQueue.enqueueAll(1 :: 2 :: 3 :: 4 :: 5 :: 6 :: 7 :: 8 :: Nil, mq);
        MutPriorityQueue.dequeue(mq);
        MutPriorityQueue.dequeue(mq);
        MutPriorityQueue.toList(mq) == 6 :: 4 :: 5 :: 1 :: 3 :: 2 :: Nil
    }

    /////////////////////////////////////////////////////////////////////////////
    // toNel                                                                   //
    /////////////////////////////////////////////////////////////////////////////

    @Test
    def testToNel01(): Bool = region rc {
        let mq = (MutPriorityQueue.empty(rc) : MutPriorityQueue[Int32, rc]);
        MutPriorityQueue.toNel(mq) == None
    }

    @Test
    def testToNel02(): Bool = region rc {
        let mq = MutPriorityQueue.empty(rc);
        MutPriorityQueue.enqueue(1, mq);
        MutPriorityQueue.toNel(mq) == Some(Nel.Nel(1, Nil))
    }

    @Test
    def testToNel03(): Bool = region rc {
        let mq = MutPriorityQueue.empty(rc);
        MutPriorityQueue.enqueueAll(1 :: 2 :: 3 :: Nil, mq);
        MutPriorityQueue.toNel(mq) == Some(Nel.Nel(3, 1 :: 2 :: Nil))
    }

    @Test
    def testToNel04(): Bool = region rc {
        let mq = MutPriorityQueue.empty(rc);
        MutPriorityQueue.enqueueAll(1 :: 2 :: 3 :: 4 :: 5 :: 6 :: 7 :: 8 :: Nil, mq);
        MutPriorityQueue.toNel(mq) == Some(Nel.Nel(8, 7 :: 6 :: 4 :: 3 :: 2 :: 5 :: 1 :: Nil))
    }

    @Test
    def testToNel05(): Bool = region rc {
        let mq = MutPriorityQueue.empty(rc);
        MutPriorityQueue.enqueueAll(1 :: 2 :: 3 :: 4 :: 5 :: 6 :: 7 :: 8 :: Nil, mq);
        MutPriorityQueue.dequeue(mq);
        MutPriorityQueue.dequeue(mq);
        MutPriorityQueue.toNel(mq) == Some(Nel.Nel(6, 4 :: 5 :: 1 :: 3 :: 2 :: Nil))
    }

    /////////////////////////////////////////////////////////////////////////////
    // toArray                                                                 //
    /////////////////////////////////////////////////////////////////////////////

    @Test
    def testToArray01(): Bool = region rc {
        let mq = (MutPriorityQueue.empty(rc) : MutPriorityQueue[Int32, rc]);
        Array.toString(MutPriorityQueue.toArray(rc, mq)) == "Array#{}"
    }

    @Test
    def testToArray02(): Bool = region rc {
        let mq = (MutPriorityQueue.empty(rc) : MutPriorityQueue[Int32, rc]);
        MutPriorityQueue.enqueue(1, mq);
        Array.toString(MutPriorityQueue.toArray(rc, mq)) == "Array#{1}"
    }

    @Test
    def testToArray03(): Bool = region rc {
        let mq = (MutPriorityQueue.empty(rc) : MutPriorityQueue[Int32, rc]);
        MutPriorityQueue.enqueueAll(1 :: 2 :: Nil, mq);
        Array.toString(MutPriorityQueue.toArray(rc, mq)) == "Array#{2, 1}"
    }

    @Test
    def testToArray04(): Bool = region rc {
        let mq = (MutPriorityQueue.empty(rc) : MutPriorityQueue[Int32, rc]);
        MutPriorityQueue.enqueueAll(2 :: 1 :: Nil, mq);
        Array.toString(MutPriorityQueue.toArray(rc, mq)) == "Array#{2, 1}"
    }

    @Test
    def testToArray05(): Bool = region rc {
        let mq = (MutPriorityQueue.empty(rc) : MutPriorityQueue[Int32, rc]);
        MutPriorityQueue.enqueueAll(1 :: 2 :: 3 :: 4 :: 5 :: 6 :: 7 :: 8 :: Nil, mq);
        Array.toString(MutPriorityQueue.toArray(rc, mq)) == "Array#{8, 7, 6, 4, 3, 2, 5, 1}"
    }

    @Test
    def testToArray06(): Bool = region rc {
        let mq = (MutPriorityQueue.empty(rc) : MutPriorityQueue[Int32, rc]);
        MutPriorityQueue.enqueueAll(1 :: 2 :: 3 :: 4 :: 5 :: 6 :: 7 :: 8 :: Nil, mq);
        MutPriorityQueue.dequeue(mq);
        MutPriorityQueue.dequeue(mq);
        Array.toString(MutPriorityQueue.toArray(rc, mq)) == "Array#{6, 4, 5, 1, 3, 2}"
    }

    /////////////////////////////////////////////////////////////////////////////
    // toVector                                                                //
    /////////////////////////////////////////////////////////////////////////////

    @Test
    def testToVector01(): Bool = region rc {
        let mq = (MutPriorityQueue.empty(rc) : MutPriorityQueue[Int32, rc]);
        MutPriorityQueue.toVector(mq) == (Vector#{} : Vector[Int32])
    }

    @Test
    def testToVector02(): Bool = region rc {
        let mq = (MutPriorityQueue.empty(rc) : MutPriorityQueue[Int32, rc]);
        MutPriorityQueue.enqueue(1, mq);
        MutPriorityQueue.toVector(mq) == Vector#{1}
    }

    @Test
    def testToVector03(): Bool = region rc {
        let mq = (MutPriorityQueue.empty(rc) : MutPriorityQueue[Int32, rc]);
        MutPriorityQueue.enqueueAll(1 :: 2 :: Nil, mq);
        MutPriorityQueue.toVector(mq) == Vector#{2, 1}
    }

    @Test
    def testToVector04(): Bool = region rc {
        let mq = (MutPriorityQueue.empty(rc) : MutPriorityQueue[Int32, rc]);
        MutPriorityQueue.enqueueAll(2 :: 1 :: Nil, mq);
        MutPriorityQueue.toVector(mq) == Vector#{2, 1}
    }

    @Test
    def testToVector05(): Bool = region rc {
        let mq = (MutPriorityQueue.empty(rc) : MutPriorityQueue[Int32, rc]);
        MutPriorityQueue.enqueueAll(1 :: 2 :: 3 :: 4 :: 5 :: 6 :: 7 :: 8 :: Nil, mq);
        MutPriorityQueue.toVector(mq) == Vector#{8, 7, 6, 4, 3, 2, 5, 1}
    }

    @Test
    def testToVector06(): Bool = region rc {
        let mq = (MutPriorityQueue.empty(rc) : MutPriorityQueue[Int32, rc]);
        MutPriorityQueue.enqueueAll(1 :: 2 :: 3 :: 4 :: 5 :: 6 :: 7 :: 8 :: Nil, mq);
        MutPriorityQueue.dequeue(mq);
        MutPriorityQueue.dequeue(mq);
        MutPriorityQueue.toVector(mq) == Vector#{6, 4, 5, 1, 3, 2}
    }

}
