//
//  IntegerInputTableViewCell.h
//  InputTest
//
//  Created by Tom Fewster on 18/10/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DoubleInputTableViewCell;

@protocol DoubleInputTableViewCellDelegate <NSObject>
@optional
- (void)tableViewCell:(DoubleInputTableViewCell *)cell didEndEditingWithDouble:(double)value;
@end

@interface DoubleInputTableViewCell : UITableViewCell <UIKeyInput, UITextInputTraits> {
	double numberValue;
	BOOL valueChanged;
	double lowerLimit;
	double upperLimit;
	
	UIToolbar *inputAccessoryView;
	UIEdgeInsets originalContentInsets;
	UIEdgeInsets originalScrollInsets;
}

@property (nonatomic, assign) double numberValue;
@property (nonatomic, assign) double lowerLimit;
@property (nonatomic, assign) double upperLimit;
@property (nonatomic, strong) NSNumberFormatter *numberFormatter;
@property (weak) IBOutlet id<DoubleInputTableViewCellDelegate> delegate;

@property(nonatomic) UITextAutocapitalizationType autocapitalizationType;
@property(nonatomic) UITextAutocorrectionType autocorrectionType;
@property(nonatomic) BOOL enablesReturnKeyAutomatically;
@property(nonatomic) UIKeyboardAppearance keyboardAppearance;
@property(nonatomic) UIKeyboardType keyboardType;
@property(nonatomic) UIReturnKeyType returnKeyType;
@property(nonatomic, getter=isSecureTextEntry) BOOL secureTextEntry;
@property(nonatomic) UITextSpellCheckingType spellCheckingType;

@end
