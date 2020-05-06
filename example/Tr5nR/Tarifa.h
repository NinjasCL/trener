//
//  Tarifa.h
//  Tr5nR
//
//  Created by Camilo on 03-12-12.
//  Copyright (c) 2012 Camilo Castro. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Usuario.h"
#import "Estacion.h"
#import "Rango.h"

@interface Tarifa : NSObject

@property (nonatomic,strong) Estacion *origen;
@property (nonatomic,strong) Estacion *destino;
@property (nonatomic,strong) Rango *rango;
@property (nonatomic,strong) Usuario * usuario;
@property (nonatomic,strong) NSNumber * valor;


@end
