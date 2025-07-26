public class Main {

  public static void main(String[] args) {

    try {
      Icons icons = new Icons();

      icons.initAscii();
      System.out.println(icons.getLocalSpace());

      String systemInfo = Fetch.fetchCreate();
      System.out.println(systemInfo);

    } catch (Exception e) {
      System.out.println("Invalid input, type is not supported");
    } catch (OutOfMemoryError e) {
      System.out.println("To many memory is using");
    }
  }
}