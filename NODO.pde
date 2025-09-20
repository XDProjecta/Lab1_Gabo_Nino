 public class Nodo {
  private int data;
  private Nodo der, izq;
  private int altura;

  public Nodo(int data) {
    this.data = data;
    this.der = null;
    this.izq = null;
    this.altura = 1; //por ahora dejamos que la altura de cualquier nuevo nodo sea 1
  }

}
