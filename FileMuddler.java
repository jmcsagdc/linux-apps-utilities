import java.io.File;
import java.io.IOException;
import java.util.Scanner;

public class FileMuddler {

    public static void main(String[] args) {
        String directory = ".";
        System.out.println("XXXXXXXXXXXXXXXXXXXXXXXXXX");
        System.out.println("I only do jpgs in the current working directory!");
        System.out.println("Current working directory: " + System.getProperty("user.dir"));
        System.out.println("XXXXXXXXXXXXXXXXXXXXXXXXXX");
        Scanner scanner = new Scanner(System.in);
        System.out.print("New filename base: ");
        String myString = scanner.nextLine();

        System.out.println("Suffix is -generative-stock.jpg");

        muddleContents(directory, myString);
    }

    private static void muddleContents(String directory, String myString) {
        int i = 0;
        File dir = new File(directory);
        File[] files = dir.listFiles();
        if (files != null) {
            for (File file : files) {
                if (file.isFile() && file.getName().endsWith(".jpg")) {
                    System.out.println("XXXXXXXXXXXXXXXXXXXXXXXXXX");
                    System.out.println("BEFORE: " + file.getPath());
                    i++;
                    String newF = myString + "_" + i + "-generative-stock.jpg";
                    System.out.println("AFTER: " + newF);
                    System.out.println("Use x to EXIT");
                    Scanner scanner = new Scanner(System.in);
                    System.out.print("Change it y/x/n? ");
                    String doIt = scanner.nextLine();
                    if (doIt.contains("y")) {
                        File newFile = new File(dir, newF);
                        if (file.renameTo(newFile)) {
                            System.out.println("File renamed successfully.");
                        } else {
                            System.out.println("Failed to rename the file.");
                        }
                    } else if (doIt.contains("x")) {
                        System.exit(0);
                    } else {
                        System.out.println("I skipped this");
                    }
                } else if (file.isFile()) {
                    System.out.println("Not a proper file: " + file.getPath());
                } else if (file.isDirectory()) {
                    // System.out.println(file.getPath() + " is a directory");
                } else {
                    System.out.println("XXXXXXXXXXXXXXXXXXXXXXXXXX");
                    System.out.println(file.getName() + " <-----IS NOT A JPEG");
                }
            }
        }
    }
}
