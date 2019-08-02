import simpleot/cimports
import sequtils

type
  Sender* = ref object
    data: SIMPLEOT_SENDER
  SenderMessage* = array[PACKBYTES, cuchar]

  Receiver* = ref object
    data: SIMPLEOT_RECEIVER
  ReceiverMessage* = array[4 * PACKBYTES, cuchar]

  Keys* = array[4, array[HASHBYTES, cuchar]]
  OTError* = object of CatchableError

proc newOTError: ref OTError =
  result = newException(OTError, "point decompression failed")

proc generateSecret*(sender: Sender): SenderMessage =
  sender_genS(addr sender.data, addr result[0])

proc generateSecret*(receiver: Receiver, senderMessage: SenderMessage): ReceiverMessage =
  receiver.data.S_pack = senderMessage
  let success = receiver_procS_check(addr receiver.data)
  if not success:
    raise newOTError()

  receiver_maketable(addr receiver.data)

  var cs: array[4, cuchar]
  simpleot_randombytes(addr cs[0], culonglong(sizeof(cs)))
  cs.applyIt(cuchar(uint8(it) and 1))

  receiver_rsgen(addr receiver.data, addr result[0], addr cs[0])

proc generateKeys*(sender: Sender, receiverMessage: ReceiverMessage): (Keys, Keys) =
  let success = sender_keygen_check(addr sender.data, unsafeAddr receiverMessage[0], addr result[0])
  if not success:
    raise newOTError()

proc generateKeys*(receiver: Receiver): Keys =
  receiver_keygen(addr receiver.data, addr result[0])
