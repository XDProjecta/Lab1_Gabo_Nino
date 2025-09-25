import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;

ArrayList<ArrayList<String>> datacsv = new ArrayList<ArrayList<String>>();
ArbolAVL arbol; 
String input = "";
int altura = 0;
void setup(){
    size(720,480);
    String ruta = sketchPath("dataset_climate_change.csv");
    try {
    BufferedReader br = new BufferedReader(new FileReader(ruta));
    String linea;
    
    while ((linea = br.readLine()) != null) {
      String[] valores = linea.split(",");
      ArrayList<String> fila = new ArrayList<String>();
      for (String valor : valores) {
        fila.add(valor);
      }
      float acumulador = 0;
      for(int i = 3; i < fila.size(); i++){
        acumulador += parseFloat(fila.get(i));
        
      }
      float tPromedio = acumulador / (fila.size() - 3);
      fila.add(str(tPromedio));
      datacsv.add(fila);
    }

    br.close();
  } catch (IOException e) {
    e.printStackTrace();
  }
    background(255);
}
void draw(){
    background(255);
    fill(150);
    circle(360,100,50);
}
