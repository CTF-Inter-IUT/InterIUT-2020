```
>_ tshark -r  ping_pong.pcapng -T fields -e data -Y "ip.dst == 10.5.0.3" | xxd -r -p
```
