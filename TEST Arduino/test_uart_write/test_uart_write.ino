int val =  0;

void setup() {
  Serial.begin(9600);
}

void loop() {
  for (val = 0; val <= 255 ; val ++) {
  Serial.write(val);
  //Serial.println(val);
  delay(250);
  }

}
