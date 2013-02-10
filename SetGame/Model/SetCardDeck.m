//
//  SetCardDeck.m
//  SetGame
//
//  Created by Tatiana Kornilova on 2/9/13.
//  Copyright (c) 2013 Tatiana Kornilova. All rights reserved.
//

#import "SetCardDeck.h"

@implementation SetCardDeck

-(id)init
{
    self = [super init];
    if (self) {
        for (NSString *shape in [SetCard validShapes]) {
            for (NSUInteger rank=1; rank<=3; rank++) {
                for (NSUInteger color=1; color<=3 ;color++) {
                    for (NSUInteger shading=1; shading<=3; shading++) {
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
