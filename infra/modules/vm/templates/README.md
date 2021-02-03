# Templates VMWare

VMWare template which must be built using [packer](https://www.packer.io/).
A connection to VCenter is required to build these templates.
The resulting template will be saved into the vcenter host.

**Note: The ubuntu template isn't working right now.**

To build a template :
```bash
packer build alpine
```
The resulting template will be saved on the targeted esxi