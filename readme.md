# SimpleOT for Nim

Allows the [SimpleOT][1] library to be used in [Nim][2].

Generate a sender secret:

```nim
import simpleot

let sender = Sender()
let senderSecret = sender.generateSecret()
```

Generate a receiver secret:

```nim
let receiver = Receiver()
let receiverSecret = receiver.generateSecret(senderSecret)
```

Generate sender keys:

```nim
let senderKeys = sender.generateKeys(receiverSecret)
```

Generate receiver keys:

```nim
let receiverKeys = receiver.generateKeys()
```

[1]: https://github.com/mkskeller/SimpleOT
[2]: https://nim-lang.org
