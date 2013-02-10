//
//  SetCard.m
//  SetGame
//
//  Created by Tatiana Kornilova on 2/9/13.
//  Copyright (c) 2013 Tatiana Kornilova. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

@synthesize shape =_shape;
@synthesize color =_color;
@synthesize shading =_shading;

- (NSString *)contents
{
    NSString *cardString = [@"" stringByPaddingToLength:self.rank withString: self.shape startingAtIndex:0];
    return cardString;
}

- (void)setShading:(NSString *)shading {
    if ([[SetCard validShadings] containsObject:shading]) {
        _shading =shading;
    }
}
- (NSString *)shading {
    return _shading ? _shading : @"filled";
}

- (void)setColor:(NSString *)color {
    if ([[SetCard validColors] containsObject:color]) {
        _color =color;
    }
}
- (NSString *)color {
    return _color ? _color : @"red";
}

- (void)setShape:(NSString *)shape {
    if ([[SetCard validShapes] containsObject:shape]) {
        _shape =shape;
    }
}
- (NSString *)shape {
    return _shape ? _shape : @"▲";
}

-(void)setRank:(int)rank
{
    if (rank <= [SetCard maxRank] && rank >0) {
        _rank =rank;
    }else if (rank>[SetCard maxRank]){
        _rank=[SetCard maxRank];
    }else {
        _rank =1;
    }
}

+ (NSArray *)validShapes
{
    static NSArray *validShapes =nil;
    if (!validShapes) validShapes = @[@"▲",@"●",@"■"];
    return validShapes;
}

+ (NSArray *)validColors
{
    static NSArray *validColors =nil;
    if (!validColors) validColors = @[@"red",@"green",@"purple"];
    return validColors;
}
+ (NSArray *)validShadings
{
    static NSArray *validShadings =nil;
    if (!validShadings) validShadings = @[@"filled",@"outlined",@"striped"];
    return validShadings;
}

+ (int)maxRank{ return 3;}


@end
