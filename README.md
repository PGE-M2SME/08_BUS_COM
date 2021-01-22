# 08_BUS_COM
Repository bus de communication

/!\ La documentation est suception de changer au cours du travail de recherche /!\

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
