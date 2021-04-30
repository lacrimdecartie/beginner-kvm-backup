# beginner-kvm-backup
Ein Bash Skript um Backups von laufenden KVM Gast Systeme  zu ermöglichen
--------------------------------------------------------------------------------------------------------

Mit diesem Skript kann Schritt für Schritt ein Voll-Backup einer laufenden KVM VM erstellt werden. Es ist so aufgebaut, man als Beginner versteht was das Skript macht und es seinen persönlichen bedürfnissen anpassen kann. Weiter kann mit dem "Restore" Skript, die VM wiederhergestellt werden.

Voraussetzungen und Abgrenzungen:
- Die VM und die VM Datei besitzen den identischen Namen (zum Beispiel: VM Name = Test / VM Datei = Test.qcow2)
- Auf der VM wurde der QEMU Gast Agent installiert (zum Beispiel: sudo apt install qemu-guest-agent)
- Der Backupverzeichnispfad ist bekannt
- Der VM Datei Verzeichnispfad ist bekannt
