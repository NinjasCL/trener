//
//  Operaciones.h
//  Tr5nR
//
//  Created by Camilo on 05-12-12.
//  Copyright (c) 2012 Camilo Castro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Estaciones.h"
#import "Estacion.h"
#import "Feriados.h"

@interface Operaciones : NSObject
+ (NSNumber *) obtenerTiempoDeViaje;
+ (NSNumber *) obtenerTipoDia;
+ (NSString *) obtenerDireccion;
@end
