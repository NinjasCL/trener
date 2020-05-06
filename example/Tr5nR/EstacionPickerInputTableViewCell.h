//
//  EstacionPickerInputTableViewCell.h
//  PickerCellDemo
//
//  Created by Tom Fewster on 10/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PickerInputTableViewCell.h"
#import "Estacion.h"

@class EstacionPickerInputTableViewCell;

@protocol EstacionPickerInputTableViewCellDelegate <NSObject>
@required
- (void)tableViewCell:(EstacionPickerInputTableViewCell *)cell didEndEditingWithEstacion:(Estacion *)estacion;
@end

@interface EstacionPickerInputTableViewCell : PickerInputTableViewCell <UIPickerViewDataSource, UIPickerViewDelegate> {
	NSString *value;
}

@property (nonatomic, strong) NSString *value;
@property (weak) IBOutlet id <EstacionPickerInputTableViewCellDelegate> delegate;

@end
