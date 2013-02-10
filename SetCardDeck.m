//
//  SetCardDeck.m
//  SetGame
//
//  Created by Tatiana Kornilova on 2/9/13.
//  Copyright (c) 2013 Tatiana Kornilova. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

-(id)init
{
    self = [super init];
    if (self) {
        for (NSString *shape in [SetCard validShapes]) {
            for (int rank=1; rank<=[SetCard maxRank]; rank++) {
                for (NSString *color in [SetCard validColors]) {
                    for (NSString *shading in [SetCard validShadings]) {
                        
                        SetCard *card =[[SetCard alloc] init];
                        card.rank =rank;
                        card.shape =shape;
                        card.color =color;
                        card.shading =shading;
                        [self addCard:card atTop:NO];
                    }
                    
                }
            }
        }
    }
    return self;
}

@end
