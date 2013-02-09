//
//  Card.h
//  Matchismo
//
//  Created by Tatiana Kornilova on 1/28/13.
//  Copyright (c) 2013 Tatiana Kornilova. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong,nonatomic) NSString *contents;

@property (nonatomic,  getter = isFaceUp) BOOL faceUp;
@property (nonatomic,  getter = isUnplayable) BOOL unplayable;
@property (nonatomic, weak) NSString *description;


-(int)match:(NSArray *)otherCard;
@end
