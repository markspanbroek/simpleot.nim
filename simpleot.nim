import simpleot/cimports
import sequtils

type
  Sender* = ref object
    data: SIMPLEOT_SENDER
  SenderMessage* = array[PACKBYTES, cuchar]

  Receiver* = ref object
    data: SIMPLEOT_RECEIVER
  ReceiverMessage* = array[4 * PACKBYTES, cuchar]
  ChoiceBits* = array[4, cuchar]

  Key* = array[HASHBYTES, cuchar]
  OTError* = object of CatchableError

proc newOTError: ref OTError =
  result = newException(OTError, "point decompression failed")

proc generateSecret*(sender: Sender): SenderMessage =
  sender_genS(addr sender.data, addr result[0])

proc generateChoiceBits*: ChoiceBits =
  simpleot_randombytes(addr result[0], culonglong(sizeof(result)))
  result.applyIt(cuchar(uint8(it) and 1))

proc generateSecret*(receiver: Receiver,
                     senderMessage: SenderMessage,
                     choiceBits: ChoiceBits):
                     ReceiverMessage =
  receiver.data.S_pack = senderMessage
  let success = receiver_procS_check(addr receiver.data)
  if not success:
    raise newOTError()

  receiver_maketable(addr receiver.data)

  var bits = choiceBits
  receiver_rsgen(addr receiver.data, addr result[0], addr bits[0])

proc generateKeys*(sender: Sender,
                   receiverMessage: ReceiverMessage):
                   (array[4, Key], array[4, Key]) =
  let success = sender_keygen_check(addr sender.data,
                                    unsafeAddr receiverMessage[0],
                                    addr result[0])
  if not success:
    raise newOTError()

proc generateKeys*(receiver: Receiver): array[4, Key] =
  receiver_keygen(addr receiver.data, addr result[0])
