//
//  Estacion.m
//  Tr5nR
//
//  Created by Camilo on 04-12-12.
//  Copyright (c) 2012 Camilo Castro. All rights reserved.
//

#import "Estacion.h"


@implementation Estacion

@synthesize codigo = _codigo;
@synthesize nombre = _nombre;
@synthesize tramo = _tramo;
@synthesize tipo = _tipo;
@synthesize tiempo = _tiempo;
@synthesize latitud = _latitud;
@synthesize longitud = _longitud;

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        // Para decodificacion del NSUserDefaults
        self.codigo = [decoder decodeObjectForKey:@"codigo"];
        self.nombre = [decoder decodeObjectForKey:@"nombre"];
        self.tramo = [decoder decodeObjectForKey:@"tramo"];
        self.tipo = [decoder decodeObjectForKey:@"tipo"];
        self.tiempo = [decoder decodeObjectForKey:@"tiempo"];
        self.latitud = [decoder decodeObjectForKey:@"latitud"];
        self.longitud = [decoder decodeObjectForKey:@"longitud"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    // Para codificar en el NSUserDefaults
    [encoder encodeObject:self.codigo forKey:@"codigo"];
    [encoder encodeObject:self.nombre forKey:@"nombre"];
    [encoder encodeObject:self.tramo forKey:@"tramo"];
    [encoder encodeObject:self.tipo forKey:@"tipo"];
    [encoder encodeObject:self.tiempo forKey:@"tiempo"];
    [encoder encodeObject:self.latitud forKey:@"latitud"];
    [encoder encodeObject:self.longitud forKey:@"longitud"];
}
@end
