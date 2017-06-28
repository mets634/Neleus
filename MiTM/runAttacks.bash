

#! bin/bash

bash dnsSpoof.bash
bash host.sh
python MitMAttack/FileSniffer.py
python MitmAttack/RedirectAdd.py
