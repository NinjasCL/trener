//
//  Horarios.h
//  Tr5nR
//
//  Created by Camilo on 09-12-12.
//  Copyright (c) 2012 Camilo Castro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Horario.h"
#import "TiposDia.h"

@interface Horarios : NSObject
+ (NSNumber *) tiempoRestante:(NSDate *) fecha;
+ (NSArray *) proximosTrenes;
//+ (Horario *) proximosTrenes;
@end
