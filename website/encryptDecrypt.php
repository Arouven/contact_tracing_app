<?php
// class encryptDecrypt
// {

//     private $string;

//     private   $ciphering;
//     private   $iv_length;
//     private   $options;
//     private   $iv;
//     private   $key;

//     function __construct($string)
//     {
//         $this->string = $string;
//         // Store the cipher method
//         $this->ciphering = "AES-128-CTR";
//         // Use OpenSSl Encryption method
//         $this->iv_length = openssl_cipher_iv_length($this->ciphering);
//         $this->options = 0;
//         // Non-NULL Initialization Vector for encryption
//         $this->iv = '1234567891011121';
//         // Store the encryption key
//         $this->key = "ContactTracing";
//     }

//     /**
//      * To get encrypted results
//      *
//      * @return string
//      */
//     public  function encrypt()
//     {

//         // Store a string into the variable which
//         // need to be Encrypted
//         // Display the original string
//         echo "Original String: " . $this->string;


//         // Use openssl_encrypt() function to encrypt the data
//         $encryption = openssl_encrypt(
//             $this->string,
//             $this->ciphering,
//             $this->key,
//             $this->options,
//             $this->iv
//         );
//         // Display the encrypted string
//         echo "Encrypted Username: " . $encryption . "\n";
//         return $encryption;
//     }

//     /**
//      * To get decrypted results
//      *
//      * @return string
//      */
//     public function decrypt()
//     {
//         // Use openssl_decrypt() function to decrypt the data
//         $decryption = openssl_decrypt(
//             $this->string,
//             $this->ciphering,
//             $this->key,
//             $this->options,
//             $this->iv
//         );
//         // Display the decrypted string
//         echo "Decrypted Username: " . $decryption;
//         return $decryption;
//     }
// }
