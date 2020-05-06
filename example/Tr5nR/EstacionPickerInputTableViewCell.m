//
//  EstacionPickerInputTableViewCell.m
//  PickerCellDemo
//
//  Created by Tom Fewster on 10/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EstacionPickerInputTableViewCell.h"
#import "Estaciones.h"

@interface EstacionPickerInputTableViewCell()

@end

@implementation EstacionPickerInputTableViewCell

@synthesize delegate;
@synthesize value;

__strong NSArray *estaciones = nil;

+ (void) initialize{
    estaciones = [NSArray arrayWithArray:[Estaciones obtener]];
    
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

// Selecciona el en el picker el elemento guardado en el NSUserDefaults
- (void) marcarSeleccion{
    NSMutableArray *nombres = [[NSMutableArray alloc] init];
    
    for(Estacion *estacion in estaciones){
        [nombres addObject:estacion.nombre];
    }
    
	[self.picker selectRow:[nombres indexOfObject:value] inComponent:0 animated:YES];
    
    nombres = nil;
}

- (void)setValue:(NSString *)v {
	value = v;
	
    self.detailTextLabel.text = value;

    [self marcarSeleccion];
    
}

#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [estaciones count];
}

#pragma mark -
#pragma mark UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    Estacion *estacion = [estaciones objectAtIndex:row];
	return estacion.nombre;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
	return 44.0f;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	return 300.0f; //pickerView.bounds.size.width - 20.0f;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
	Estacion *estacion = [estaciones objectAtIndex:row];
    self.value = estacion.nombre;

    
	if (delegate && [delegate respondsToSelector:@selector(tableViewCell: didEndEditingWithEstacion:)]) {
       
		[delegate tableViewCell:self didEndEditingWithEstacion:estacion];
	}
}


@end
