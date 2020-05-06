//
//  Rangos.m
//  Tr5nR
//
//  Created by Camilo on 05-12-12.
//  Copyright (c) 2012 Camilo Castro. All rights reserved.
//

#import "Rangos.h"
#import "DBConfig.h"
#import "TiposDia.h"
#import "Operaciones.h"

@implementation Rangos

// Segun la hora actual
// entrega el tipo de Rango Horario

+ (Rango *) obtenerHorario {
    // Si es dia de Semana el tipo de horario sera
    // dependiendo de la hora, si es sabado, domingo
    // o festivo, el tipo horario es bajo siempre
    
    Rango *rango = [[Rango alloc] init];
    
    if ([[Operaciones obtenerTipoDia] intValue] == SEMANA) {
        
    
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
        [formatter setDateFormat:@"HHmmss"];
    
        NSString *ahora = [formatter stringFromDate:date];
        NSLog(@"ahora %@",ahora);
    
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
    
        //ahora = @"234020";
    
        // Ahora creamos el query
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM rango WHERE \"%@\" BETWEEN desde AND hasta LIMIT 1", ahora];
    
        const char *sql = [query UTF8String];
    
        NSLog(@"query %@",query);
        query = nil;
    
        sqlite3_stmt *sqlStatement;
    
        if(sqlite3_prepare(db, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement");
        }
    
    
        // Ahora obtenemos los datos
        if(sqlite3_step(sqlStatement) == SQLITE_ROW) {
        
            rango.codigo = [NSNumber numberWithInt:sqlite3_column_int(sqlStatement,0)];
            rango.tipo = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 1)];
        }
    
    } else {
        // Bajo los dias sabados, domingos y festivos
        rango.codigo = [NSNumber numberWithInt:0];
        rango.tipo = @"Baja";
    }
    
    NSLog(@"Horario %@ tipo %@",rango.codigo,rango.tipo);
    
    return rango;

}
@end
