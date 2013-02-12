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

@property (weak, nonatomic) IBOutlet UISlider *timeSlider;
@property (nonatomic, strong) NSMutableArray *flipsHistory;
@property (nonatomic, strong) NSMutableArray *flipsAttributedHistory;
@property (nonatomic) float sliderValue;
@property (nonatomic) float sliderMaxValue;
@property (weak, nonatomic) IBOutlet UILabel *sliderMaxLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;

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
- (NSMutableArray *) flipsAttributedHistory
{
    if (!_flipsAttributedHistory) _flipsAttributedHistory = [[NSMutableArray alloc] init];
    return _flipsAttributedHistory;
}

#define MAX_SLIDER 50.0f
#define INC_SLIDER 20.0f


- (NSAttributedString *)cardAttributedContents:(Card *)card forFaceUp:(BOOL)isFaceUp
{
    NSDictionary *cardAttributes = @{};
    NSString *textToDisplay = (isFaceUp) ? card.contents: @" ";
    NSAttributedString *cardContents = [[NSAttributedString alloc] initWithString:textToDisplay attributes:cardAttributes];
    return cardContents;
}

-(void)updateCardButton:(UIButton *)cardButton forCard:(Card *)card
{
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

-(void)updateUI
{
    for (UIButton *cardButton  in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setAttributedTitle:[self cardAttributedContents:card forFaceUp:NO] forState:UIControlStateNormal];
        [cardButton setAttributedTitle:[self cardAttributedContents:card forFaceUp:YES] forState:UIControlStateSelected];
        [cardButton setAttributedTitle:[self cardAttributedContents:card forFaceUp:YES] forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
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

-(NSString *)textForFlipResult{
    NSString *text=@"";
    NSString *matches =@"";
    if (self.game.matchedCards ){
        if ([self.game.matchedCards count]>0) matches =[self.game.matchedCards componentsJoinedByString:@" "];
        if ([self.game.flipResult isEqualToString:@"Matched"]) {
            text =  [NSString stringWithFormat:@"%@ %@ %d points bonus", self.game.flipResult,matches,self.game.flipPoints];
        }else if ([self.game.flipResult isEqualToString:@"don't match"]) {
            text =  [NSString stringWithFormat:@"%@ %@ !! penalty %d points",matches, self.game.flipResult,self.game.flipPoints];
        }else if ([self.game.flipResult isEqualToString:@"Flipped up"]) {
            text =  [NSString stringWithFormat:@"%@ %@ !! penalty %d points",self.game.flipResult, matches, self.game.flipPoints];
        } else {
            Card *card = [self.game.matchedCards lastObject];
            text = [NSString stringWithFormat:@"%@ %@",self.game.flipResult,card];
        }
    }
   
    return text;
}
-(NSMutableAttributedString *)attributedStringForFlipResult{
    NSMutableAttributedString *cardsMatched = [[NSMutableAttributedString alloc] init];
    NSAttributedString *space = [[NSAttributedString alloc] initWithString:@" "];
    
    for (Card *card in self.game.matchedCards) {
        [cardsMatched appendAttributedString:[self cardAttributedContents:card forFaceUp:NO]];
        [cardsMatched appendAttributedString:space];
    }
    return cardsMatched;
}

-(void)updateFlipResult
{
    if (self.game.matchedCards) {
        NSMutableAttributedString *cardsMatched = [self attributedStringForFlipResult];
        NSString *text=[self textForFlipResult];
        [cardsMatched appendAttributedString:[[NSAttributedString alloc] initWithString:text]];
        self.flipResult.attributedText = cardsMatched;
    } else
        self.flipResult.attributedText = [[NSAttributedString alloc] initWithString:@"Play game!"];
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
    [self.flipsAttributedHistory addObject:self.flipResult.attributedText];
}

- (IBAction)pressDeal:(UIButton *)sender
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
    
    self.flipResult.alpha = (selectedIndex < self.flipCount-1) ? 0.5 : 1.0;
    self.flipResult.attributedText =[self.flipsAttributedHistory objectAtIndex: selectedIndex]; ;
    
}

@end
