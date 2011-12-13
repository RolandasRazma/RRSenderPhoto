//
//  SenderPhoto.m
//  SenderPhoto
//
//  Created by Rolandas Razma on 12/13/11.
//  Copyright (c) 2011 UD7. All rights reserved.
//

#import "SenderPhoto.h"

@implementation SenderPhoto

// This example action works with phone numbers.
- (NSString *)actionProperty
{
    return kABPhoneProperty;
}

// Our menu title will look like Speak 555-1212
- (NSString *)titleForPerson:(ABPerson *)person identifier:(NSString *)identifier
{
    ABMultiValue *values = [person valueForProperty:[self actionProperty]];
    NSString *value = [values valueForIdentifier:identifier];

    return [NSString stringWithFormat:@"Speak %@", value];    
}

// This method is called when the user selects your action. As above, this method
// is passed information about the data item rolled over.
- (void)performActionForPerson:(ABPerson *)person identifier:(NSString *)identifier
{
    ABMultiValue *values = [person valueForProperty:[self actionProperty]];
    NSString *value = [values valueForIdentifier:identifier];

    NSSpeechSynthesizer *speech = [[[NSSpeechSynthesizer alloc] initWithVoice:[NSSpeechSynthesizer defaultVoice]] autorelease];
    [speech startSpeakingString:value];
}

// Optional. Your action will always be enabled in the absence of this method. As
// above, this method is passed information about the data item rolled over.
- (BOOL)shouldEnableActionForPerson:(ABPerson *)person identifier:(NSString *)identifier
{
    return YES;
}

@end
