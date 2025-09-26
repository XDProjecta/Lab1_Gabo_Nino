import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;

ArrayList<ArrayList<String>> datacsv = new ArrayList<ArrayList<String>>();
ArbolAVL arbol = null;
Nodo nodoE = null;
// ahora tenemos 5 inputs (3 originales + 2 nuevos: año y valor)
String[] inputs = new String[5];
boolean[] textfieldActive = new boolean[5];

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

  // rects: (x,y,w,h) - los 3 campos superiores
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

  // botón grande de "Busqueda avanzada"
  float botonX = width - 190;
  float botonY = height - 80;
  float botonW = 180;
  float botonH = 60;
  fill(0, 100, 255);
  rect(botonX, botonY, botonW, botonH, 10);
  fill(255);
  textAlign(LEFT, CENTER);
  text("Busqueda avanzada", botonX + 5, botonY + botonH/2);

  // nuevos textfields (índices 3 = año, 4 = valor) a la izquierda del botón
  float tfW = 90;
  float tfH = 30;
  float spacing = 10;
  // colocamos año y valor horizontalmente a la izquierda del botón
  float tf2_x = botonX - spacing - tfW;       // campo "Valor"
  float tf1_x = tf2_x - spacing - tfW;        // campo "Año"
  float tf_y = botonY + (botonH - tfH) / 2;   // centrado verticalmente con el botón

  // dibujar campo Año (index 3)
  if (textfieldActive[3]) {
    stroke(0, 100, 255);
    strokeWeight(3);
  } else {
    stroke(180);
    strokeWeight(1);
  }
  fill(255);
  rect(tf1_x, tf_y, tfW, tfH, 6);
  fill(0);
  textSize(14);
  textAlign(LEFT, CENTER);
  text(inputs[3], tf1_x + 6, tf_y + tfH/2);
  // etiqueta
  fill(0);
  textSize(12);
  textAlign(LEFT, BOTTOM);
  text("Año/ISO", tf1_x, tf_y - 6);

  // dibujar campo Valor (index 4)
  if (textfieldActive[4]) {
    stroke(0, 100, 255);
    strokeWeight(3);
  } else {
    stroke(180);
    strokeWeight(1);
  }
  fill(255);
  rect(tf2_x, tf_y, tfW, tfH, 6);
  fill(0);
  textSize(14);
  textAlign(LEFT, CENTER);
  text(inputs[4], tf2_x + 6, tf_y + tfH/2);
  // etiqueta
  fill(0);
  textSize(12);
  textAlign(LEFT, BOTTOM);
  text("Valor/Pais", tf2_x, tf_y - 6);

  // restaurar alineamientos
  textAlign(LEFT, BASELINE);
  strokeWeight(1);
  noFill();
  stroke(180);

  fill(0, 100, 255);
  rect(botonX, botonY-80, botonW, botonH, 10);
  fill(255);
  textAlign(LEFT, CENTER);
  textSize(20);
  text("insercion Nueva", botonX + 5, botonY-80 + botonH/2);
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

