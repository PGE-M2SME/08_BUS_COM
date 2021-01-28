# 08_BUS_COM
Repository bus de communication

/!\ __La documentation est suception de changer au cours du travail de recherche__ /!\

La communication avec le bus de communication se décompose en 2 partie :
- Lecture du bus
- Ecriture sur le bus

## Lecture du bus de communication
### Entrées / Sorties
Pour faire la distinction entre les protocoles, les pins seront au nombre de **4** et **labélisés** :
- Clock
- Data In
- Data Out
- SS (Slave Select)

En fonction de ce qui est câblé, il est aisément possible de connaître le protocole utilisé. La démarche utilisée en VHDL est celle de ***pull down*** pour pouvoir détecter une tension lors du câblge.

![Schema Entrées/Sorties](Images/Schema_IO.PNG)

Entrées | PIN  | Description
--------|------|-------------
Clock   |      | SCLK(SPI) CLK(I2C)
Data In |      | MOSI(SPI) SDA(I2C) Rx(UART)
Data Out|      |MISO(SPI) Tx(UART)
SPI detection | | SS (SPI)

Sorties|PIN|Description
-------|---|-----------
Data bus|   |Information du bus sur 8 bits
Bus type|   |Type de bus :</br> 01 : SPI </br> 10 : I2C </br> 11 : UART

## Ecriture sur le bus de communication
Pour réaliser cette partie de façon optimisée, il faut indiquer quelles informations seront attendues. Tous les groupes du porjet attendent en réception des trames par paquet de **8 bits** (1 octet).
Voici la trame attendue pour l'écriture sur le bus :

**La trame est succeptible d'être modifiée, ce n'est pas la trame finale.**
Octet | Nom  | Description
-----|------|-------------
1|Nb_Octets|Nombre d’octets de la trame
2|ID_Sys|Système dont la commande est sollicité
3|ID_Cmd|Commande sollicité
4|Bus_type|Type de bus utilisé :</br> 0x1 : SPI </br> 0x2 : I2C </br> 0x3 : UART
5|Adresse|Adresse de l'esclave
6|Taille_mot|Taille du mot seul à transmettre en octet (hors spécification de taille ou fréquence)
7|Operateur|Nature de l'opérateur du facteur de bauds. _Exemple : 0 pour multiplication ; 1 pour division_
8|Facteur_baud|Facteur (multiple de 9 600) du baud rate de transmission. **Dans le cas où Operateur = 0, la valeur de Facteur_baud multiplie 9 600. Dans le cas où Operateur = 1, la valeur de Facteur_baud divise 9 600.** _Exemple : </br> Coef = 1; Facteur_baud = 0x20 (32) ==> Bauds = 300 </br> Coef = 0; Facteur_baud = 0x68 (104) ==> Bauds = 998 400_
9 ou plus|Mot|Mot à transmettre (dépend de Taille_mot)
