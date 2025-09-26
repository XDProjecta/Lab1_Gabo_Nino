import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;

ArrayList<ArrayList<String>> datacsv = new ArrayList<ArrayList<String>>();
ArbolAVL arbol = null;
Nodo nodoE = null;
// ahora tenemos 3 inputs (uno por cada rect)
String[] inputs = new String[3];
boolean[] textfieldActive = new boolean[3];

void setup() {
  size(1280, 720);

  // inicializar inputs
  for (int i = 0; i < inputs.length; i++) inputs[i] = "";

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
  text("Arboles AVL", 10, 20);

  // rects: (x,y,w,h)
  int[] rx = {110, 510, 910};
  int ry = 70;
  int rw = 200;
  int rh = 40;

  for (int i = 0; i < 3; i++) {
    // borde distinto si está activo
    if (textfieldActive[i]) {
      stroke(0, 100, 255);
      strokeWeight(3);
    } else {
      stroke(180);
      strokeWeight(1);
    }
    fill(255);
    rect(rx[i], ry, rw, rh, 10);

    // texto dentro
    fill(0);
    textSize(20);
    textAlign(LEFT, CENTER);
    text(inputs[i], rx[i] + 10, ry + rh/2);
  }
  text("Insertar", rx[0]+10, ry - 15);
  text("Eliminar", rx[1]+10, ry - 15);
  text("Buscar", rx[2]+10, ry - 15);
  // restaurar
  textAlign(LEFT, BASELINE);
  strokeWeight(1);
  noFill();
  stroke(180);

  if (arbol != null && arbol.raiz != null) {
    drawArbol(arbol.raiz, width/2, 150, width/4);
    fill(0);
    textAlign(LEFT, BASELINE);
    text("Altura del arbol: " + arbol.raiz.altura, 20, height - 60);
  } else {
    fill(0);
    textAlign(LEFT, BASELINE);
    text("Altura del arbol: 0", 20, height - 60);
  }
  
  fill(0, 100, 255);
  rect(width-190,height-80,180,60,10);
  fill(255);
  text("Busqueda avanzada", width-185, height - 45);
}

void drawArbol(Nodo nodo, int x, int y, int separacion) {
  if (nodo == null) return;

  nodo.x = lerp(nodo.x, x, 0.1);
  nodo.y = lerp(nodo.y, y, 0.1);

  if (nodo.nodoIzq != null) {
    float childTargetX = x - separacion;
    float childTargetY = y + 60;
    line(nodo.x, nodo.y + 10, childTargetX, childTargetY - 10);
    drawArbol(nodo.nodoIzq, (int)childTargetX, (int)childTargetY, separacion/2);
  }

  if (nodo.nodoDer != null) {
    float childTargetX = x + separacion;
    float childTargetY = y + 60;
    line(nodo.x, nodo.y + 10, childTargetX, childTargetY - 10);
    drawArbol(nodo.nodoDer, (int)childTargetX, (int)childTargetY, separacion/2);
  }

  fill(nodo.fondo);
  ellipse(nodo.x, nodo.y, 40, 40);

  fill(50);
  textAlign(CENTER, CENTER);
  text(nodo.ISO3, nodo.x, nodo.y);
  textAlign(LEFT, BASELINE);
}

void mousePressed() {
  // comprobar si clickeó dentro de alguno de los 3 rects
  int[] rx = {110, 510, 910};
  int ry = 70;
  int rw = 200;
  int rh = 40;

  boolean anyActivated = false;
  for (int i = 0; i < 3; i++) {
    if (mouseX >= rx[i] && mouseX <= rx[i] + rw && mouseY >= ry && mouseY <= ry + rh) {
      // activar solo este
      for (int j = 0; j < 3; j++) textfieldActive[j] = false;
      textfieldActive[i] = true;
      anyActivated = true;
      break;
    }
  }
  // si clickeó fuera de los rect, desactivar todos
  if (!anyActivated) {
    for (int j = 0; j < 3; j++) textfieldActive[j] = false;
  }
}

void keyPressed() {
  // determinar índice del textfield activo (-1 si ninguno)
  int activeIndex = -1;
  for (int i = 0; i < 3; i++) if (textfieldActive[i]) {
    activeIndex = i;
    break;
  }

  // Si BACKSPACE y hay uno activo -> borrar del input activo
  if (key == BACKSPACE) {
    if (activeIndex != -1 && inputs[activeIndex].length() > 0) {
      inputs[activeIndex] = inputs[activeIndex].substring(0, inputs[activeIndex].length() - 1);
    }
    return;
  }

  // si se presiona '1' (tu lógica original): se usará el texto del campo activo (si existe)
  if (key == ENTER && textfieldActive[0]) {
    String iso = (activeIndex != -1) ? inputs[activeIndex] : inputs[0];
    float valor = 0.0;
    String country = "";
    if (iso.length() > 0) {
      println();
      println( "iso: " + iso);
      for (ArrayList<String> fila : datacsv) {
        if (fila.get(2).equalsIgnoreCase(iso)) {
          println(fila.get(fila.size() -1));
          valor = parseFloat(fila.get(fila.size() - 1));
          System.out.println("Valor: " + fila.get(fila.size() - 1));
          country = fila.get(1);
          break;
        }
      }
      Nodo nuevoNodo = new Nodo(valor, country, iso);
      if (arbol == null) {
        arbol = new ArbolAVL(nuevoNodo);
      } else {
        println("hola");
        arbol.raiz = arbol.insertarNodo(arbol.raiz, iso, valor, country);
      }
      // limpiar el campo activo (si quieres dejarlo vacío)
      if (activeIndex != -1) inputs[activeIndex] = "";
    }
    return;
  }

  // si '=' -> parsear input activo como float y eliminar la raíz (como hacías)
  if (key == ENTER && textfieldActive[1]) {
    String texto = (activeIndex != -1) ? inputs[activeIndex] : inputs[0];
    try {
      float tProm = Float.parseFloat(texto);
      if (arbol != null) arbol.eliminarRaiz(tProm);
      // limpiar campo activo
      if (activeIndex != -1) inputs[activeIndex] = "";
    }
    catch (Exception e) {
      println("No es un número válido: " + texto);
    }
    return;
  }
  if (key == ENTER && textfieldActive[2]) {
    String texto = (activeIndex != -1) ? inputs[activeIndex] : inputs[0];
    try {
      float tProm = Float.parseFloat(texto);
      if (nodoE != null) nodoE.fondo = color(200);
      if (arbol != null)nodoE = arbol.buscarNodo(tProm);
      
      nodoE.fondo = color(255, 122, 122);
      // limpiar campo activo
      if (activeIndex != -1) inputs[activeIndex] = "";
    }
    catch (Exception e) {
      println("No es un número válido: " + texto);
    }
    return;
  }

  // si no es control y hay un textfield activo, agregar el caracter
  // evitar teclas como SHIFT, ALT, CONTROL, ENTER
  if (activeIndex != -1) {
    if (key >= 32) { // caracteres imprimibles
      inputs[activeIndex] += key;
    }
  }
}
