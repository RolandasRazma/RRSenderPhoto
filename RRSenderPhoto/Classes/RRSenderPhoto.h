//
//  RRSenderPhoto.h
//  RRSenderPhoto
//
//  Created by Rolandas Razma on 12/13/11.
//  Copyright (c) 2011 UD7. All rights reserved.
//

#import "RRSenderPhoto.h"
#import <AddressBook/AddressBook.h>


void Swizzle(Class c, SEL orig, SEL new, BOOL classMethod);


@interface RRSenderPhoto : NSObject

+ (void)registerBundle;

@end



