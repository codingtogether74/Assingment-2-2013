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

@interface CardGameViewController ()

@property(nonatomic) int flipCount;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipResult;
@property (weak, nonatomic) IBOutlet UISlider *timeSlider;
@property (nonatomic, strong) NSMutableArray *flipsHistory;
@property (weak, nonatomic) IBOutlet UIButton *dealButton;
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


- (NSAttributedString *)cardAttributedContents:(Card *)card forFaceUp:(BOOL)isFaceUp
{
    NSDictionary *cardAttributes = @{};
    NSString *textToDisplay = (isFaceUp) ? card.contents: @"";
    NSAttributedString *cardContents = [[NSAttributedString alloc] initWithString:textToDisplay attributes:cardAttributes];
    return cardContents;
}

-(void)updateCardButton:(UIButton *)cardButton forCard:(Card *)card
{
    [cardButton setTitle:card.contents forState:UIControlStateSelected];
    [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
    cardButton.selected = card.isFaceUp;
    cardButton.enabled = !card.isUnplayable;
    cardButton.alpha = card.isUnplayable ? self.unplayableAlpha : 1.0;
    if (self.highlightSelectedCard) {
        if (card.isFaceUp) {
            cardButton.backgroundColor = [UIColor lightGrayColor];
        } else {
            cardButton.backgroundColor = nil;
        }
    }
    UIImage *backImage = [UIImage imageNamed:@"Lotus.jpg"];
    if (backImage){
        if (!card.isFaceUp){
            [cardButton setImage:backImage forState:UIControlStateNormal];
            cardButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        } else {
            [cardButton setImage:nil forState:UIControlStateNormal];
        }
    }
}

-(void)updateUI
{
    for (UIButton *cardButton  in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [self updateCardButton:cardButton forCard:card];
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    [self.timeSlider setMinimumValue:0.0f];
    self.sliderMaxValue += (self.sliderMaxValue>self.flipCount) ? 0.0f : INC_SLIDER;
    [self.timeSlider setMaximumValue:self.sliderMaxValue];
    self.sliderMaxLabel.text = [NSString stringWithFormat:@"%d",(int)ceilf(self.sliderMaxValue)];
    [self updateFlipResult];
    [self.timeSlider setValue: self.sliderValue animated:YES];
    
}

-(void)updateFlipResult
{
    NSString *matches =@"";
    if ([self.game.matchedCards count]>0)
        matches =[self.game.matchedCards componentsJoinedByString:@"&"];
    if ([self.game.flipResult isEqualToString:@"Matched"]) {
        self.flipResult.text =  [NSString stringWithFormat:@"%@ %@ %d points bonus", self.game.flipResult,matches,self.game.flipPoints];
    }else if ([self.game.flipResult isEqualToString:@"don't match"]) {
        self.flipResult.text =  [NSString stringWithFormat:@"%@ %@ !! penalty %d points",matches, self.game.flipResult,self.game.flipPoints];
    }else if ([self.game.flipResult isEqualToString:@"Flipped up"]) {
        self.flipResult.text =  [NSString stringWithFormat:@"%@ %@ !! penalty %d points",self.game.flipResult, matches, self.game.flipPoints];
    } else
        self.flipResult.text =   @"";
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
    self.sliderValue++;
    self.flipResult.alpha = 1.0;
    [self updateUI];
    [self.flipsHistory addObject:self.flipResult.text];
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
    
    self.flipResult.alpha = (selectedIndex < self.flipCount-1) ? 0.3 : 1.0;
    self.flipResult.text = [self.flipsHistory objectAtIndex: selectedIndex];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.unplayableAlpha = 0.3;
    self.highlightSelectedCard = NO;
}
@end
