import unittest
import simpleot

suite "oblivious transfer":
  var sender: Sender
  var receiver: Receiver

  setup:
    sender = Sender()
    receiver = Receiver()

  test "sender creates secret":
    var empty: SenderSecret
    check sender.generateSecret() != empty

  test "receiver creates secret":
    let senderSecret = sender.generateSecret()
    var empty: ReceiverSecret
    check receiver.generateSecret(senderSecret) != empty

  test "sender creates keys":
    let senderSecret = sender.generateSecret()
    let receiverSecret = receiver.generateSecret(senderSecret)
    var empty: SenderKeys
    check sender.generateKeys(receiverSecret) != empty

  test "receiver creates keys":
    let senderSecret = sender.generateSecret()
    discard receiver.generateSecret(senderSecret)
    var empty: ReceiverKeys
    check receiver.generateKeys() != empty

  test "raises error when sender secret is invalid":
    var invalid: SenderSecret
    invalid[0] = '1'
    expect OTError:
      discard receiver.generateSecret(invalid)

  test "raises error when receiver secret is invalid":
    discard sender.generateSecret()
    var invalid: ReceiverSecret
    invalid[0] = '1'
    expect OTError:
      discard sender.generateKeys(invalid)
