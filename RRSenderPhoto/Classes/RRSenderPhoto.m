//
//  RRSenderPhoto.m
//  RRSenderPhoto
//
//  Created by Rolandas Razma on 12/13/11.
//  Copyright (c) 2011 UD7. All rights reserved.
//
//  http://www.modelmetrics.com/tomgersic/iphone-programming-adding-a-contact-to-the-iphone-address-book/
//

#import "RRSenderPhoto.h"
#import <objc/runtime.h> 
#import <objc/message.h>


void Swizzle(Class c, SEL orig, SEL new, BOOL classMethod) {
    Method origMethod;
    Method newMethod;
    
    if( classMethod ){
        origMethod = class_getClassMethod(c, orig);
        newMethod = class_getClassMethod(c, new);
    }else{
        origMethod = class_getInstanceMethod(c, orig);
        newMethod = class_getInstanceMethod(c, new);        
    }
    
    method_exchangeImplementations(origMethod, newMethod);
}


@implementation NSString (RRSenderPhoto)


- (NSArray *)mailComponents {
    NSMutableArray *components = [[NSMutableArray alloc] initWithObjects: self, nil];
    
    
    NSCharacterSet *separatorSet = [NSCharacterSet characterSetWithCharactersInString:@"@."];
    
    NSScanner *scanner = [NSScanner scannerWithString: self];
    
    [scanner scanUpToCharactersFromSet:separatorSet intoString:NULL];
    [scanner setScanLocation: scanner.scanLocation +1];
    [components addObject: [self substringWithRange:NSMakeRange(scanner.scanLocation, self.length -scanner.scanLocation)]];
    
    while ( ![scanner isAtEnd] ) {
        [scanner scanUpToCharactersFromSet:separatorSet intoString:NULL];
        if( ![scanner isAtEnd] ){
            [scanner setScanLocation: scanner.scanLocation +1];    
            [components addObject: [self substringWithRange:NSMakeRange(scanner.scanLocation, self.length -scanner.scanLocation)]];    
        }
    }
    
    
    return [components autorelease];
}


@end


@implementation RRSenderPhoto


+ (void)registerBundle {
    if( class_getClassMethod(NSClassFromString(@"MVMailBundle"), @selector(registerBundle)) ) {
        [NSClassFromString(@"MVMailBundle") performSelector:@selector(registerBundle)];
    }
}


+ (void)initialize {
	[super initialize];
    Swizzle( [ABAddressBook class], @selector(recordsMatchingSearchElement:), @selector(rr_recordsMatchingSearchElement:), NO);
}


@end


@implementation ABAddressBook (RRSenderPhoto)


- (NSArray *)rr_recordsMatchingSearchElement:(ABSearchElement *)searchElement {
    NSArray *records = [self rr_recordsMatchingSearchElement:searchElement];

    if( ![records count] ){
        NSString *description = [searchElement description];
        NSRange trRange = [description rangeOfString:@" '"];
        if( trRange.location != NSNotFound ){
            NSString *email = [description substringWithRange:NSMakeRange(trRange.location +2, description.length -trRange.location -4)];
            
            NSString *imagePath = nil;
            
            // Find longest name logo
            NSArray *mailComponents = [[email lowercaseString] mailComponents];
            for( NSString *component in mailComponents ){
                imagePath = [[NSBundle bundleForClass:[RRSenderPhoto class]] pathForResource: component
                                                                                      ofType: @"png" 
                                                                                 inDirectory: @"Logos"];
                if( imagePath ) break;
            }

            // If we found logo
            if( imagePath ){
#pragma TODO: something wrong here, you cant replay to emails
                ABPerson *person = [[ABPerson alloc] init];
                
                // Add Email
                ABMutableMultiValue *multiValue = [[ABMutableMultiValue alloc] init];
                [multiValue addValue:email withLabel:kABEmailHomeLabel];
                [person setValue:multiValue forProperty:kABEmailProperty];
                [multiValue release];

                // Add photo
                [person setImageData: [NSData dataWithContentsOfFile: imagePath]];
                
                records = [NSArray arrayWithObject:person];  
                [person release];
            }
        }
    }
  
    return records;
}


@end
