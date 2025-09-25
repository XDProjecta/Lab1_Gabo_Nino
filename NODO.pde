public class Nodo {
  public int data;
  public Nodo der, izq;
  public int altura;
  public DatosPais datosPais; // Referencia a los datos del país

  public Nodo(int data, DatosPais datosPais) {
    this.data = data;
    this.datosPais = datosPais;
    this.der = null;
    this.izq = null;
    this.altura = 1;
  }
}

class DatosPais {
  int objectId;
  String country;
  String iso3;
  HashMap<Integer, Float> temperaturas;
  float mediaTemperatura;

  DatosPais(int objectId, String country, String iso3) {
    this.objectId = objectId;
    this.country = country;
    this.iso3 = iso3;
    this.temperaturas = new HashMap<Integer, Float>();
    this.mediaTemperatura = 0;
  }

  void calcularMediaTemperatura() {
    if (temperaturas.isEmpty()) {
      mediaTemperatura = 0;
      return;
    }
    
    float suma = 0;
    for (Float temp : temperaturas.values()) {
      suma += temp;
    }
    mediaTemperatura = suma / temperaturas.size();
  }
}