// ----------------------
// Función auxiliar: devuelve el nodo cuyo círculo contiene (mx,my) o null
// ----------------------
Nodo nodoEnPosicion(Nodo nodo, int mx, int my) {
  if (nodo == null) return null;
  // radio del nodo = 20 (porque dibujas ellipse(..., 40, 40))
  float dx = mx - nodo.x;
  float dy = my - nodo.y;
  float dist = sqrt(dx*dx + dy*dy);
  if (dist <= 20) {
    return nodo;
  }
  // buscar recursivamente en hijos (si existen)
  Nodo encontrado = nodoEnPosicion(nodo.nodoIzq, mx, my);
  if (encontrado != null) return encontrado;
  return nodoEnPosicion(nodo.nodoDer, mx, my);
}
// devuelve una línea con info útil del nodo (usa datacsv para country / tProm medio calculado;
// intenta también leer tPromedio dentro del propio Nodo si ese campo existe)
String infoNodoSimple(Nodo n) {
  if (n == null) return "N/A";
  String s = "ISO3: " + n.ISO3;

  // intentar leer tPromedio dentro del Nodo (si existe) mediante reflexión
  try {
    java.lang.reflect.Field f = n.getClass().getField("tPromedio");
    Object val = f.get(n);
    s += ", tPromNodo: " + val;
  }
  catch (Exception e) {
    // no existe el campo o no se pudo leer: lo ignoramos
  }

  // buscar en datacsv country y tPromedio calculado (última columna)
  for (ArrayList<String> fila : datacsv) {
    if (fila.size() >= 3 && fila.get(2).equalsIgnoreCase(n.ISO3)) {
      String country = fila.get(1);
      String tPromCSV = fila.get(fila.size() - 1);
      s += ", Country: " + country + ", tProm(CSV): " + tPromCSV;
      break;
    }
  }
  return s;
}

// ----------------------
// Reemplaza tu mousePressed() por este (mantiene el resto de la lógica)
// ----------------------
void mousePressed() {
  // 1) Si clickeaste sobre un nodo del árbol, mostrar su info en consola y resaltarlo
  if (arbol != null && arbol.raiz != null) {
    Nodo clickeado = nodoEnPosicion(arbol.raiz, mouseX, mouseY);
    if (clickeado != null) {
      // desmarcar nodo previamente seleccionado
      if (nodoE != null) nodoE.fondo = color(200);

      // asignar nuevo seleccionado y resaltarlo
      nodoE = clickeado;
      nodoE.fondo = color(255, 122, 122);

      // imprimir datos del nodo y sus parientes
      println("=== Nodo clickeado y parentesco ===");
      println("Nodo:   " + infoNodoSimple(nodoE));

      Nodo padre = arbol.obtenerPadre(nodoE);
      println("Padre:  " + infoNodoSimple(padre));

      Nodo abuelo = arbol.obtenerAbuelo(nodoE);
      println("Abuelo: " + infoNodoSimple(abuelo));

      Nodo tio = arbol.obtenerTio(nodoE);
      println("Tío:    " + infoNodoSimple(tio));
      int nivelNodo = arbol.obtenerNivel(nodoE);
      println("Nivel:  " + nivelNodo);

      int factor = arbol.factorBalanceo(nodoE);
      println("Factor de balanceo: " + factor);
      println("===================================");
      return; // terminamos el mousePressed porque ya manejamos el clic
    }
  }


  // -------------------------
  // Resto de tu lógica existente de mousePressed:
  // (lo que ya tenías: detección de clicks sobre los 3 rects superiores,
  // campos año/valor y el botón de "Busqueda avanzada")
  // -------------------------

  int[] rx = {110, 510, 910};
  int ry = 70;
  int rw = 200;
  int rh = 40;

  boolean anyActivated = false;
  for (int i = 0; i < 3; i++) {
    if (mouseX >= rx[i] && mouseX <= rx[i] + rw && mouseY >= ry && mouseY <= ry + rh) {
      // activar solo este
      for (int j = 0; j < 5; j++) textfieldActive[j] = false;
      textfieldActive[i] = true;
      anyActivated = true;
      break;
    }
  }

  float botonX = width - 190;
  float botonY = height - 80;
  float botonW = 180;
  float botonH = 60;
  float tfW = 90;
  float tfH = 30;
  float spacing = 10;
  float tf2_x = botonX - spacing - tfW;       // campo "Valor"
  float tf1_x = tf2_x - spacing - tfW;        // campo "Año"
  float tf_y = botonY + (botonH - tfH) / 2;

  // click en Año (index 3)?
  if (!anyActivated && mouseX >= tf1_x && mouseX <= tf1_x + tfW && mouseY >= tf_y && mouseY <= tf_y + tfH) {
    for (int j = 0; j < 5; j++) textfieldActive[j] = false;
    textfieldActive[3] = true;
    anyActivated = true;
  }

  // click en Valor (index 4)?
  if (!anyActivated && mouseX >= tf2_x && mouseX <= tf2_x + tfW && mouseY >= tf_y && mouseY <= tf_y + tfH) {
    for (int j = 0; j < 5; j++) textfieldActive[j] = false;
    textfieldActive[4] = true;
    anyActivated = true;
  }

  if (!anyActivated && mouseX >= botonX && mouseX <= botonX + botonW && mouseY >= botonY && mouseY <= botonY + botonH) {
    ArrayList<Nodo> resultados;
    println("Busqueda de Criterio A");
    resultados = arbol.buscarPorCriterio("a", int(inputs[3]), float(inputs[4]));
    for (Nodo nodo : resultados) {
      print(nodo.ISO3 + "   ");
    }
    println();
    println("Busqueda de Criterio B");
    resultados = arbol.buscarPorCriterio("b", int(inputs[3]), float(inputs[4]));
    for (Nodo nodo : resultados) {
      print(nodo.ISO3 + "   ");
    }
    println();
    println("Busqueda de Criterio C");
    resultados = arbol.buscarPorCriterio("c", int(inputs[3]), float(inputs[4]));
    for (Nodo nodo : resultados) {
      print(nodo.ISO3 + "   ");
    }
    println();
    println("Recorrido por niveles");
    ArrayList<String> reco = arbol.recorridoPorNiveles();
    for (String h : reco) {
      print(h+ "    ");
    }
    println();
    anyActivated = true;
  }
  if (mouseX >=botonX && mouseY>= botonY-80 && mouseX<= botonX+botonW && mouseY <=botonY-80+ botonH) {
    String iso = inputs[3];
    String country = inputs[4];
    arbol.insertarNuevoNodo(iso, country);
  }

  // si clickeó fuera de todo, desactivar todos
  if (!anyActivated) {
    for (int j = 0; j < 5; j++) textfieldActive[j] = false;
  }
}


