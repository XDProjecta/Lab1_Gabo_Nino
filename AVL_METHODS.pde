class ArbolAVL {
  private Nodo raiz;

  public ArbolAVL(Nodo nodo) {
    this.raiz = nodo;
  }

  /*
  1. UTILIDADES (altura, actualizar altura, balanceo.)
   */

  //tanto para la altura como para el balance, podemos hacer uso de operador ternario, debido a que usamos solo dos condiciones !!! :O
  public int altura(Nodo nodo) {
    return (nodo == null) ? 0 : nodo.altura;
  }

  public int factorBalanceo(Nodo nodo) {
    return balance(nodo);
  }

  public int balance(Nodo nodo) {
    return (nodo == null) ? 0 : altura(nodo.nodoDer) - altura(nodo.nodoIzq);
  }

  /* recordemos que la altura se actualiza cada vez que se hace un cambio estructural en el árbol.
   cuando rotemos, insertemos y borremos, toca actualizar altura */
  public void actualizarAltura(Nodo nodo) {
    if (nodo != null) {
      nodo.altura = 1 + max(altura(nodo.nodoIzq), altura(nodo.nodoDer));
    }
  }

  /*
  2. ROTATIONS
   
   Teoría de las rotaciones:
   
   3. SIMPLE LEFT: el nodo desbalanceado tiene como balance igual a 2, y el que causa dicho desbalanceo tiene balance 1.
   
   1. guardamos al desbalanceado como aux.
   2. el nuevo derecho de aux, va a ser el izquierdo del hijo derecho de aux
   3. al derecho de aux, le asignamos ahora un nuevo izquierdo, que será aux.
   
   SIMPLE RIGHT: el desbalanceado tiene como balance -2, y el que causa dicho desbalanceo tiene balance -1.
   
   1. guardamos al desbalanceado como aux.
   2. el nuevo izquierdo de aux, va a ser el derecho del hijo derecho de aux. el derecho del hijo izquierdo de aux, va a ser el nuevo izquierdo de aux. eso es lo que quiere decir.
   3. al izquierdo de aux, le asignamos ahora un nuevo derecho, que será aux
   
   DOUBLE RIGHT-LEFT: el desbalanceado tiene valor 2 y el que causa desbalanceo, balance = -1.
   
   1. se hace una rotación simple right con el derecho del desbalanceado
   2. ahoran nuestro aux será el hijo derecho de nuestro nodo desbalanceado
   3. hacemos una simple left con dicho aux.
   
   DOUBLE LEFT-RIGHT: el desbalanceado tiene valor -2 y el que causa desbalanceo, balance = 1.
   
   1. se hace una rotación simple left con el izquierdo del desbalanceado
   2. ahora nuestro aux será el hijo izquierdo de nuestro nodo desbalanceado
   3. hacemos una simple right con dicho aux. */

  /*
  bueno ya... empezar!!!
   */
  /*
pasamos de parámetro al desbalanceado, y hacemos los cambios para la nueva raiz dependiendo de la rotación.
   
   actualizamos también la altura por rotación.
   */

  /*
para evitar tener cadenas así en las variables, ombe, creamos nuevas variables con el fin de mejorar la legibilidad
   */
  public Nodo simpleLeft(Nodo aux) {
    Nodo x = aux.nodoDer;
    Nodo y = x.nodoIzq;
    aux.nodoDer = y;
    x.nodoIzq = aux;
    actualizarAltura(aux);
    actualizarAltura(x);
    return x;
  }

  public Nodo simpleRight(Nodo aux) {
    Nodo x = aux.nodoIzq;
    Nodo y = x.nodoDer;
    aux.nodoIzq = y;
    x.nodoDer = aux;
    actualizarAltura(aux);
    actualizarAltura(x);
    return x;
  }



  /*
  3. INSERCIONES
   */




  public Nodo insertarNodo(Nodo nodo, String iso3, float tPromedio, String country) {
    if (nodo == null) {
      return new Nodo(tPromedio, country, iso3 ); //no tenemos que instanciar nada, puesto que estamos retornando!! :OOO1
    }

    if (tPromedio < nodo.tPromedio) {

      nodo.nodoIzq = insertarNodo(nodo.nodoIzq, iso3, tPromedio, country);
    } else if (tPromedio > nodo.tPromedio) {

      nodo.nodoDer = insertarNodo(nodo.nodoDer, iso3, tPromedio, country);
    } else {
      return nodo; // si el valor es igual, retorna el nodo actual y ya, pa q no se rompa nada
      // no sé si se explote si no lo pongo, así que lo voy a dejar kjskajsa
    }


    //naturalmente, actualizamos la altura después de insertar, pues hicimos un cambio reestructural en el árbol.
    actualizarAltura(nodo);

    //puede que el árbol haya quedado desbalanceado tras una inserción, por lo que toca calcular el balance pa ver si se tiene que balancear o no.
    int b = balance(nodo);

    //comparamos los casos de desequilibrio
    //para todas las rotaciones, no solo comparamos b, pues necesitamos encontrar el nieto que causó el desbalance.
    // *donde cae el valor, ahí está el nieto* queremos ver si ese nieto cayó en línea recta o está cruzado

    //es útil para saber si el valor cae simple o cae doble, porque sin eso, no habría manera de diferenciar los casos

    if (b > 1 && nodo.nodoDer != null && tPromedio > nodo.nodoDer.tPromedio) { //acá nos pregunta si es derecha y si cayó RECTECITO hasta el final, es decir, si es simpleLeft
      return simpleLeft(nodo);
    }

    if (b < -1 && nodo.nodoIzq != null && tPromedio < nodo.nodoIzq.tPromedio) { //acá nos pregunta si es izquierda y si cayó RECTECITO hasta el final, es decir, si es simpleRight
      return simpleRight(nodo);
    }

    if (b > 1 && nodo.nodoDer != null && tPromedio < nodo.nodoDer.tPromedio) { //acá nos pregunta si es derecha y si cayó CRUZADO hasta el final, es decir, si es DOUBLE RIGHT-LEFT
      //hacemos una simpleRight con el derecho del desbalanceado
      nodo.nodoDer = simpleRight(nodo.nodoDer);
      //luego hacemos una simpleLeft con el nodo origen
      return simpleLeft(nodo);
    }

    if (b < -1 && nodo.nodoIzq != null && tPromedio > nodo.nodoIzq.tPromedio) { //acá nos pregunta si es izquierda y si cayó CRUZADO hasta el final, es decir, si es DOUBLE LEFT-RIGHT
      //hacemos una simpleLeft con el izquierdo del desbalanceado
      nodo.nodoIzq = simpleLeft(nodo.nodoIzq);
      //luego hacemos una simpleRight con el nodo desbalanceado
      return simpleRight(nodo);
    }

    // SI NO HUBO DESBALANCE, TERMINAMOS!!! SACA ESA MONDAAAAA
    return nodo;
  }
  
  void insertarNuevoNodo(String ISO3, String country) {
  ArrayList<String> fila;
  float tProm;


    fila = new ArrayList<String>();

    // id autoincremental 
    fila.add("99");
    fila.add(country);
    fila.add(ISO3);

    // generamos 62 valores aleatorios y su promedio
    float acum = 0.0;
    for (int i = 0; i < 62; i++) {
      float numero = random(-3, 4);
      acum += numero;
      fila.add(str(numero));
    }
    tProm = acum / 62.0;
    fila.add(str(tProm));


    datacsv.add(fila);
    this.raiz = insertarNodo(this.raiz, ISO3, tProm, country);
}


  /*
  4. ELIMINATION
   */

  //en caso de que quiera eliminar la raiz, o no sé si todo, falta probar :v
  //mentirita, esto es para no tener que siempre pasar por la raiz.
  // ELIMINACIÓN por media de temperatura
  public void eliminarRaiz(float mediaTemperatura) {
    float info = mediaTemperatura;
    raiz = eliminarNodo(raiz, info);
  }

  private Nodo eliminarNodo(Nodo nodo, float info) {
    //si el nodo es nulo, pues no hay nada que borrar
    if (nodo == null) return null;

    // vamos bajando como si fuera un ABB, es decir, recorremos el árbol hasta que el valor que queremos borrar sea igual al nodo en el que estamos
    // if(valor ==nodo.data){ sout("coronamos")}

    // Si info es menor que la data del nodo actual, se borra en el subárbol izquierdo
    if (info < nodo.tPromedio) {
      nodo.nodoIzq = eliminarNodo(nodo.nodoIzq, info);

      // Si info es mayor, se borra en el subárbol derecho
    } else if (info > nodo.tPromedio) {
      nodo.nodoDer = eliminarNodo(nodo.nodoDer, info);
    } else {
      // LA INFO ES IGUAL A LA NODO.DATA, LO ENCONTRAMOS!!


      // a partir de acá, hay varios casos dependiendo de los hijos que tenga dicho nodo a borrar

      // CASO 1) si tiene 0 hijos (hoja) O 1 hijo:
      // Si uno de los hijos es null, el resultado del borrado es el otro hijo.
      // Con esto estamoss cubriendo el caso de la hoja (ambos null, entonces => hijo = null) y nodo con un solo hijo.
      if (nodo.nodoIzq == null || nodo.nodoDer == null) {
        //usamos operador ternario con el fin de ombe, reducir código jkajskja
        // básicamente, si mi izquierdo NO es nulo, mi variable "hijo" será el izquierdo y, si es nulo, mi variable "hijo" será el nodo derecho
        Nodo hijo = (nodo.nodoIzq != null) ? nodo.nodoIzq : nodo.nodoDer;
        // entonces, "Eliminamos" el nodo actual reemplazándolo por su hijo (puede ser null en caso de ser hoja).
        nodo = hijo;
      } else {
        // CASO 2) 2 hijos (izq y der NO son null):
        // Lo que hacemos, es buscar el más pequeño del subárbol derecho por medio del inorden.
        //  quiere decir que vamos a buscar el que esté "más a la izquierda" dentro del subárbol derecho del nodo que vamos a eliminar.
        //PRIMERO: BUSCAMOS A DICHO COLE, A ESE "SUCESOR" en el subárbol derecho:
        Nodo sucesor = minNodo(nodo.nodoDer);
        //cambio el valor del nodo a borrar por el del sucesor, BORRANDO DICHO VALOR, POR LO QUE "BORRAMOS" EL NODO.
        nodo.tPromedio = sucesor.tPromedio;
        nodo.ISO3 = sucesor.ISO3;
        nodo.country = sucesor.country;
        /*Como no podemos tener valores repetidos, borramos al sucesor, el cual claro,
         al ser el que más a la izquierda está en el subárbol derecho, no tiene
         ningún nodo izquierdo, por lo que cae en el CASO 1) 0 o 1 hijo.
         */
        nodo.nodoDer = eliminarNodo(nodo.nodoDer, sucesor.tPromedio);
      }
    }

    // Si tras el borrado, este subárbol quedó vacío (nodo == null), ya no hay que ni actualizar alturas ni balancear
    if (nodo == null) return null;

    /*en caso de que no haya quedado vacío:
     // 3) ACTUALIZAMOS LA ALTURA del nodo actual (porque cambió su estructura, claro)
     recordemos que la altura(null)=0 y las hojas quedan con altura=1. */
    actualizarAltura(nodo);

    // 4) rebalanceamos
    int b = balance(nodo);

    // RE-BALANCEO EN ELIMINACIÓN
    // en eliminación NO tenemos "el último valor insertado" para decidir simple/doble.
    // Aquí miramos el balance del hijo correspondiente para saber si la rotación es simple o doble (ombe, como en el parcial)

    // Si está DESBALANCEADO a la DERECHA (b > 1):
    if (b > 1) {
      // Miramos el balance del hijo derecho:
      // Si balance(der) >= 0 significa que el hijo derecho NO está cargado a la izquierda
      // entonces es una SIMPLE LEFT
      if (balance(nodo.nodoDer) >= 0) {
        return simpleLeft(nodo);
      } else {
        // Si balance(der) < 0 significa que el hijo derecho está cargado a la izquierda
        // entonces es una DOUBLE RIGHT LEFT: primero RIGHT sobre el hijo, luego LEFT sobre el nodo.
        nodo.nodoDer = simpleRight(nodo.nodoDer);
        return simpleLeft(nodo);
      }
    }

    // Caso DESBALANCEADO a la IZQUIERDA (b < -1):
    if (b < -1) {
      // Miramos el balance del hijo izquierdo:
      // Si balance(izq) <= 0 el hijo izquierdo NO está cargado a la derecha
      // entonces es una SIMPLE RIGHT.
      if (balance(nodo.nodoIzq) <= 0) {
        return simpleRight(nodo);
      } else {
        // Si balance(izq) > 0 el hijo izquierdo sí está cargado a la derecha
        // entonces es una DOUBLE LEFT-RIGHT: primero LEFT sobre el hijo, luego RIGHT sobre el nodo.
        nodo.nodoIzq = simpleLeft(nodo.nodoIzq);
        return simpleRight(nodo);
      }
    }

    // Si el balance quedó en el rango adecuado {-1, 0, 1}, coronamos, no hay rotaciones ni cambios por hacer!!!
    return nodo;
  }

  //esta es la función que utilizamos para buscar al "SUCESOR" del subárbol derecho.
  // Devuelve el nodo con el valor mínimo en el subárbol cuya raíz es "nodo".
  // como ya dijimos, lo que hace esto es simplemente encontrar el SUCESOR por medio del inorden (mínimo del derecho).

  private Nodo minNodo(Nodo nodo) {
    //creamos una variable aux de tipo nodo para recorrer el subárbol derecho. empezamos desde la raíz de dicho subárbol, que es "nodo"
    Nodo aux = nodo;
    /* hasta que no hayamos encontrado el más izquierdo de los izquierdos (:V)
     no vamos a dejar de cambiar a aux por valores más pequeños que él, es decir, por izquierdos "más izquierdos" a aux kjsajsak
     todo esto con el fin de encontrar el más chiquito en el subárbol derecho del nodo a eliminar.
     */
    while (aux != null && aux.nodoIzq != null) {
      aux = aux.nodoIzq;
    }
    return aux;
  }


  // 3. BUSCAR NODO por métrica (media temperatura)
  public Nodo buscarNodo(float mediaTemperatura) {
    float info = mediaTemperatura;
    return buscarNodoRec(raiz, info);
  }

  private Nodo buscarNodoRec(Nodo nodo, float info) {
    if (nodo == null || nodo.tPromedio == info) {
      return nodo;
    }

    if (info < nodo.tPromedio) {
      return buscarNodoRec(nodo.nodoIzq, info);
    } else {
      return buscarNodoRec(nodo.nodoDer, info);
    }
  }

  // 4. BUSCAR POR CRITERIOS
  public ArrayList<Nodo> buscarPorCriterio(String criterio, int año, float valor) {
    ArrayList<Nodo> resultados = new ArrayList<Nodo>();

    switch(criterio) {
    case "a": // Mayor al promedio en año dado
      float promedioAnual = calcularPromedioAnual(año);
      buscarCriterioA(raiz, año, promedioAnual, resultados);
      break;
    case "b": // Menor al promedio global
      float promedioGlobal = calcularPromedioGlobal();
      buscarCriterioB(raiz, promedioGlobal, resultados);
      break;
    case "c": // Media mayor o igual a valor
      buscarCriterioC(raiz, valor, resultados);
      break;
    }

    return resultados;
  }

  private void buscarCriterioA(Nodo nodo, int año, float promedioAnual, ArrayList<Nodo> resultados) {
    if (nodo == null) return;

    buscarCriterioA(nodo.nodoIzq, año, promedioAnual, resultados);  


    for (ArrayList<String> linea : datacsv) {
      if (Float.parseFloat(linea.get(año-1961 + 2)) > promedioAnual && linea.get(2).equals(nodo.ISO3)) {
        resultados.add(nodo);
      }
    }

    buscarCriterioA(nodo.nodoDer, año, promedioAnual, resultados);
  }

  private void buscarCriterioB(Nodo nodo, float promedioGlobal, ArrayList<Nodo> resultados) {
    if (nodo == null) return;

    buscarCriterioB(nodo.nodoIzq, promedioGlobal, resultados);

    if (nodo.tPromedio < promedioGlobal) {
      resultados.add(nodo);
    }

    buscarCriterioB(nodo.nodoDer, promedioGlobal, resultados);
  }

  private void buscarCriterioC(Nodo nodo, float valor, ArrayList<Nodo> resultados) {
    if (nodo == null) return;

    buscarCriterioC(nodo.nodoIzq, valor, resultados);

    if (nodo.tPromedio >= valor) {
      resultados.add(nodo);
    }

    buscarCriterioC(nodo.nodoDer, valor, resultados);
  }



  // 5. RECORRIDO POR NIVELES (recursivo)
  public ArrayList<String> recorridoPorNiveles() {
    ArrayList<String> resultado = new ArrayList<String>();
    if (raiz == null) return resultado;

    ArrayList<Nodo> cola = new ArrayList<Nodo>();
    cola.add(raiz);

    recorridoPorNivelesRec(cola, resultado);
    return resultado;
  }

  private void recorridoPorNivelesRec(ArrayList<Nodo> cola, ArrayList<String> resultado) {
    if (cola.isEmpty()) return;

    Nodo actual = cola.remove(0);
    resultado.add(actual.ISO3);

    if (actual.nodoIzq != null) cola.add(actual.nodoIzq);
    if (actual.nodoDer != null) cola.add(actual.nodoDer);

    recorridoPorNivelesRec(cola, resultado);
  }

  /*
  5. Obtener info nodo
   */

  public int obtenerNivel(Nodo nodo) {
    return obtenerNivelRec(raiz, nodo, 1);
  }

  private int obtenerNivelRec(Nodo actual, Nodo buscado, int nivel) {
    if (actual == null) return -1;
    if (actual == buscado) return nivel;

    int nivelIzq = obtenerNivelRec(actual.nodoIzq, buscado, nivel + 1);
    if (nivelIzq != -1) return nivelIzq;

    return obtenerNivelRec(actual.nodoDer, buscado, nivel + 1);
  }



  public Nodo obtenerPadre(Nodo hijo) {
    return obtenerPadreRec(raiz, hijo);
  }

  private Nodo obtenerPadreRec(Nodo actual, Nodo hijo) {
    if (actual == null || actual == hijo) return null;
    if (actual.nodoIzq == hijo || actual.nodoDer == hijo) return actual;

    Nodo padreIzq = obtenerPadreRec(actual.nodoIzq, hijo);
    if (padreIzq != null) return padreIzq;

    return obtenerPadreRec(actual.nodoDer, hijo);
  }

  public Nodo obtenerAbuelo(Nodo nodo) {
    Nodo padre = obtenerPadre(nodo);
    return (padre != null) ? obtenerPadre(padre) : null;
  }

  public Nodo obtenerTio(Nodo nodo) {
    Nodo padre = obtenerPadre(nodo);
    if (padre == null) return null;

    Nodo abuelo = obtenerPadre(padre);
    if (abuelo == null) return null;

    return (abuelo.nodoIzq == padre) ? abuelo.nodoDer : abuelo.nodoIzq;
  }


  /*
  6. Calcular promedios
   */

  private float calcularPromedioAnual(int año) {
    float suma = 0;
    int contador = 0;
    for (ArrayList<String> linea : datacsv) {
      float temp = Float.parseFloat(linea.get(año-1961 + 2));
      suma += temp;
      contador ++;
    }

    return contador > 0 ? suma / contador : 0;
  }

  private float calcularPromedioGlobal() {
    float suma = 0;
    for (ArrayList<String> linea : datacsv) {
      suma += Float.parseFloat(linea.get(linea.size()-1));
    }

    return datacsv.size() > 0 ? suma / datacsv.size() : 0;
  }

  /*
  7. Orden
   */

  void preorden(Nodo nodo) {
    if (nodo!=null) {
      System.out.println(nodo.ISO3);
      preorden(nodo.nodoIzq);
      preorden(nodo.nodoDer);
    } else {
      return;
    }
  }

  void inorden(Nodo nodo) {
    if (nodo!=null) {

      inorden(nodo.nodoIzq);
      System.out.println(nodo.ISO3);
      inorden(nodo.nodoDer);
    } else {
      return;
    }
  }

  void postorden(Nodo nodo) {
    if (nodo!=null) {

      postorden(nodo.nodoIzq);
      postorden(nodo.nodoDer);
      System.out.println(nodo.ISO3);
    } else {
      return;
    }
  }
  
  
}
