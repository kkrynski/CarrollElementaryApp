//
//  CESEncryption.h
//  FloraDummy
//
//  Created by Michael Schloss on 12/14/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>

typedef NS_ENUM(NSInteger, UserState)
{
    UserStateUserIsStudent,
    UserStateUserIsTeacher,
    UserStateUserInvalid
};

@interface NSError (CommonCryptoErrorDomain)
+ (NSError *) errorWithCCCryptorStatus: (CCCryptorStatus) status;
@end

@interface NSData (CESEncryption)

- (NSString *)hexRepresentationWithSpaces:(BOOL)spaces capitals:(BOOL)capitals;
- (NSData *) dataFromHexString:(NSString *)string;

- (NSData *) AES256EncryptedDataUsingKey: (id) key error: (NSError **) error;
- (NSData *) decryptedAES256DataUsingKey: (id) key error: (NSError **) error;

@end

@interface NSData (LowLevelCommonCryptor)

- (NSData *) dataEncryptedUsingAlgorithm: (CCAlgorithm) algorithm
                                     key: (id) key		// data or string
                                   error: (CCCryptorStatus *) error;
- (NSData *) dataEncryptedUsingAlgorithm: (CCAlgorithm) algorithm
                                     key: (id) key		// data or string
                                 options: (CCOptions) options
                                   error: (CCCryptorStatus *) error;
- (NSData *) dataEncryptedUsingAlgorithm: (CCAlgorithm) algorithm
                                     key: (id) key		// data or string
                    initializationVector: (id) iv		// data or string
                                 options: (CCOptions) options
                                   error: (CCCryptorStatus *) error;

- (NSData *) decryptedDataUsingAlgorithm: (CCAlgorithm) algorithm
                                     key: (id) key		// data or string
                                   error: (CCCryptorStatus *) error;
- (NSData *) decryptedDataUsingAlgorithm: (CCAlgorithm) algorithm
                                     key: (id) key		// data or string
                                 options: (CCOptions) options
                                   error: (CCCryptorStatus *) error;
- (NSData *) decryptedDataUsingAlgorithm: (CCAlgorithm) algorithm
                                     key: (id) key		// data or string
                    initializationVector: (id) iv		// data or string
                                 options: (CCOptions) options
                                   error: (CCCryptorStatus *) error;

@end
