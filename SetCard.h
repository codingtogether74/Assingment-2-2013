//
//  SetCard.h
//  SetGame
//
//  Created by Tatiana Kornilova on 2/9/13.
//  Copyright (c) 2013 Tatiana Kornilova. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (strong, nonatomic) NSString *shape;
@property (strong,nonatomic) NSString *color;
@property (strong,nonatomic) NSString *shading;
@property (nonatomic) int rank;



+ (NSArray *)validShapes;
+ (NSArray *)validColors;
+ (NSArray *)validShadings;
+ (int)maxRank;

@end
