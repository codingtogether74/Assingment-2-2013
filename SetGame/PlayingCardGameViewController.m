//
//  PlayingCardGameViewController.m
//  SetGame
//
//  Created by Tatiana Kornilova on 2/15/13.
//  Copyright (c) 2013 Tatiana Kornilova. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}
- (NSAttributedString *)cardAttributedContents:(Card *)card forFaceUp:(BOOL)isFaceUp
{
    NSDictionary *cardAttributes = @{};
    NSString *textToDisplay = (isFaceUp) ? card.contents: @" ";
    NSAttributedString *cardContents = [[NSAttributedString alloc] initWithString:textToDisplay attributes:cardAttributes];
    return cardContents;
}

-(void)updateCardButton:(UIButton *)cardButton 
{
    Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
    cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
    UIImage *backImage = [UIImage imageNamed:@"Lotus.jpg"];
    if (backImage){
        if (!card.isFaceUp){
            [cardButton setImage:backImage forState:UIControlStateNormal];
            cardButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        } else {
            [cardButton setImage:nil forState:UIControlStateNormal];
        }
        [cardButton setImage:nil forState:UIControlStateSelected|UIControlStateDisabled];
    }
}
- (NSString *)textForSingleCard
{
    Card *card = [self.game.matchedCards lastObject];
    return [NSString stringWithFormat:@"flipped %@",(card.isFaceUp) ? @"up!" : @"back!"];
}


@end
