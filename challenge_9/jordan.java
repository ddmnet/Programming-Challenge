// javac jordan.java
// java jordan "key" "plainText"

public class jordan {
	public static void main(String[] args) {
		System.out.println(encrypt(args[0], args[1]));
	}

	static String encrypt(String key, String plainText) {
		String encrypted = "";

		for (int textIndex = 0, keyIndex = 0; textIndex < plainText.length(); textIndex++) {
			char currentChar = plainText.charAt(textIndex);

			if (currentChar == ' ') {
				encrypted += ' ';
				keyIndex = ++keyIndex % key.length();
				continue;
			}

			encrypted += (char)((currentChar + key.charAt(keyIndex) - 2 * 'A') % 26 + 'A');
			keyIndex = ++keyIndex % key.length();
		}

		return encrypted;
	}
}
