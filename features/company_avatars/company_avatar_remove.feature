#encoding: utf-8
#language: de
@browser
Funktionalität: Firmenavatar entfernen      ## these tests are intentionally written in german (for presentation purposes)
  Als ein eingeloggter User
  Bin ich berechtigt ein Firmenavatar zu entfernen

  Grundlage: Existierender User
    Angenommen es gibt einen User mit der Email "user@domain.com" und Passwort "pwd123456"
    Und es gibt Daten wie im File "customers.csv"

    Szenario:
      Wenn ich mich anmelde
      Und ich auf "Customer" klicke
      Und ich auf "All customers" klicke
      Und ich mich für den Kunden "Company A" entscheide und auf "Edit" klicke
      Und ich auf "Avatar" klicke
      Und ich auf den roten Button zum Entfernen von Avatar klicke
      Dann ist auf der Index-Seite die Icon des Kunden "Company A" verschwunden





