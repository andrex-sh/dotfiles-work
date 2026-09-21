#!/bin/sh
# udev rules for QMK/Vial keyboards. These go to /etc, not $HOME, so chezmoi
# can't track them as files. run_onchange_: editing a rule below re-runs this.
set -eu

sudo tee /etc/udev/rules.d/50-qmk.rules >/dev/null <<'EOF'
SUBSYSTEM=="hidraw", TAG+="uaccess"
EOF

sudo tee /etc/udev/rules.d/99-vial.rules >/dev/null <<'EOF'
# Vial - grant the logged-in user access to Vial-enabled keyboards
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="plugdev", TAG+="uaccess"
EOF

sudo udevadm control --reload-rules
sudo udevadm trigger --action=add --subsystem-match=hidraw
