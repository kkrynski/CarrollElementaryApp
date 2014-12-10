//
//  ClassConversions.m
//  FloraDummy
//
//  Created by Zachary Nichols on 11/23/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "ClassConversions.h"

#import "Activity.h"
#import "Page.h"
#import "Content.h"

@implementation ClassConversions

-(NSDictionary *)dictionaryForActivity: (Activity *)a
{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZ"];
    
    NSMutableDictionary *output = [[NSMutableDictionary alloc] init];
    [output setValue:a.name forKey:@"Name"];
    [output setValue:[outputFormatter stringFromDate:a.modDate] forKey:@"ModDate"];
    [output setValue:[outputFormatter stringFromDate:a.releaseDate] forKey:@"ReleaseDate"];
    [output setValue:[outputFormatter stringFromDate:a.dueDate] forKey:@"DueDate"];
    [output setValue:a.iconImageName forKey:@"Icon"];
    [output setValue:a.activityID forKey:@"ActivityID"];
    
    
    NSMutableArray *outputPages = [[NSMutableArray alloc] init];
    for (Page *p in a.pageArray)
    {
        [outputPages addObject:[self dictionaryForPage: p]];
    }
    
    [output setValue:outputPages forKey:@"Pages"];
    
    return output;
}

-(Activity *)activityFromDictionary: (NSDictionary *)dict
{
    Activity *output = [[Activity alloc] init];
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZ"];
    
    output.name = (NSString *)[dict objectForKey:@"Name"];
    output.modDate = [inputFormatter dateFromString:(NSString *)[dict objectForKey:@"ModDate"]];
    output.releaseDate = [inputFormatter dateFromString:(NSString *)[dict objectForKey:@"ReleaseDate"]];
    output.dueDate = [inputFormatter dateFromString:(NSString *)[dict objectForKey:@"DueDate"]];
    output.iconImageName = (NSString *)[dict objectForKey:@"Icon"];
    output.activityID = (NSString *)[dict objectForKey:@"ActivityID"];
    
    NSMutableArray *inputPages = [[NSMutableArray alloc] init];
    for (NSDictionary *p in (NSArray *)[dict objectForKey:@"Pages"])
    {
        [inputPages addObject:[self pageFromDictionary:p]];
    }
    
    output.pageArray = inputPages;
    
    return output;
}


-(NSDictionary *)dictionaryForPage: (Page *)p
{
    NSMutableDictionary *output = [[NSMutableDictionary alloc] init];
    [output setValue:p.pageVCType forKey:@"PageVC"];
    [output setValue:[self simplifiedContentFor:p.variableContentDict] forKey:@"VariableContentDict"];
    
    return output;
}

-(NSDictionary *)simplifiedContentFor: (NSDictionary *)variableContent
{
    NSMutableDictionary *output = [[NSMutableDictionary alloc] initWithDictionary:variableContent];
    
    if ([variableContent objectForKey:@"ContentArray"])
    {
        // Convert content
        NSMutableArray *newContentArray = [[NSMutableArray alloc] init];
        for (Content *c in (NSArray *)[variableContent objectForKey:@"ContentArray"])
        {
            [newContentArray addObject:[self dictionaryForContent:c]];
        }
        
        [output setValue:newContentArray forKey:@"ContentArray"];
    }
    
    return output;
}

-(NSDictionary *)expandContentFor: (NSDictionary *)variableContent
{
    NSMutableDictionary *output = [[NSMutableDictionary alloc] initWithDictionary:variableContent];
    
    if ([variableContent objectForKey:@"ContentArray"])
    {
        // Convert content
        NSMutableArray *newContentArray = [[NSMutableArray alloc] init];
        for (NSDictionary *c in (NSArray *)[variableContent objectForKey:@"ContentArray"])
        {
            [newContentArray addObject:[self contentFromDictionary:c]];
        }
        
        [output setValue:newContentArray forKey:@"ContentArray"];
    }
    
    return output;
}

-(Page *)pageFromDictionary: (NSDictionary *)dict
{
    Page *output = [[Page alloc] init];
    
    output.pageVCType = [dict objectForKey:@"PageVC"];
    output.variableContentDict = [self expandContentFor:(NSDictionary *)[dict objectForKey:@"VariableContentDict"] ];
    
    return output;
}

-(NSDictionary *)dictionaryForContent: (Content *)c
{
    NSMutableDictionary *output = [[NSMutableDictionary alloc] init];
    [output setValue:c.type forKey:@"ContentType"];
    [output setValue:[c arrayForBounds] forKey:@"Bounds"];
    [output setValue:c.variableContent forKey:@"VariableContent"];
    
    return output;
}

-(Content *)contentFromDictionary: (NSDictionary *)dict
{
    Content *output = [[Content alloc] init];
    
    output.type = [dict objectForKey:@"ContentType"];
    [output setFrame:(NSArray *)[dict objectForKey:@"Bounds"]];
    output.variableContent = [dict objectForKey:@"VariableContent"];
    
    return output;
}



@end
