# 08_BUS_COM
Repository bus de communication

/!\ La documentation est suception de changer au cours du travail de recherche /!\

### Entrées / Sorties

![Schema Entrées/Sorties](Images/Schema_IO.png)

Entrées | PIN  | Description
--------|------|-------------
Clock   |      | SCLK(SPI) CLK(I2C)
Data In |      | MOSI(SPI) SDA(I2C) Rx(UART)
Data Out|      |MISO(SPI) Rx(UART)
SPI detection | | SS (SPI)

Sorties|PIN|Description
-------|---|-----------
Data bus|   |   Information du bus sur 8 bits
Bus type|   |Type de bus :</br> 01 : SPI </br> 10 : I2C </br> 11 : UART
