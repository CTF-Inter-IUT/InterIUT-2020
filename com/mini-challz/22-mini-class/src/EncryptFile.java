import java.io.File;
import java.util.Base64;
import java.util.Random;
import java.util.Scanner;

/**
 * @author masterfox
 *
 */
public class EncryptFile {
	private static Random r = new Random();
	private static String alphabet = new String("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789/");

	private static String generateRandomString() {
		int length = r.nextInt(15) + 16;
		String result = "";
		
		for (int i=0; i <= length; i++) {
			result += alphabet.charAt(r.nextInt(alphabet.length()));
		}
		
		return result;
	}
	
	
	private static String shift(String content) {
		StringBuilder result = new StringBuilder(content);
		int tmpVal;
		for (int i=0; i < content.length(); i++) {
			if (content.charAt(i) == '{' || content.charAt(i) == '}') {
				result.setCharAt(i, content.charAt(i));
			} else {
				result.setCharAt(i, (char)(content.charAt(i) + 4));				
			}
		}
		return result.toString();
	}
	
	private static String b64Encode(String content) {
		return Base64.getEncoder().encodeToString(content.getBytes()).replace("=", "");
	}
	
	private static String encrypt(String content) {		
		StringBuilder result = new StringBuilder("$6$");
		content = EncryptFile.shift(content);
		content = EncryptFile.b64Encode(content);
		result.append(content);
		
		String garbage = EncryptFile.b64Encode(EncryptFile.generateRandomString());
		result.append("." + garbage);
		garbage = EncryptFile.b64Encode(EncryptFile.generateRandomString());
		result.append("." + garbage);
		
		
		// Generate random garbage at the end
		if (r.nextBoolean())
			result.append(":" + r.nextInt(2000));
		
		result.append(":" + r.nextInt(30000));
		result.append(":" + r.nextInt(5000));
		
		int nbDots = r.nextInt(3);
		for (int i=0; i <= nbDots; i++)
			result.append(":");
		
		return  result.toString();
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) throws Exception {
		if (args.length > 0) {			
			File fileToEncrypt = new File(args[0]); 
			Scanner sc = new Scanner(fileToEncrypt); 
			String currentLine = "";
			while (sc.hasNextLine()) {
				currentLine = sc.nextLine();
				currentLine  = EncryptFile.encrypt(currentLine);
				
				System.out.println(currentLine);
				
			}
			
			sc.close();
		} else {
			System.out.println("Usage: java ./EncryptFile fileToEncrypt");
		}
	}

}
