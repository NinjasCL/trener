//
//  Horario.m
//  Tr5nR
//
//  Created by Camilo on 09-12-12.
//  Copyright (c) 2012 Camilo Castro. All rights reserved.
//

#import "Horario.h"

@implementation Horario
@synthesize direccion = _direccion;
@synthesize fecha = _fecha;
@synthesize hora = _hora;
@synthesize minutos = _minutos;
@synthesize origen = _origen;
@synthesize dia = _dia;

- (void) setHora:(NSString *)hora {
    NSString *horaString = [hora substringToIndex:2];
    
    NSString *minutoString = [hora substringWithRange:NSMakeRange(2, 2)];
    
    
    NSString *posFix = @"AM";
    
    if ([horaString intValue] >= 12) {
        posFix = @"PM";
    }
    
    _hora = [NSString stringWithFormat:@"%@:%@ %@",horaString,minutoString,posFix];

    horaString = nil;
    minutoString = nil;
    posFix = nil;
}
@end
