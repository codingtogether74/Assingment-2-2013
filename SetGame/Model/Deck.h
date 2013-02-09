//
//  Deck.h
//  Matchismo
//
//  Created by Tatiana Kornilova on 1/28/13.
//  Copyright (c) 2013 Tatiana Kornilova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void) addCard:(Card *)card atTop:(BOOL)atTop;
- (Card *)drawRandomCard;

@end
