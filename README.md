# tcadmin
TrinityCore Administrative Command Line Tool

This script requires that you have the worldserver SOAP RPC API enabled, and that you have the `curl` and `xml2` commands available. There is an optional dependency upon the `mysql` client.

```
nicolaw@qp:~$ tcadmin lookup item Shadowmourn
50815 - Shadowmourne Monster Offhand
49623 - Shadowmourne

nicolaw@qp:~$ tcadmin my_silly_invalid_command
/SOAP-ENV:Envelope/SOAP-ENV:Body/ns1:executeCommandResponse/result=There is no such command
nicolaw@qp:~$ tcadmin --version
tcadmin v1.0
nicolaw@qp:~$
```

See also: https://nicolaw.uk/tcadmin

