using System;
using System.Security.Cryptography;
using System.Text;

namespace Demo
{
    public class Crypto
    {
        public static string EncryptData(string textToEncrypt, string symmetricKey)
        {
            AesManaged objAes = new AesManaged();

            //set the mode for operation of the algorithm
            objAes.Mode = CipherMode.CBC;

            //set the padding mode used in the algorithm
            objAes.Padding = PaddingMode.PKCS7;

            //set the size, in bits, for the secret key
            objAes.KeySize = 0x100;

            //set the block size in bits for the cryptographic operation
            objAes.BlockSize = 0x80;

            //set the symmetric key that is used for encryption and decryption
            byte[] passBytes = Encoding.UTF8.GetBytes(symmetricKey);

            //set the initialization vector (IV) for the symmetric algorithm
            byte[] encryptionKeyBytes = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
            int len = passBytes.Length;
            if (len > encryptionKeyBytes.Length)
            {
                len = encryptionKeyBytes.Length;
            }
            Array.Copy(passBytes, encryptionKeyBytes, len);
            objAes.Key = encryptionKeyBytes;
            objAes.IV = encryptionKeyBytes;

            //Creates symmetric AES object with the current key and initialization vector IV
            ICryptoTransform objTransform = objAes.CreateEncryptor();
            byte[] textDataByte = Encoding.UTF8.GetBytes(textToEncrypt);

            //Final transform the test string
            return Convert.ToBase64String(objTransform.TransformFinalBlock(textDataByte, 0, textDataByte.Length));
        }

        public static string DecryptData(string textToDecrypt, string symmetricKey)
        {
            AesManaged objAes = new AesManaged();

            objAes.Mode = CipherMode.CBC;

            objAes.Padding = PaddingMode.PKCS7;

            objAes.KeySize = 0x100;

            objAes.BlockSize = 0x80;

            byte[] encryptedTextByte = Convert.FromBase64String(textToDecrypt);
            //byte[] passBytes = Encoding.UTF8.GetBytes("@N3!3P3nCr9yPt!0n");
            byte[] passBytes = Encoding.UTF8.GetBytes(symmetricKey);
            byte[] encryptionKeyBytes = new byte[0x10];
            int len = passBytes.Length;
            if (len > encryptionKeyBytes.Length)
            {
                len = encryptionKeyBytes.Length;
            }
            Array.Copy(passBytes, encryptionKeyBytes, len);
            objAes.Key = encryptionKeyBytes;
            objAes.IV = encryptionKeyBytes;

            byte[] textByte = objAes.CreateDecryptor().TransformFinalBlock(encryptedTextByte, 0, encryptedTextByte.Length);

            return Encoding.UTF8.GetString(textByte);
        }
    }
}
