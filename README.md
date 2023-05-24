# RevShells
This repo is my own personal set of reverse/bind shells, because I get tired of using plain shells and shells that don't work

## Powershell
These are powershell shells...

For TCPReverseSSL-Reflective, if the embedded DLL doesnt work, recompile the SSC project with whatever changes you need, and then use the following command to update the base64 DLL

```powershell
[Convert]::ToBase64String((Get-Content SSC.dll -Encoding Byte -Raw))
```
