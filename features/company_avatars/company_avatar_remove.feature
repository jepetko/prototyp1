#encoding: utf-8
#language: de
@browser
Funktionalität: Firmenavatar entfernen      ## these tests are intentionally written in german (for presentation purposes)
  Als ein eingeloggter User
  Bin ich berechtigt ein Firmenavatar zu entfernen

  Grundlage: Existierender User
    Angenommen es gibt einen User mit der Email "user@domain.com" und Passwort "pwd123456"
    Und es gibt Daten wie im Bereich Beispiele beschrieben

    Szenariogrundriss:
      Wenn ich mich anmelde
      Und ich auf "Kunde" klicke
      Und ich auf "Alle Kunden" klicke
      Und ich mich für den Kunden mit dem Name <name> entscheide und auf "Bearbeiten" klicke
      Und ich auf den roten Button zum Entfernen von Avatar klicke
      Dann ist die Icon verschwunden
      Und bei F5 scheint die Icon auch nicht mehr auf

      Beispiele:
      | name          |
      | Company       |





