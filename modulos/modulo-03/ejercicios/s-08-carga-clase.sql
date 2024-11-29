--@Autor: Hernandez Vazquez Jaime
--@Fecha creación: 29/11/2024
--@Descripción: Definicion y carga de una clase Java para Pool en SGA.

Prompt 1.  Autenticando como c##userJava
connect c##userJava/userJava

Prompt 2. Cargando la clase Java
--#TODO

create or replace and resolve java source named ResizeImage as

package mx.edu.unam.fi.dipbd;

import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

import javax.imageio.ImageIO;

/**
 * Utility class used to resize an Image using {@link Graphics2D}
 */
public class ResizeImage {

  /**
   * Método encargado de modificar el tamaño de una imagen. La imagen
   * modificada será almacenada en el mismo directorio con el nombre
   * output-<nombre-archivo>
   * @param imgPath Ruta absoluta donde se encuentra la imagen origen
   * @param targetWidth Ancho de la imagen
   * @param targetHeight Alto de la imagen
   * @throws IOException Si ocurre un error.
   */
  public static void resizeImage(String imgPath, int targetWidth, int targetHeight)
    throws IOException {
    System.out.println("Procesando imagen " + imgPath);
    File imgFile = new File(imgPath);
    BufferedImage srcImg = ImageIO.read(imgFile);
    Image outputImg =
      srcImg.getScaledInstance(targetWidth, targetHeight, Image.SCALE_DEFAULT);
    BufferedImage outputImage =
      new BufferedImage(targetWidth, targetHeight, BufferedImage.TYPE_INT_RGB);
    outputImage.getGraphics().drawImage(outputImg, 0, 0, null);
    System.out.println("Escribiendo imagen ");
    String outputName = "output-" + imgFile.getName();
    File outputFile = new File(imgFile.getParent(), outputName);
    ImageIO.write(outputImage, "png", outputFile);
  }

  public static void main(String[] args) 
    throws Exception {
    resizeImage("/tmp/paisaje.png", 734, 283);
    System.out.println("Listo!");
  }
}
--TODO#