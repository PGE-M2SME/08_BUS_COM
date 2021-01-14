#include <Wire.h>

void setup()
{
  Wire.begin(); // join i2c bus (address optional for master)
  Serial.begin(9600); 
}

byte x = 0;

void loop()
{
  Wire.beginTransmission(0); // transmit to device #4
  Wire.write("x is ");        // sends five bytes
  Wire.write(x);              // sends one byte  
  Wire.endTransmission();    // stop transmitting
  Serial.print("On envoie : ");
  Serial.print(x);
  Serial.print("\n");
  x++;
  delay(2000);
}
