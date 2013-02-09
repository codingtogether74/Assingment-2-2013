//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Tatiana Kornilova on 1/30/13.
//  Copyright (c) 2013 Tatiana Kornilova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "Deck.h"

@interface CardMatchingGame : NSObject

// designated initializer
- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck andGameLevel:(int) gameLevel;

- (void)flipCardAtIndex:(NSInteger)index;
- (Card *)cardAtIndex:(NSInteger)index;

@property (readonly,nonatomic) int score;
@property (readonly,nonatomic) NSString *resultOfFlip;

@end
