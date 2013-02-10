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
@end
