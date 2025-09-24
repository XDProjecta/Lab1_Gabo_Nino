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
    raiz = insertarNodo(raiz, valor);
  }

  Nodo insertarNodo(Nodo nodo, int info) {
    if (nodo==null) {
      return new Nodo(info); //no tenemos que instanciar nada, puesto que estamos retornando!! :OOO1
    }
    if (info < nodo.data) {
      nodo.izq = insertarNodo(nodo.izq, info);
    } else if (info>nodo.data) {
      nodo.der = insertarNodo(nodo.der, info);
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
  4. ELIMINATION
   */

  //en caso de que quiera eliminar la raiz, o no sé si todo, falta probar :v
  //mentirita, esto es para no tener que siempre pasar por la raiz.
  public void eliminarRaiz(int info) {
    // Si borramos la raíz y no tenía hijos, la raiz quedará en null, queda el árbol vacío (duh).
    raiz = eliminarNodo(raiz, info);
  }

  private Nodo eliminarNodo(Nodo nodo, int info) {
    //si el nodo es nulo, pues no hay nada que borrar
    if (nodo == null) return null;

    // vamos bajando como si fuera un ABB, es decir, recorremos el árbol hasta que el valor que queremos borrar sea igual al nodo en el que estamos
    // if(valor ==nodo.data){ sout("coronamos")}

    // Si info es menor que la data del nodo actual, se borra en el subárbol izquierdo
    if (info < nodo.data) {
      nodo.izq = eliminarNodo(nodo.izq, info);

      // Si info es mayor, se borra en el subárbol derecho
    } else if (info > nodo.data) {
      nodo.der = eliminarNodo(nodo.der, info);
    } else {
      // LA INFO ES IGUAL A LA NODO.DATA, LO ENCONTRAMOS!!


      // a partir de acá, hay varios casos dependiendo de los hijos que tenga dicho nodo a borrar

      // CASO 1) si tiene 0 hijos (hoja) O 1 hijo:
      // Si uno de los hijos es null, el resultado del borrado es el otro hijo.
      // Con esto estamoss cubriendo el caso de la hoja (ambos null, entonces => hijo = null) y nodo con un solo hijo.
      if (nodo.izq == null || nodo.der == null) {
        //usamos operador ternario con el fin de ombe, reducir código jkajskja
        // básicamente, si mi izquierdo NO es nulo, mi variable "hijo" será el izquierdo y, si es nulo, mi variable "hijo" será el nodo derecho
        Nodo hijo = (nodo.izq != null) ? nodo.izq : nodo.der;
        // entonces, "Eliminamos" el nodo actual reemplazándolo por su hijo (puede ser null en caso de ser hoja).
        nodo = hijo;
      } else {
        // CASO 2) 2 hijos (izq y der NO son null):
        // Lo que hacemos, es buscar el más pequeño del subárbol derecho por medio del inorden.
        //  quiere decir que vamos a buscar el que esté "más a la izquierda" dentro del subárbol derecho del nodo que vamos a eliminar.
        //PRIMERO: BUSCAMOS A DICHO COLE, A ESE "SUCESOR" en el subárbol derecho:
        Nodo sucesor = minNodo(nodo.der);
        //cambio el valor del nodo a borrar por el del sucesor, BORRANDO DICHO VALOR, POR LO QUE "BORRAMOS" EL NODO.
        nodo.data = sucesor.data;
        /*Como no podemos tener valores repetidos, borramos al sucesor, el cual claro,
         al ser el que más a la izquierda está en el subárbol derecho, no tiene
         ningún nodo izquierdo, por lo que cae en el CASO 1) 0 o 1 hijo.
         */
        nodo.der = eliminarNodo(nodo.der, sucesor.data);
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
      if (balance(nodo.der) >= 0) {
        return simpleLeft(nodo);
      } else {
        // Si balance(der) < 0 significa que el hijo derecho está cargado a la izquierda
        // entonces es una DOUBLE RIGHT LEFT: primero RIGHT sobre el hijo, luego LEFT sobre el nodo.
        nodo.der = simpleRight(nodo.der);
        return simpleLeft(nodo);
      }
    }

    // Caso DESBALANCEADO a la IZQUIERDA (b < -1):
    if (b < -1) {
      // Miramos el balance del hijo izquierdo:
      // Si balance(izq) <= 0 el hijo izquierdo NO está cargado a la derecha
      // entonces es una SIMPLE RIGHT.
      if (balance(nodo.izq) <= 0) {
        return simpleRight(nodo);
      } else {
        // Si balance(izq) > 0 el hijo izquierdo sí está cargado a la derecha
        // entonces es una DOUBLE LEFT-RIGHT: primero LEFT sobre el hijo, luego RIGHT sobre el nodo.
        nodo.izq = simpleLeft(nodo.izq);
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
    while (aux != null && aux.izq != null) {
      aux = aux.izq;
    }
    return aux;
  }

  /*
  5. otros
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
