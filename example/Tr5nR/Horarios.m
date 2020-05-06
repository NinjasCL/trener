//
//  Horarios.m
//  Tr5nR
//
//  Created by Camilo on 09-12-12.
//  Copyright (c) 2012 Camilo Castro. All rights reserved.
//

#import "Horarios.h"
#import "Operaciones.h"
#import "Estacion.h"
#import "Estaciones.h"
#import "DBConfig.h"
#import "TiposDia.h"

@implementation Horarios

// Obtiene la diferencia de minutos de tiempo entre
// la fecha y hora actual y la fecha dada
+ (NSNumber *) tiempoRestante:(NSDate *) fecha{
    NSDate *ahora = [NSDate date];
    
    NSTimeInterval timeDifference = round(abs([fecha timeIntervalSinceDate:ahora]));
    
	NSNumber *tiempo_restante = [NSNumber numberWithDouble:(timeDifference / 60)];
    
    NSLog(@"%@ Minutos", tiempo_restante);
    
    return tiempo_restante;
}

// Obtiene el proximo tren segun la hora actual
// la estacion de origen, el tipo de dia y la direccion
// del tren

+ (NSArray *) proximosTrenes{
    // Primero obtenemos hacia donde viaja el tren
    // y la estacion de destino
    
    NSString *direccion = [Operaciones obtenerDireccion];
    
    Estacion *estacionDireccion = [Estaciones obtenerEstacion:direccion];
    
    Estacion *origen = [Estaciones obtenerEstacionOrigen:YES];
    
    NSNumber *dia = [Operaciones obtenerTipoDia];
    //NSNumber * dia = [NSNumber numberWithInt:0];
    
    // La hora actual
    NSDate *date = [NSDate date];
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"es_CL"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // Ahora obtenemos los datos
    [formatter setLocale:locale];
    [formatter setDefaultDate:date];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    
    [formatter setDateFormat:@"HHmmss"];
    
    NSString *ahora = [formatter stringFromDate:date];
    //NSString *ahora = @"072910";
    
    
    NSMutableArray *proximosTrenes = [[NSMutableArray alloc] init];
    
    NSString *query = [NSString stringWithFormat: @"SELECT hora FROM horario WHERE direccion = %@ AND dia = %@ AND origen = %@ AND hora >= %@ ORDER BY hora ASC",estacionDireccion.codigo, dia, origen.codigo, ahora];
    
    // En fines de semana y feriados, solo hay trenes a limache
    if ([direccion isEqualToString:@"Sargento Aldea"] && [dia intValue] == SEMANA) {
        // Si va Sargento Aldea, Sirven los trenes a Limache y Sargento Aldea
        Estacion *limache = [Estaciones obtenerEstacion:@"Limache"];
        
        query = [NSString stringWithFormat: @"SELECT hora FROM horario WHERE (direccion = %@ OR direccion = %@) AND dia = %@ AND origen = %@ AND hora >= %@ ORDER BY hora ASC",limache.codigo,estacionDireccion.codigo,dia,origen.codigo,ahora];
    }
    
    // Ahora hacemos el query correspondiente
    
    NSLog(@"Proximo Tren Query : %@",query);
    
    @try {
        // Abrimos el archivo
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSString *dbPath = [[[NSBundle mainBundle] resourcePath ] stringByAppendingPathComponent:dbName];
        
        BOOL success = [fileMgr fileExistsAtPath:dbPath];
        
        if(!success)
        {
            NSLog(@"Cannot locate database file '%@'.", dbPath);
        }
        
        if(!(sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        
        // Ahora creamos el query
        char *sql = (char *)[query UTF8String];
        
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare(db, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement");
        }
        
        
        //[formatter setDateFormat:@"HH:mm:ss"];
        
        while (sqlite3_step(sqlStatement) == SQLITE_ROW) {
            
            Horario *horario = [[Horario alloc] init];
            
            NSNumber *hora;
            //horario.origen
            //horario.direccion
           // horario.dia
            
            
            hora = [NSNumber numberWithInt:sqlite3_column_int(sqlStatement, 0)];
            
          
            //horario.hora = NSDate
            NSString *horaHoy = [hora stringValue];
            
            // Formateamos para que tenga la cantidad de numeros necesarios
            // las horas menores a 10
            if ([[hora stringValue] length] % 5 == 0) {
                horaHoy = [NSString stringWithFormat:@"0%@",hora];
            }
            
            
            horario.fecha = [formatter dateFromString:horaHoy];
            horario.hora = horaHoy;
            
            horario.minutos = [self tiempoRestante:horario.fecha];
            
            //NSLog(@"Hora BD: %@ Minutos Restantes: %@",horaHoy,horario.minutos);
            
            [proximosTrenes addObject:horario];
            horario = nil;
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
        
    }
    @finally {
        
        return [proximosTrenes copy];
    }
}
@end
