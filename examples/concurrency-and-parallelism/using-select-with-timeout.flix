use Time.Duration.fromMilliSeconds;

def sendMessage(s: Sender[String]): Unit \ {Chan, IO} =
    Thread.sleep(fromMilliSeconds(5));
    Channel.send("Hello World", s)

def recvMessage(c: Receiver[String]): String \ {Chan, NonDet, IO} =
    let t = Channel.timeout(fromMilliSeconds(1));
    select {
        case m <- recv(c) => m
        case _ <- recv(t) => "Timeout"
    }

def main(): Unit \ {Chan, NonDet, IO} =
    region rc {
        let (s, r) = Channel.buffered(1);
        spawn sendMessage(s) @ rc;
        println(recvMessage(r))
    }
