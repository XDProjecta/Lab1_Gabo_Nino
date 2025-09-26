class Nodo {
  String country;
  String ISO3;
  float tPromedio;
  Nodo nodoIzq, nodoDer;
  color fondo;
  int altura;
  float x, y;

  Nodo(float tPromedio, String country, String ISO3) {
    this.tPromedio = tPromedio;
    this.fondo = color(200);
    this.country = country;
    this.ISO3 = ISO3;
    this.altura = 1;
    this.x = width/2;
    this.y = 150;
  }

  void setColor (color fondo) {
    this.fondo = fondo;
  }
}
