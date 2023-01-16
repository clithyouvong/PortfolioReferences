package snhu.it634.q1657.service;

import java.security.NoSuchAlgorithmException;
import java.util.Base64;    
import javax.crypto.Cipher;  
import javax.crypto.KeyGenerator;   
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec; 

/*
Colby Lithyouvong
IT-634-Q1657 Distributed App Development 22TW1
Final Project Part I Submission: Web Application With Annotated Code
*/

public class EncryptionService {   
    private Cipher _cipher;  
    private SecretKey _secretKey;
    
    public SecretKey GetSecretKey() {
        return _secretKey;
    }
    
    public EncryptionService() {

        /* 
         create key 
         If we need to generate a new key use a KeyGenerator
         If we have existing plaintext key use a SecretKeyFactory
        */ 
        KeyGenerator keyGenerator;
        try {
            keyGenerator = KeyGenerator.getInstance("AES");        
            keyGenerator.init(128); // block size is 128bits
            _secretKey = keyGenerator.generateKey();
            
            /*
              Cipher Info
              Algorithm : for the encryption of electronic data
              mode of operation : to avoid repeated blocks encrypt to the same values.
              padding: ensuring messages are the proper length necessary for certain ciphers 
              mode/padding are not used with stream cyphers.  
             */
            _cipher = Cipher.getInstance("AES"); //SunJCE provider AES algorithm, mode(optional) and padding schema(optional)  
            
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

    //encrypts the plaintext using the secret key
    public String encrypt(String plainText, SecretKey secretKey)
            throws Exception {
        byte[] plainTextByte = plainText.getBytes();
        _cipher.init(Cipher.ENCRYPT_MODE, secretKey);
        byte[] encryptedByte = _cipher.doFinal(plainTextByte);
        Base64.Encoder encoder = Base64.getEncoder();
        String encryptedText = encoder.encodeToString(encryptedByte);
        return encryptedText;
    }

    //decrypts the plain text using the secret key
    public String decrypt(String encryptedText, SecretKey secretKey)
            throws Exception {
        Base64.Decoder decoder = Base64.getDecoder();
        byte[] encryptedTextByte = decoder.decode(encryptedText);
        _cipher.init(Cipher.DECRYPT_MODE, secretKey);
        byte[] decryptedByte = _cipher.doFinal(encryptedTextByte);
        String decryptedText = new String(decryptedByte);
        return decryptedText;
    }
    
    //converts the secret key object to a string for serialization
    public String convertSecretKeyToString(SecretKey secretKey) throws NoSuchAlgorithmException {
        byte[] rawData = secretKey.getEncoded();
        String encodedKey = Base64.getEncoder().encodeToString(rawData);
        return encodedKey;
    }
    
    //converts the string back to a secret key from deserialization
    public SecretKey convertStringToSecretKeyto(String encodedKey) {
        byte[] decodedKey = Base64.getDecoder().decode(encodedKey);
        SecretKey originalKey = new SecretKeySpec(decodedKey, 0, decodedKey.length, "AES");
        return originalKey;
    }
}
