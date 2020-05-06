//
//  Tarifas.m
//  Tr5nR
//
//  Created by Camilo on 12-12-12.
//  Copyright (c) 2012 Camilo Castro. All rights reserved.
//

#import "Tarifa.h"
#import "Tarifas.h"

#import "Operaciones.h"

#import "Estacion.h"
#import "Estaciones.h"

#import "Rango.h"
#import "Rangos.h"

#import "Usuarios.h"

#import "DBConfig.h"
#import <sqlite3.h>

@implementation Tarifas

//TODO
// Obtiene los costos del viaje
// dado un origen, un destino y el tipo hora

+ (NSArray *) obtenerTarifas {
    // Obtenemos la estacion de origen
    Estacion *origen = [Estaciones obtenerEstacionOrigen:YES];
    
    // Obtenemos la estacion destino del tren
    Estacion *destino = [Estaciones obtenerEstacionOrigen:NO];
    
    // Obtenemos el tipo de rango horario
    Rango *rango = [Rangos obtenerHorario];
    
    // Creamos el arreglo de tarifas
    NSMutableArray *tarifas = [[NSMutableArray alloc] init];
    
    // Creamos la consulta
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM tarifa WHERE origen = %@ AND destino = %@ AND rango = %@",origen.tramo,destino.tramo,rango.codigo];
    
    // Consultamos a la bd
    
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
        
        // Guardamos los datos en el objeto y arreglo correspondiente
        while (sqlite3_step(sqlStatement) == SQLITE_ROW) {
            
            Tarifa *tarifa = [[Tarifa alloc] init];
            
            tarifa.origen = origen;
            tarifa.destino = destino;
            
            tarifa.rango = rango;

            tarifa.usuario = [Usuarios obtenerUsuario:[NSNumber numberWithInt:sqlite3_column_int(sqlStatement, 3)]];
            
            // Mismo origen y destino, valor maximo de pasaje
            if ([origen.codigo intValue] == [destino.codigo intValue])
            {
                # warning Hay que buscar una forma no hardcoded para el valor maximo del pasaje
                NSLog(@"Mismo origen y destino, valor maximo de pasaje");
                
                tarifa.valor = [NSNumber numberWithInt:744];
                
            } else {
                tarifa.valor = [NSNumber numberWithInt:sqlite3_column_int(sqlStatement, 4)];
            }

            [tarifas addObject:tarifa];
            
            tarifa = nil;
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
        
    }
    @finally {
        
        return [tarifas copy];
    }
}

// Entrega el valor de la tarifa para el usuario
// guardado en memoria

+ (Tarifa *) obtenerTarifaUsuario {
    // Recorremos el arreglo, hasta encontrar el usuario
    // que necesitamos saber el valor del viaje
    NSArray *tarifas = [NSArray arrayWithArray:[self obtenerTarifas]];
    
    Tarifa *tarifa = [[Tarifa alloc] init];
    
    for (Tarifa *_tarifa in tarifas){
        if ([_tarifa.usuario.tipo isEqual:[Usuarios obtenerUsuario].tipo]) {
            
            // Asignamos el valor segun usuario
            tarifa = _tarifa;
            
            NSLog(@"Tarifa %@ Valor $%@",_tarifa.usuario.tipo,_tarifa.valor);
            
            // Terminamos el For
            break;
        }
    }
    
    return tarifa;
    
}

@end
