//
//  SimplePickerInputTableViewCell.m
//  PickerCellDemo
//
//  Created by Tom Fewster on 10/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SimplePickerInputTableViewCell.h"
#import "Usuarios.h"
#import "Usuario.h"

@implementation SimplePickerInputTableViewCell

@synthesize delegate;
@synthesize value;

__strong NSArray *values = nil;

+ (void)initialize {
    values = [NSArray arrayWithArray:[Usuarios obtener]];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
		self.picker.delegate = self;
		self.picker.dataSource = self;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
		self.picker.delegate = self;
		self.picker.dataSource = self;
    }
    return self;
}

- (void)setValue:(NSString *)v {
	value = v;
	self.detailTextLabel.text = value;
    
    NSMutableArray * tipos = [[NSMutableArray alloc] init];
    
    for (Usuario *usuario in values) {
        [tipos addObject:usuario.tipo];
    }
    

    
	[self.picker selectRow:[tipos indexOfObject:value] inComponent:0 animated:YES];
    tipos = nil;
}

#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [values count];
}

#pragma mark -
#pragma mark UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	Usuario *usuario = [values objectAtIndex:row];
    return usuario.tipo;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
	return 44.0f;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	return 300.0f; //pickerView.bounds.size.width - 20.0f;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    Usuario *usuario = [values objectAtIndex:row];
    self.value = usuario.tipo;
    

	if (delegate && [delegate respondsToSelector:@selector(tableViewCell:didEndEditingWithValue:)]) {
		[delegate tableViewCell:self didEndEditingWithValue:usuario];
	}
}

@end
