//
//  Operaciones.m
//  Tr5nR
//
//  Created by Camilo on 05-12-12.
//  Copyright (c) 2012 Camilo Castro. All rights reserved.
//

#import "Operaciones.h"
#import "TiposDia.h"

@implementation Operaciones

// Calcula el tiempo de viaje necesario
// desde el origen hasta el destino

+ (NSNumber *) obtenerTiempoDeViaje{
    Estacion  *origen = [Estaciones obtenerEstacionOrigen:YES];
    Estacion *destino = [Estaciones obtenerEstacionOrigen:NO];
    
    NSNumber *tiempoDeViaje = [NSNumber numberWithInteger: abs([origen.tiempo integerValue] - [destino.tiempo integerValue])];
    
    NSLog(@"Tiempo de Viaje: %@",tiempoDeViaje);
    
    return tiempoDeViaje;
}

// Entrega si hoy es dia de semana
// domingo o festivo o sabado
// necesario por que las frecuencias de los trenes
// cambian dependiendo del dia
+ (NSNumber *) obtenerTipoDia {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE"];
    
    NSString *hoy = [formatter stringFromDate:date];
    
    BOOL esFeriado = [Feriados esFeriado];
    
    int tipo_dia = SEMANA;
    
    if ([hoy isEqualToString:@"Sunday"] || esFeriado) {
        tipo_dia = DOMINGOoFESTIVO;
        NSLog(@"Hoy es Feriado o Domingo");
        
    } else if([hoy isEqualToString:@"Saturday"]){
        tipo_dia = SABADO;
        NSLog(@"Hoy es Sabado");
        
    } else {
        NSLog(@"Hoy es dia de Semana");
    }
    
    return [NSNumber numberWithInt:tipo_dia];

}

// Dado el origen y el destino
// se calcula la direccion del tren
// si va hacia Limache o Hacia Puerto
+ (NSString *) obtenerDireccion{
    Estacion *origen = [Estaciones obtenerEstacionOrigen:YES];
    Estacion *destino = [Estaciones obtenerEstacionOrigen:NO];
    
    BOOL direccionPuerto = YES;
    NSString *direccion = @"Puerto";
    
    if ([origen.codigo intValue] >= [destino.codigo intValue]) {
        NSLog(@"Viaja direccion Puerto %@ >= %@",origen.codigo,destino.codigo);
        
        NSLog(@"Sirven todos los trenes a puerto");
        
    } else {
        direccionPuerto = NO;
        NSLog(@"Viaja direccion Limache %@ <= %@",origen.codigo,destino.codigo);
    }
    
    
    if (!direccionPuerto) {
        // Ahora hay que verificar si va a una estacion menor o igual a Sgto
        // Aldea. Si va a una estacion superior a Stgo Aldea solo serviran los trenes hacia Limache. Si es menor sirven los trenes a Stgo Aldea o Limache.
        
        NSArray *soloDireccionLimache = [NSArray arrayWithArray:[Estaciones obtenerSoloDireccionLimache]];
        
        Estacion *destino = [Estaciones obtenerEstacionOrigen:NO];
        
        if ([soloDireccionLimache containsObject:destino.nombre]) {
            // Si la estacion de destino solo se puede llegar con un tren a limache, se seleccionan los trenes solo a limache
            direccion = @"Limache";
            NSLog(@"Sirven los trenes solo hacia Limache");
        } else {
            // Si la estacion de destino puede ser alcanzada por trenes tanto a limache como stgo aldea se seleccionan esas 2 opcioens.
            direccion = @"Sargento Aldea";
            NSLog(@"Sirven los trenes hacia limache y stgo aldea");
        }
    }
    
    return direccion;
}


@end
