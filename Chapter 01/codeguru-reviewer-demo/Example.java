import java.io.*;

public class Example {

    public static int addNumbers(int a, int b) {
        int result = a + b;
        return result;
    }

    public static void readFile(String fileName) {
        // Intentionally introduce an issue: resource leak
        try {
            FileReader fileReader = new FileReader(fileName);
            BufferedReader bufferedReader = new BufferedReader(fileReader);
            String line = bufferedReader.readLine();
            System.out.println("First line of the file: " + line);
        } catch (IOException e) {
            System.out.println("Error reading file: " + e.getMessage());
        }
        // The file reader and buffered reader are not properly closed
    }

    public static void main(String[] args) {
        int x = 5;
        int y = 10;
        int result = addNumbers(x, y);
        System.out.println("The sum of " + x + " and " + y + " is " + result);

        String fileName = "example.txt";
        readFile(fileName);
    }
}
