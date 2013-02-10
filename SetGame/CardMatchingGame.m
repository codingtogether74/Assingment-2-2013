//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Tatiana Kornilova on 1/30/13.
//  Copyright (c) 2013 Tatiana Kornilova. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame ()

@property (readwrite, nonatomic) int score;
@property (readwrite,nonatomic) int flipPoints;
@property (strong,nonatomic) NSMutableArray *cards; // of Card
@property (readwrite,nonatomic) NSString *flipResult;
@property (readwrite,nonatomic) NSArray *matchedCards;


@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) _cards =[[NSMutableArray alloc] init];
    return _cards;
}


- (NSString *)flipResult
{
    if (!_flipResult) _flipResult =@"";
    return _flipResult;
}

- (NSArray *)matchedCards
{
    if (!_matchedCards) {
        _matchedCards = [[NSMutableArray alloc] init];
    }
    return _matchedCards;
}


#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST  1

- (void)flipCardAtIndex:(NSInteger)index
{
    self.flipResult = @"";
    self.flipPoints = 0;
    Card *card = [self cardAtIndex: index];
    if (card && !card.isUnplayable) {
        if (!card.isFaceUp) {
            self.flipPoints=-FLIP_COST;
            self.flipResult =@"Flipped up";
            self.matchedCards =[NSArray  arrayWithObject:card];
            self.score -= FLIP_COST;
            //----------------------Begin of loop for self.cards-----------------------------------------
            NSMutableArray *faceUpCards = [[NSMutableArray alloc] init];
            
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {  //----- if 2
                    [faceUpCards addObject:otherCard];
                    // ------decision on match ----------
                    if ([faceUpCards count]== (self.gameLevel -1)) {
                        [faceUpCards addObject:card];
                        int matchScore = [card match:faceUpCards];
                        if (matchScore) {
                            card.Unplayable =YES;
                            for (Card *faceUpCard in faceUpCards) {
                                faceUpCard.Unplayable = YES;
                            }
                            self.score += matchScore*MATCH_BONUS;
                            self.flipResult =@"Matched";
                            self.flipPoints = matchScore *MATCH_BONUS;
                        } else {
                            for (Card *faceUpCard in faceUpCards) {
                                if (faceUpCard != card) faceUpCard.faceUp = NO;
                            }
                            self.score -= MISMATCH_PENALTY;
                            self.flipResult =@"don't match";
                            self.flipPoints = MISMATCH_PENALTY;
                        }
                        self.matchedCards =[NSArray arrayWithArray:faceUpCards];
                        break;
                    }
                    // ------decision on match ----------
                }//-------- if 2
                
            }   //-- for
            //----------------------End of loop for self.cards-----------------------------------------
        }
        card.faceUp = !card.faceUp;
    }
}


- (Card *)cardAtIndex:(NSInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck andGameLevel:(int)gameLevel
{
    self = [super init];
    if (self) {
        for (int i =0; i< count; i++) {
            Card *card = [deck drawRandomCard];
            if(card) {
                self.cards[i] =card;
            }else {
                self =nil;
                break;
            }
            
        }
        self.gameLevel = gameLevel;
    }
    return self;
}
@end
