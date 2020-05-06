//
//  Usuarios.h
//  Tr5nR
//
//  Created by Camilo on 04-12-12.
//  Copyright (c) 2012 Camilo Castro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Usuario.h"
@interface Usuarios : NSObject
+ (NSArray *) obtener;
+ (void) guardarUsuario:(Usuario *) usuario;
+ (Usuario *) obtenerUsuario;
+ (Usuario *) obtenerUsuario:(NSNumber *)codigo;
@end
