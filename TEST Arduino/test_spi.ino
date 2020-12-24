#include <SPI.h>

/* PIN :
SS ou CS => 10
SCLK => 13
MOSI => 11 */

void setup() {
  pinMode(10, OUTPUT); // PIN SS
  SPI.begin();         
  Serial.begin(9600);
}

void loop() {

  digitalWrite(10, LOW);            // SS à bas

  while (1){
  for(byte Valeur = 0; Valeur <= 128; Valeur++) {

    SPI.transfer(0x00);             // On envoie à l'adresse 0x00
    SPI.transfer(Valeur);      // On envoie la valeur

    Serial.println("Envoie"); 
    delay(1000); 
  }

  }
  digitalWrite(10, HIGH);           // SS à haut
}
