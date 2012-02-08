//
//  Utility.h
//  Quotify
//
//  Created by Max Rosenblatt on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

+ (int)getNumber;
+ (void)setNumber:(int)number;
+ (void)resizeFontForLabel:(UILabel*)aLabel maxSize:(int)maxSize minSize:(int)minSize;

@end
