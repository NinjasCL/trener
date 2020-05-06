//
//  Estaciones.h
//  Tr5nR
//
//  Created by Camilo on 04-12-12.
//  Copyright (c) 2012 Camilo Castro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Estacion.h"

@interface Estaciones : NSObject

+ (NSArray *) obtener;
+ (void) guardarEstacion:(Estacion *)estacion guardarOrigen:(BOOL) guardarOrigen;
+ (Estacion *) obtenerEstacionOrigen: (BOOL) obtenerOrigen;
+ (Estacion *) obtenerEstacion:(NSString *) nombre;
+ (NSArray *) obtenerSoloDireccionLimache;
@end
