# Package

version       = "0.1.0"
author        = "Mark Spanbroek"
description   = "Simple OT wrapper"
license       = "MIT"

# Dependencies

requires "nim >= 0.20.0"
requires "nimgen >= 0.4.0"

task installNimgen, "install nimgen":
  if findExe("nimgen") == "":
    exec "nimble install nimgen -y"

task runNimgen, "wrap C library":
  exec "nimgen simpleot.cfg"

before install:
  installNimgenTask()
  runNimgenTask()
