//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Tatiana Kornilova on 1/29/13.
//  Copyright (c) 2013 Tatiana Kornilova. All rights reserved.
//

#import "CardGameViewController.h"

#import "PlayingCard.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property(nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong,nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultOfFlip;
@property (nonatomic) int gameLevel;
@property (weak, nonatomic) IBOutlet UISlider *timeSlider;
@property (nonatomic, strong) NSMutableArray *flipsHistory;
@property (nonatomic) float sliderValue;
@property (nonatomic) float sliderMaxValue;
@property (weak, nonatomic) IBOutlet UILabel *sliderMaxLabel;


@end

@implementation CardGameViewController

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[[PlayingCardDeck alloc]init]
                                                       andGameLevel:self.gameLevel];
    return _game;
    
}

-(int)gameLevel
{
    if(!_gameLevel || _gameLevel <2 ) _gameLevel =2;
    return _gameLevel;
}

-(void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

- (NSMutableArray *) flipsHistory
{
    if (!_flipsHistory) _flipsHistory = [[NSMutableArray alloc] init];
    return _flipsHistory;
}

#define MAX_SLIDER 50.0f
#define INC_SLIDER 20.0f


-(void)updateUI
{
    UIImage *cardBackImage = [UIImage imageNamed:@"Lotus.jpg"];
    for (UIButton *cardButton  in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        if (!card.isFaceUp){
            [cardButton setImage:cardBackImage forState:UIControlStateNormal];
            cardButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        } else {
            [cardButton setImage:nil forState:UIControlStateNormal];
        }
        cardButton.selected = card.faceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = (card.isUnplayable ? 0.3 : 1.0);
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.resultOfFlip.text = [NSString stringWithFormat:@"%@", self.game.resultOfFlip];
    
    [self.timeSlider setMinimumValue:0.0f];
    self.sliderMaxValue += (self.sliderMaxValue>self.flipCount) ? 0.0f : INC_SLIDER;
    [self.timeSlider setMaximumValue:self.sliderMaxValue];
    self.sliderMaxLabel.text = [NSString stringWithFormat:@"%d",(int)ceilf(self.sliderMaxValue)];

    
    [self.timeSlider setValue: self.sliderValue animated:YES];
    
}

-(void) setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d",self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender
{
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    [self.flipsHistory addObject:self.game.resultOfFlip];
    self.sliderValue++;
    self.resultOfFlip.alpha = 1.0;
    [self updateUI];


    
}
- (IBAction)pressDeal:(id)sender
{
    self.game = nil;
    self.flipCount =0;
    self.flipsHistory = nil;
    self.sliderValue=0;
    self.sliderMaxValue =MAX_SLIDER;
    [self updateUI];
}

-(float)sliderMaxValue
{
    if(!_sliderMaxValue ) _sliderMaxValue =MAX_SLIDER;
    self.sliderMaxLabel.text = [NSString stringWithFormat:@"%D",(int)ceilf(MAX_SLIDER)];
    return _sliderMaxValue;
}

- (IBAction)timeChanged:(UISlider *)sender
{
    int selectedIndex = (int) sender.value;
    
    if (selectedIndex < 0 || (selectedIndex > self.flipCount - 1)) return;

    self.resultOfFlip.alpha = (selectedIndex < self.flipCount-1) ? 0.3 : 1.0;
    self.resultOfFlip.text = [self.flipsHistory objectAtIndex: selectedIndex];
   
}

@end
