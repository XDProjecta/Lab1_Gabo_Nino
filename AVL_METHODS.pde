class ArbolAVL {
  private Nodo raiz;

  ArbolAVL() {
    this.raiz = null;
  }


  /*
  1. UTILIDADES (altura, actualizar altura, balanceo.)
   */

  //tanto para la altura como para el balance, podemos hacer uso de operador ternario, debido a que usamos solo dos condiciones !!! :O
  public int altura(Nodo n) {
    return (n == null) ? 0 : n.altura;
  }

  public int balance(Nodo nodo) {
    return (nodo == null) ? 0 : altura(nodo.der) - altura(nodo.izq);
  }

  /* recordemos que la altura se actualiza cada vez que se hace un cambio estructural en el árbol.
   cuando rotemos, insertemos y borremos, toca actualizar altura */
  public void actualizarAltura(Nodo nodo) {
    if (nodo != null) {
      nodo.altura = 1 + max(altura(nodo.izq), altura(nodo.der));
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
  Nodo simpleLeft(Nodo aux) {
    // aux = nodo desbalanceado
    Nodo x = aux.der;    // x = hijo derecho de aux
    Nodo y = x.izq;      // y = hijo izquierdo de x

    //el nuevo derecho de aux va a ser el izquierdo del hijo derecho de aux
    aux.der = y;

    //al derecho de aux, le clavamos un nuevo izquierdo, que será aux
    x.izq = aux;

    //actualizamos las alturas
    actualizarAltura(aux);   // aux cambió de hijos, su altura puede bajar
    actualizarAltura(x);     // x es la nueva raíz del subárbol, su altura puede subir

    return x; // x se convierte en la nueva raíz
  }

  Nodo simpleRight(Nodo aux) {
    // aux = nodo desbalanceado
    Nodo x = aux.izq;    // x = hijo izquierdo de aux
    Nodo y = x.der;      // y = hijo derecho de x

    //el nuevo izquierdo de aux va a ser el derecho del hijo izquierdo de aux
    aux.izq = y;

    //al izquierdo de aux, le clavamos un nuevo derecho, que será aux
    x.der = aux;

    //actualizamos las alturas
    actualizarAltura(aux);   // aux cambió de hijos, su altura puede bajar
    actualizarAltura(x);     // x es la nueva raíz del subárbol, su altura puede subir

    return x; // x se convierte en la nueva raíz
  }



  /*
  3. INSERCIONES
   */

  public void insertarRaiz(int valor) {
    raiz = insertar(raiz, valor);
  }

  Nodo insertar(Nodo nodo, int info) {
    if (nodo==null) {
      return new Nodo(info); //no tenemos que instanciar nada, puesto que estamos retornando!! :OOO1
    }
    if (info < nodo.data) {
      nodo.izq = insertar(nodo.izq, info);
    } else if (info>nodo.data) {
      nodo.der = insertar(nodo.der, info);
    } else {
      return nodo; // si el valor es igual, retorna el nodo actual y ya, pa q no se rompa nada
      // no sé si se explote si no lo pongo, así que lo voy a dejar kjskajsa
    }

    //actualizamos la altura después de insertar.
    actualizarAltura(nodo);

    //calculamos el balance ahora después de insertar

    int b = balance(nodo);

    //comparamos los casos de desequilibrio
    //para todas las rotaciones, no solo comparamos b, pues necesitamos encontrar el nieto que causó el desbalance.
    // *donde cae el valor, ahí está el nieto* queremos ver si ese nieto cayó en línea recta o está cruzado

    //es útil para saber si el valor cae simple o cae doble, porque sin eso, no habría manera de diferenciar los casos

    if (b > 1 & info > nodo.der.data) { //acá nos pregunta si es derecha y si cayó RECTECITO hasta el final, es decir, si es simpleRight
      return simpleRight(nodo);
    }

    if (b < -1 & info < nodo.izq.data) { //acá nos pregunta si es izquierda y si cayó RECTECITO hasta el final, es decir, si es simpleLeft
      return simpleLeft(nodo);
    }

    if (b > 1 & info < nodo.der.data) { //acá nos pregunta si es derecha y si cayó CRUZADO hasta el final, es decir, si es DOUBLE RIGHT-LEFT
      //hacemos una simpleRight con el derecho del desbalanceado
      nodo.der = simpleRight(nodo.der);
      //luego hacemos una simpleLeft con el nodo origen
      return simpleLeft(nodo);
    }

    if (b < -1 & info < nodo.der.data) { //acá nos pregunta si es izquierda y si cayó CRUZADO hasta el final, es decir, si es DOUBLE LEFT-RIGHT
      //hacemos una simpleLeft con el izquierdo del desbalanceado
      nodo.izq = simpleLeft(nodo.izq);
      //luego hacemos una simpleRight con el nodo desbalanceado
      return simpleRight(nodo);
    }

    // SI NO HUBO DESBALANCE, TERMINAMOS!!! SACA ESA MONDAAAAA
    return nodo;
  }



  /*
  4. otros
   */

  void preorden(Nodo nodo) {
    if (nodo!=null) {
      System.out.println(nodo.data);
      preorden(nodo.izq);
      preorden(nodo.der);
    } else {
      return;
    }
  }

  void inorden(Nodo nodo) {
    if (nodo!=null) {

      inorden(nodo.izq);
      System.out.println(nodo.data);
      inorden(nodo.der);
    } else {
      return;
    }
  }

  void postorden(Nodo nodo) {
    if (nodo!=null) {

      postorden(nodo.izq);
      System.out.println(nodo.data);
      postorden(nodo.der);
    } else {
      return;
    }
  }
}
