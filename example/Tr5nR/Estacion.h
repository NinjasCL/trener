//
//  Estacion.h
//  Tr5nR
//
//  Created by Camilo on 04-12-12.
//  Copyright (c) 2012 Camilo Castro. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Estacion : NSObject

@property (nonatomic, strong) NSNumber * codigo;
@property (nonatomic, strong) NSNumber * latitud;
@property (nonatomic, strong) NSNumber * longitud;
@property (nonatomic, strong) NSString * nombre;
@property (nonatomic, strong) NSNumber * tiempo;
@property (nonatomic, strong) NSNumber * tipo;
@property (nonatomic, strong) NSNumber * tramo;

@end
