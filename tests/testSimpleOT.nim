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
    check receiver.generateSecret(senderMessage).message != empty

  test "receiver creates random choice bits":
    let senderMessage = sender.generateSecret()
    var bits1, bits2: ChoiceBits
    var tries = 10
    while bits1 == bits2 and tries > 0:
      bits1 = receiver.generateSecret(senderMessage).bits
      bits2 = receiver.generateSecret(senderMessage).bits
      dec tries
    check bits1 != bits2

  test "sender creates keys":
    let senderMessage = sender.generateSecret()
    let (_, receiverMessage) = receiver.generateSecret(senderMessage)
    var empty: (array[4, Key], array[4, Key])
    check sender.generateKeys(receiverMessage) != empty

  test "receiver creates keys":
    let senderMessage = sender.generateSecret()
    discard receiver.generateSecret(senderMessage)
    var empty: array[4, Key]
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