void keyPressed() {
  // determinar índice del textfield activo (-1 si ninguno)
  int activeIndex = -1;
  for (int i = 0; i < 5; i++) if (textfieldActive[i]) {
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

  // Comportamientos ENTER para los 3 campos de la parte superior (siguen igual)
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
      if (!country.isEmpty()) {
        Nodo nuevoNodo = new Nodo(valor, country, iso);
        if (arbol == null) {
          arbol = new ArbolAVL(nuevoNodo);
        } else {
          arbol.raiz = arbol.insertarNodo(arbol.raiz, iso, valor, country);
        }
        if (activeIndex != -1) inputs[activeIndex] = "";
      }
    }
    return;
  }

  if (key == ENTER && textfieldActive[1]) {
    String texto = (activeIndex != -1) ? inputs[activeIndex] : inputs[0];
    try {
      float tProm = Float.parseFloat(texto);
      if (arbol != null) arbol.eliminarRaiz(tProm);
      // si quedó vacío, opcional: dejar arbol = null (lo puedes manejar como quieras)
      if (arbol != null && arbol.raiz == null) arbol = null;
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
      if (arbol != null) nodoE = arbol.buscarNodo(tProm);
      if (nodoE != null) nodoE.fondo = color(255, 122, 122);
      if (activeIndex != -1) inputs[activeIndex] = "";
    }
    catch (Exception e) {
      println("No es un número válido: " + texto);
    }
    return;
  }

  // NOTA: indices 3 y 4 no tienen ENTER específico por defecto; puedes añadir lógica si quieres:
  // if (key == ENTER && textfieldActive[3]) { ... }  // año
  // if (key == ENTER && textfieldActive[4]) { ... }  // valor

  // si no es control y hay un textfield activo, agregar el caracter
  // evitar teclas como SHIFT, ALT, CONTROL, ENTER
  if (activeIndex != -1) {
    if (key >= 32) { // caracteres imprimibles
      inputs[activeIndex] += key;
    }
  }
}
