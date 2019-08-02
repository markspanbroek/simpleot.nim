import unittest
import simpleot

suite "oblivious transfer":
  var sender: Sender
  var receiver: Receiver

  setup:
    sender = Sender()
    receiver = Receiver()

  test "sender creates secret":
    var empty: SenderMessage
    check sender.generateSecret() != empty

  test "receiver creates secret":
    let senderMessage = sender.generateSecret()
    var empty: ReceiverMessage
    check receiver.generateSecret(senderMessage) != empty

  test "sender creates keys":
    let senderMessage = sender.generateSecret()
    let receiverMessage = receiver.generateSecret(senderMessage)
    var empty: (Keys, Keys)
    check sender.generateKeys(receiverMessage) != empty

  test "receiver creates keys":
    let senderMessage = sender.generateSecret()
    discard receiver.generateSecret(senderMessage)
    var empty: Keys
    check receiver.generateKeys() != empty

  test "raises error when sender message is invalid":
    var invalid: SenderMessage
    invalid[0] = '1'
    expect OTError:
      discard receiver.generateSecret(invalid)

  test "raises error when receiver message is invalid":
    discard sender.generateSecret()
    var invalid: ReceiverMessage
    invalid[0] = '1'
    expect OTError:
      discard sender.generateKeys(invalid)
