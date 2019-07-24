import unittest
import simpleot
import sequtils

test "can do oblivious transfer between sender and receiver":
  var sender: SIMPLEOT_SENDER
  var receiver: SIMPLEOT_RECEIVER

  sender_genS(addr sender, addr receiver.S_pack[0])  
  receiver_procS(addr receiver)
  receiver_maketable(addr receiver)

  var cs: array[4, cuchar]
  simpleot_randombytes(addr cs[0], culonglong(sizeof(cs)))
  cs.applyIt(cuchar(uint8(it) and 1))

  var Rs_pack: array[4 * PACKBYTES, cuchar]
  receiver_rsgen(addr receiver, addr Rs_pack[0], addr cs[0])

  var senderKeys: array[2, array[4, array[HASHBYTES, cuchar]]]
  sender_keygen(addr sender, addr Rs_pack[0], addr senderKeys[0])
  
  var receiverKeys: array[4, array[HASHBYTES, cuchar]]
  receiver_keygen(addr receiver, addr receiverKeys[0])
