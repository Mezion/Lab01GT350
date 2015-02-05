//
//  Participant.m
//  Lab01-Ski
//
//  Created by Bigras, Renaud on 2015-02-04.
//  Copyright (c) 2015 Legault, Mathieu. All rights reserved.
//

#import "Participant.h"


@implementation Participant

- (id)init
{
    self = [super init];
    if (self)
    {
        nom = @"";
        prenom = @"";
        pays = @"";
        partId = 0;
        resultats = [NSMutableArray new];
    }
    return self;
}

-(void) setNom: (NSString*) s
{
    nom = s;
}

-(void) setPrenom: (NSString*) s
{
    prenom = s;
}

-(void) setPays: (NSString*) s
{
    pays = s;
}

-(void) setId: (int) i
{
    partId = i;
}

-(void) setTime: (NSTimeInterval*) t
{
    
}

-(void) addResult: (Result*) r
{
    if([resultats count] < 2){
        [resultats addObject:r];
    }
}

-(NSString*) getNom
{
    return nom;
}

-(NSString*) getPrenom
{
    return prenom;
}

-(NSString*) getPays
{
    return pays;
}

-(int) getId
{
    return partId;
}

-(NSMutableArray*) getResultats
{
    return resultats;
}

-(NSNumber*) getSumOfResults{
    double d = 0.0;
    for(Result* result in resultats)
    {
        d += result.getTime;
    }
    NSNumber *value = [NSNumber numberWithDouble:d];
    return value;
}

- (NSComparisonResult)compare:(Participant *)otherObject {
    return [self.getSumOfResults compare:otherObject.getSumOfResults];
}

@end
