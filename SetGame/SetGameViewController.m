//
//  SetGameViewController.m
//  SetGame
//
//  Created by Tatiana Kornilova on 2/9/13.
//  Copyright (c) 2013 Tatiana Kornilova. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCardDeck.h"

@interface SetGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@end

@implementation SetGameViewController

- (Deck *)createDeck
{
    self.gameLevel =3;
    return [[SetCardDeck alloc] init];
}

- (NSAttributedString *)cardAttributedContents:(Card *)card forFaceUp:(BOOL)isFaceUp
{
    NSArray *colorPallette = @[[UIColor redColor],[UIColor greenColor],[UIColor purpleColor]];
    NSArray *alphaPallette = @[@0,@0.2,@1];
    UIColor *cardOutlineColor = colorPallette[((SetCard *)card).color-1];
    UIColor *cardColor = [cardOutlineColor colorWithAlphaComponent:(CGFloat)[alphaPallette[((SetCard *)card).shading-1] floatValue]];
    NSDictionary *cardAttributes = @{NSForegroundColorAttributeName : cardColor, NSStrokeColorAttributeName : cardOutlineColor, NSStrokeWidthAttributeName: @-5};
    NSString *textToDisplay = card.contents;
    NSAttributedString *cardContents = [[NSAttributedString alloc] initWithString:textToDisplay attributes:cardAttributes];
    return cardContents;
}

-(void)updateCardButton:(UIButton *)cardButton 
{
    Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
    if (card.isFaceUp) {
        cardButton.backgroundColor = [UIColor colorWithRed: 0.0 green:0.2 blue:0.4 alpha:0.1];
    } else {
        cardButton.backgroundColor = nil;
    }
    cardButton.alpha = card.isUnplayable ? 0.0 : 1.0;
}

- (NSString *)textForSingleCard
{
    Card *card = [self.game.matchedCards lastObject];
    return [NSString stringWithFormat:@"%@",(card.isFaceUp) ? @"selected!" : @"de-selected!"];
}

@end
