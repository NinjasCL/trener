//
//  Usuario.m
//  Tr5nR
//
//  Created by Camilo on 03-12-12.
//  Copyright (c) 2012 Camilo Castro. All rights reserved.
//

#import "Usuario.h"


@implementation Usuario

@synthesize codigo = _codigo;
@synthesize  tipo = _tipo;

// Metodos Necesarios para guardalo en NSUSerDefault
// y obtenerlos

- (id)initWithCoder:(NSCoder *)decoder{
    if ((self = [super init])) {
        self.codigo = [decoder decodeObjectForKey:@"codigo"];
        self.tipo = [decoder decodeObjectForKey:@"tipo"];
    }
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *) encoder{
    [encoder encodeObject:self.codigo forKey:@"codigo"];
    [encoder encodeObject:self.tipo forKey:@"tipo"];
}


@end
