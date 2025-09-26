import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;

ArrayList<ArrayList<String>> datacsv = new ArrayList<ArrayList<String>>();
ArbolAVL arbol = null;
String input = "";
int altura = 0;
void setup() {
  size(1280, 720);
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
      for (int i = 3; i < fila.size(); i++) {
        acumulador += parseFloat(fila.get(i));
      }
      float tPromedio = acumulador / (fila.size() - 3);
      fila.add(str(tPromedio));
      datacsv.add(fila);
    }

    br.close();
  }
  catch (IOException e) {
    e.printStackTrace();
  }
  background(255);
}
void draw() {
  background(255);
  fill(0);
  textSize(25);
  text("Arboles AVL", 20, 40);

  fill(255);
  rect(110, 70, 200, 40,10);
  fill(0);
  text(input, 120, 100);
  text(input, 620, 100);
  text(input, 1120, 100);
  if (arbol != null) {
    drawArbol(arbol.raiz, width/2, 150, width/4);
    fill(0);
    textAlign(LEFT, BASELINE);
    text("Altura del arbol: " + arbol.raiz.altura, 20, height - 60);
  }
}

void drawArbol(Nodo nodo, int x, int y, int separacion) {
  if (nodo == null) return;

  nodo.x = lerp(nodo.x, x, 0.1);
  nodo.y = lerp(nodo.y, y, 0.1);

  // dibuja enlace izquierdo (si existe)
  if (nodo.nodoIzq != null) {
    // punto inicio = posición actual del padre, punto fin = posición objetivo del hijo
    float childTargetX = x - separacion;
    float childTargetY = y + 60;
    line(nodo.x, nodo.y + 10, childTargetX, childTargetY - 10);
    // dibuja recursivamente el hijo izquierdo
    drawArbol(nodo.nodoIzq, (int)childTargetX, (int)childTargetY, separacion/2);
  }

  // dibuja enlace derecho (si existe) <- aquí faltaba la línea en tu versión
  if (nodo.nodoDer != null) {
    float childTargetX = x + separacion;
    float childTargetY = y + 60;
    line(nodo.x, nodo.y + 10, childTargetX, childTargetY - 10);
    drawArbol(nodo.nodoDer, (int)childTargetX, (int)childTargetY, separacion/2);
  }

  // dibuja el nodo encima de las líneas (para que no quede tapado)
  fill(nodo.fondo);
  ellipse(nodo.x, nodo.y, 40, 40);

  // dibuja el texto centrado en la posición actual del nodo
  fill(50);
  textAlign(CENTER, CENTER);
  text(nodo.ISO3, nodo.x, nodo.y);
  textAlign(LEFT, BASELINE); // restaura si usas otro alineamiento luego
}


void mousePressed() {
}

void keyPressed() {
  //si se presionan numeros, se agregen al rectangulo

  if (key == BACKSPACE) {
    if (input.length() > 0) {
      input = input.substring(0, input.length() - 1);
    }
  } else if (key == '1') {
    if (input.length() > 0) {
      String country = input;
      float valor = 1999;
      String iso = "XXX";
      println();
      println("country:" + country + "valor: " + valor + "iso: " + iso);
      for (ArrayList<String> fila : datacsv) {
        if (fila.get(1).equalsIgnoreCase(country)) {
          println(fila.get(fila.size() -1));
          valor = parseFloat(fila.get(fila.size() - 1));
          System.out.println("Valor: " + fila.get(fila.size() - 1));
          iso = fila.get(2);
          break;
        }
      }
      Nodo nuevoNodo = new Nodo(valor, country, iso);
      if (arbol == null) {
        arbol = new ArbolAVL(nuevoNodo);
      } else {
        //metodo para insertar en el arbol
        println("hola");
        arbol.raiz =arbol.insertarNodo(arbol.raiz, iso,valor, country);
      }

      input = "";
      fill(255);
    }
  } else if (key == '=') {
    float tProm = Float.parseFloat(input);
    
    
    arbol.eliminarRaiz(tProm);
  }  else input += key;
}
