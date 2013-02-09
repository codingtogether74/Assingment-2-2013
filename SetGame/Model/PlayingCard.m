//
//  PlayingCard.m
//  Matchismo
//
//  Created by Tatiana Kornilova on 1/29/13.
//  Copyright (c) 2013 Tatiana Kornilova. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard
@synthesize suit =_suit;     // because we provide setter AND getter

-(int)match:(NSArray *)otherCards
{
    int score =0;
    int numMatches = 0;
    if ([otherCards count] > 0)
    {
        for (int i = 0; i < [otherCards count]; i++) {
            id otherCard1 = otherCards[i];
            if ([otherCard1 isKindOfClass:[PlayingCard class]])
            {
                PlayingCard *card1 = (PlayingCard *)otherCard1;
                
                for (int j = i+1; j < [otherCards count]; j++) {
                    id otherCard2 =otherCards[j];
                    if ([otherCard2 isKindOfClass:[PlayingCard class]])
                    {
                        PlayingCard *card2 =(PlayingCard *)otherCard2;
                        
                        // check for the same suit
                        if ([card1.suit isEqualToString:card2.suit]) {
                            score += 1;
                            numMatches++;
                        }
                        // check for the same rank
                        if (card1.rank == card2.rank) {
                            score += 4;
                            numMatches++;
                        }
                    }
                }
            }
        }
        
        if (numMatches < [otherCards count] -1) score = 0;
    }
    return score;
}

- (NSString *)contents
{
    return [[PlayingCard rankStrings][self.rank] stringByAppendingString:self.suit ];
}
+ (NSArray *)validSuits
{
    static NSArray *validSuits =nil;
    if (!validSuits) validSuits = @[@"♥",@"♦",@"♠",@"♣"];
    return validSuits;
}
- (void)setSuit:(NSString *)suit {
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit =suit;
    }
}
- (NSString *)suit {
    return _suit ? _suit : @"?";
}

+(NSArray *)rankStrings
{
    static NSArray *rankStrings =nil;
    if (!rankStrings) rankStrings = @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
    return rankStrings;
}
+ (NSInteger)maxRank { return [self rankStrings].count-1;}

-(void)setRank:(NSInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank =rank;
    }
}


@end
