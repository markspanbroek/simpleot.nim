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

    test "generates random choice bits":
      var bits1, bits2: ChoiceBits
      var tries = 10
      while bits1 == bits2 and tries > 0:
        bits1 = generateChoiceBits()
        bits2 = generateChoiceBits()
        dec tries
      check bits1 != bits2

    test "receiver creates secret":
      let senderMessage = sender.generateSecret()
      let bits = generateChoiceBits()
      var empty: ReceiverMessage
      check receiver.generateSecret(senderMessage, bits) != empty

  test "sender creates keys":
    let senderMessage = sender.generateSecret()
    let bits = generateChoiceBits()
    let receiverMessage = receiver.generateSecret(senderMessage, bits)
    var empty: (array[4, Key], array[4, Key])
    check sender.generateKeys(receiverMessage) != empty

  test "receiver creates keys":
    let senderMessage = sender.generateSecret()
    let bits = generateChoiceBits()
    discard receiver.generateSecret(senderMessage, bits)
    var empty: array[4, Key]
    check receiver.generateKeys() != empty

  test "raises error when sender message is invalid":
    var invalid: SenderMessage
    invalid[0] = '1'
    let bits = generateChoiceBits()
    expect OTError:
      discard receiver.generateSecret(invalid, bits)

  test "raises error when receiver message is invalid":
    discard sender.generateSecret()
    var invalid: ReceiverMessage
    invalid[0] = '1'
    expect OTError:
      discard sender.generateKeys(invalid)
