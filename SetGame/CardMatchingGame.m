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
@property (strong,nonatomic) NSMutableArray *cards; // of Card
@property (readwrite,nonatomic) NSString *resultOfFlip;
@property (nonatomic) int gameLevel;
@property (strong,nonatomic) NSMutableArray *faceUpCards; // of otherCard

@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
        if (!_cards) _cards =[[NSMutableArray alloc] init];
        return _cards;
}

- (NSMutableArray *)faceUpCards
{
    if (!_faceUpCards) _faceUpCards =[[NSMutableArray alloc] init];
    return _faceUpCards;
}


- (NSString *)resultOfFlip
{
    if (!_resultOfFlip) _resultOfFlip =@"";
    return _resultOfFlip;
}

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST  1

- (void)flipCardAtIndex:(NSInteger)index
{
    self.resultOfFlip = @"";
    Card *card = [self cardAtIndex: index];
    [self.faceUpCards removeAllObjects];
    
    if (card && !card.isUnplayable) {
        self.resultOfFlip =[NSString stringWithFormat:@"Flipped down"];
        if (!card.isFaceUp) {                                 //------ if 1
            self.resultOfFlip =[NSString stringWithFormat:@"Flipped up %@! %d point minus",card.contents,FLIP_COST];
            
            //----------------------Begin of cicle for self.cards-----------------------------------------
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {  //----- if 2
                    [self.faceUpCards addObject:otherCard];
                    // ------decision on match ----------
                    if ([self.faceUpCards count]== (self.gameLevel -1)) {
                        [self.faceUpCards addObject:card];
                        int matchScore = [card match:self.faceUpCards];
                        if (matchScore) {
                            card.Unplayable =YES;
                            
                            for (Card *faceUpCard in self.faceUpCards) {
                                faceUpCard.Unplayable = YES;
                            }
                            self.score += matchScore*MATCH_BONUS;
                            NSString *matches =[self.faceUpCards componentsJoinedByString:@"&"];
                            self.resultOfFlip =[NSString stringWithFormat:@"Matched %@ for %d points ",matches,matchScore *MATCH_BONUS];
                            
                        }else {
                            for (Card *faceUpCard in self.faceUpCards) {
                                if (faceUpCard != card) faceUpCard.faceUp = NO;
                            }
                            self.score -= MISMATCH_PENALTY;
                            NSString *matches =[self.faceUpCards componentsJoinedByString:@"&"];
                            self.resultOfFlip =[NSString stringWithFormat:@"%@ don't match! %d point penalty ",matches,MISMATCH_PENALTY];
                        }
                        break;
                    }
                    // ------decision on match ----------
                }    //-------- if 2
            }   //-- for
            //----------------------End of cicle for self.cards-----------------------------------------
            
            self.score -= FLIP_COST;
        }                                        //------- if 1
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
        [self.faceUpCards removeAllObjects];
    }
    return self;
}
@end
