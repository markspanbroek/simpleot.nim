import nimterop/[cImport, git, paths]
import os
import strutils

const
  src = currentSourcePath.parentDir/"build"

static:
  cDisableCaching() # TODO: remove
  gitPull("https://github.com/markspanbroek/SimpleOT.git", outdir=src)

cCompile(src/"ot_sender.c")
cCompile(src/"ot_receiver.c")
cCompile(src/"ge4x*.c")
cCompile(src/"Keccak-simple.c")
cCompile(src/"gfe4x*.c")
cCompile(src/"fe25519*.c")
cCompile(src/"ge25519*.c")
cCompile(src/"sc25519*.c")
cCompile(src/"randombytes.c")

{.passC: "-c".}
cCompile(src/"*.S")

cImport(src/"sc25519.h")
cImport(src/"gfe4x.h")
cImport(src/"ge4x.h")
cImport(src/"ot_config.h")
cImport(src/"randombytes.h")
cImport(src/"ot_sender.h")

cOverride:
  # Nimterop doesn't support multidimensional arrays yet
  # https://github.com/nimterop/nimterop/issues/54
  const name = "SIMPLEOT_RECEIVER"
  const header = src/"ot_receiver.h"
  type
    SIMPLEOT_RECEIVER* {.importc: name, header: header, bycopy.} = object
      S_pack* {.importc: "S_pack".}: array[PACKBYTES, cuchar]
      S* {.importc: "S".}: ge4x
      table* {.importc: "table".}: array[64 div DIST, array[8, ge4x]]
      xB* {.importc: "xB".}: ge4x
      x* {.importc: "x".}: array[4, sc25519]
  proc sender_keygen*(a1: ptr SIMPLEOT_SENDER; a2: ptr cuchar;
      a3: ptr array[4, array[HASHBYTES, cuchar]]) {.stdcall,
      importc: "sender_keygen", header: src/"ot_sender.h".}
  proc receiver_keygen*(a1: ptr SIMPLEOT_RECEIVER; a2: ptr array[HASHBYTES, cuchar]) {.
    stdcall, importc: "receiver_keygen", header: src/"ot_receiver.h".}


cImport(src/"ot_receiver.h")