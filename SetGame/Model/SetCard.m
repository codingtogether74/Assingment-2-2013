//
//  SetCard.m
//  SetGame
//
//  Created by Tatiana Kornilova on 2/9/13.
//  Copyright (c) 2013 Tatiana Kornilova. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard
@synthesize shape=_shape;

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    int symbolSum = 0;
    int rankSum = 0;
    int shadingSum = 0;
    int colorSum = 0;
    
    if (otherCards.count==3) {
        
        for (SetCard *otherCard in otherCards) {
            symbolSum+=[[SetCard validShapes ] indexOfObject:otherCard.shape]+1;
            rankSum+=otherCard.rank;
            shadingSum+=otherCard.shading;
            colorSum+=otherCard.color;
        }
        
        if ((symbolSum%3==0)&&(rankSum%3==0)&&(shadingSum%3==0)&&(colorSum%3==0))
            score = 1;
    }
    return score;
}


- (NSString *)contents
{
    NSString *cardString = [@"" stringByPaddingToLength:self.rank withString: self.shape startingAtIndex:0];
    return cardString;
}


- (void)setShape:(NSString *)shape {
    if ([[SetCard validShapes] containsObject:shape]) {
        _shape =shape;
    }
}
- (NSString *)shape {
    return _shape ? _shape : @"▲";
}


+ (NSArray *)validShapes
{
    static NSArray *validShapes =nil;
    if (!validShapes) validShapes = @[@"▲",@"●",@"■"];
    return validShapes;
}


@end
