# beginner-kvm-backup
Ein Bash Skript um Backups von laufenden KVM Gast Systeme  zu ermöglichen
----------------------------------------------------------------------------------

Mit diesem Skript kann Schritt für Schritt ein Voll-Backup einer laufenden KVM VM erstellt werden. Es ist so aufgebaut, man als Beginner versteht was das Skript macht und es seinen persönlichen bedürfnissen anpassen kann. Weiter kann mit dem "Restore" Skript, die VM wiederhergestellt werden.

Voraussetzungen und Abgrenzungen:
- Die VM und die VM Datei besitzen den identischen Namen (zum Beispiel: VM Name = Test / VM Datei = Test.qcow2)
- Auf der VM wurde der QEMU Gast Agent installiert (zum Beispiel: sudo apt install qemu-guest-agent)
- Der Backupverzeichnispfad ist bekannt
- Der VM Datei Verzeichnispfad ist bekannt
----------------------------------------------------------------------------------

Für manuelle Backups kann die Datei backup.sh verwendet werden.
- sudo sh backup.ch
----------------------------------------------------------------------------------

Für den Restore kann die Datei restore.sh verwendet werden.
- sudo sh restore.sh
----------------------------------------------------------------------------------

Um Backups mit einer Zeile zu starten kann die Datei autobackup.sh verwendet werden. Hier müssen die drei Parameter (VM-Name, Backupverzeichnis, VM-Dateiverzeichnis) mit angegeben werden.
- sudo sh autobackup.sh test /media/usb/Backup /lib/libvirt/images
----------------------------------------------------------------------------------

Um Backups zu automatisieren kann die Datei autobackup.sh in Verbindung mit einem Cronjob erfolgen. Um dies als Beginner zu erreichen  müssen nachfolgende Schritte durchgeführt werden:

1. Damit das Skript automatisiert durchgeführt werden kann, muss es mit erhöhten rechten (sudo) verarbeitet werden.

- sudo su

2. um die Bearbeitung des Crontab zu erleichtern wollen wir NANO als Editor einsetzten. Hier für müssen wir als ersten die Datei .bash_profile erweitern

- nano ~/.bash_profile

3. Am Ende der Datei bitte folgendes eintragen

- export VISUAL="nano"

4. Datei speichern und schliessen

- Tastenkombination "Ctrl+X" verwenden

5. Als nächstes muss das Profil aktualisiert werden

- . ~/.bash_profile

6. Nun können wir den entsprechenden Croneintarg setzten und öffnen hierzu den Cronetab

- crontab -e

7. Die Syntax wie ein Croneintrag erstellt wird bzw. welche Möglichkeiten es gibt, kann man im Internet gut nachlesen. Für unseren Zweck erkläre ich lediglich den nachfolgenden Eintrag

- 45 00 * * * sh /home/meinbenutzer/scripts/autobackup.sh test /media/usb/Backup /lib/libvirt/images

Erklärung:
- 45 00 steht für die Uhrzeit und somit für 00:45Uhr
- Die drei * stehen für Tag im Monat (1-31) / Monat (1-12) / Tag in der Woche (1-7)
- sh steht für den Befehl ein Bash Skript auszuführen
- /home/meinbenutzer/scripts/autobackup.sh steht für den Verzeichnispfad und der Skriptdatei
- test steht für den VM-Namen
- /media/usb/Backup steht für das Verzeichnis an dem das Backup erstellt werden soll
- /lib/libvirt/images steht für das Verzeichnis an dem sich die VM-Datei befindet

8. Datei speichern und schliessen

- Tastenkombination "Ctrl+X" verwenden

9. Prüfen ob Backup erstellt wurde

- Wenn alles gut gelaufen ist solltet Ihr im Backupverzeichnis zwei Dateien beseitzten. Zum einen die test.qcow2 und zum anderen die test.xml.

10. fertig



