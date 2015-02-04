//
//  Participant.h
//  Lab01-Ski
//
//  Created by Bigras, Renaud on 2015-02-04.
//  Copyright (c) 2015 Legault, Mathieu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Result.h"

@interface Participant : NSObject
{
    NSString *nom;
    NSString *prenom;
    NSString *pays;
    int partId;
    NSMutableArray *resultats;
}

-(void) setNom: (NSString*) s;
-(void) setPrenom: (NSString*) s;
-(void) setPays: (NSString*) s;
-(void) setId: (int) i;
-(void) setTime: (NSTimeInterval*) t;
-(void) addResult: (Result*) r;
-(NSString*) getNom;
-(NSString*) getPrenom;
-(NSString*) getPays;
-(int) getId;
-(NSMutableArray*) getResultats;
-(void) getSumOfResults;


@end
