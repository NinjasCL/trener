//
//  RealizarViaje.h
//  Tr5nR
//
//  Created by Camilo on 15-11-12.
//  Copyright (c) 2012 Camilo Castro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EstacionPickerInputTableViewCell.h"
@interface RealizarViaje : UITableViewController <EstacionPickerInputTableViewCellDelegate>
+ (void) activarRecargarDatos;
@end
