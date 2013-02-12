//
//  SetGameViewController.m
//  SetGame
//
//  Created by Tatiana Kornilova on 2/9/13.
//  Copyright (c) 2013 Tatiana Kornilova. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCardDeck.h"
#import "CardMatchingGame.h"
#import "CardGameViewController.h"
#import "SetCard.h"

@interface SetGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@end

@implementation SetGameViewController
@synthesize game=_game;

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

-(void)updateCardButton:(UIButton *)cardButton forCard:(Card *)card
{
    if (card.isFaceUp) {
        cardButton.backgroundColor = [UIColor colorWithRed: 0.0 green:0.2 blue:0.4 alpha:0.1];
    } else {
        cardButton.backgroundColor = nil;
    }
    cardButton.alpha = card.isUnplayable ? 0.0 : 1.0;
}

-(NSString *)textForFlipResult{
     NSString *text=@"";
    if ([self.game.matchedCards count]>1) {
        if ([self.game.flipResult isEqualToString:@"don't match"]) {
            text = [NSString stringWithFormat:@"don't match! (%d penalty)",self.game.flipPoints];
        } else {
            text = [NSString stringWithFormat:@"match! %d points bonus",self.game.flipPoints];
        }
    } else {
        SetCard *card = [self.game.matchedCards lastObject];
        text = [NSString stringWithFormat:@"%@",(card.isFaceUp) ? @"selected!" : @"de-selected!"];
    }
    
    return text;
}

- (CardMatchingGame *)game
{
    if (!_game) _game =  [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                           usingDeck:[[SetCardDeck alloc]init]
                                                        andGameLevel:3];
    _game.gameLevel =3;
    return _game;
    
}
@end
