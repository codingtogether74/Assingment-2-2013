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
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipResult;
@property (weak, nonatomic) IBOutlet UISlider *timeSlider;
@property (weak, nonatomic) IBOutlet UILabel *sliderMaxLabel;
@property (weak, nonatomic) IBOutlet UIButton *dealButton;
@end

@implementation SetGameViewController

@synthesize game = _game;

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
    [cardButton setAttributedTitle:[self cardAttributedContents:card forFaceUp:NO] forState:UIControlStateNormal];
    [cardButton setAttributedTitle:[self cardAttributedContents:card forFaceUp:YES] forState:UIControlStateSelected];
    [cardButton setAttributedTitle:[self cardAttributedContents:card forFaceUp:YES] forState:UIControlStateSelected|UIControlStateDisabled];
    cardButton.selected = card.isFaceUp;
    cardButton.enabled = !card.isUnplayable;
    cardButton.alpha = card.isUnplayable ? self.unplayableAlpha : 1.0;
    if (self.highlightSelectedCard) {
        if (card.isFaceUp) {
            cardButton.backgroundColor = [UIColor colorWithRed: 0.0 green:0.2 blue:0.4 alpha:0.1];
        } else {
            cardButton.backgroundColor = nil;
        }
    }
    
}

- (void)updateFlipResult
{
    if (self.game.matchedCards) {
        NSMutableAttributedString *cardsMatched = [[NSMutableAttributedString alloc] init];
        NSAttributedString *space = [[NSAttributedString alloc] initWithString:@"&"];
        NSString *text;
        for (SetCard *card in self.game.matchedCards) {
            [cardsMatched appendAttributedString:[self cardAttributedContents:card forFaceUp:NO]];
            [cardsMatched appendAttributedString:space];
        }

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

        [cardsMatched appendAttributedString:[[NSAttributedString alloc] initWithString:text]];
 
        self.flipResult.attributedText = cardsMatched;
    } else
        self.flipResult.attributedText = [[NSAttributedString alloc] initWithString:@"Play Set game!"];
}

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:[[SetCardDeck alloc]init]
                                               andGameLevel:self.gameLevel];
        _game.gameLevel =3;
    }
    return _game;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	self.unplayableAlpha = 0.0;
    self.highlightSelectedCard = YES;

}
@end
