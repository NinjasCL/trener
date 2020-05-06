//
//  Feriados.m
//  Tr5nR
//
//  Created by Camilo on 05-12-12.
//  Copyright (c) 2012 Camilo Castro. All rights reserved.
//

#import "Feriados.h"
#import "DBConfig.h"
@implementation Feriados

// Si ya se ha consultado en el dia, no hacerlo de nuevo
static BOOL feriado_check = NO;
static BOOL esFeriado = NO;
static NSString *fecha_anterior;

// Entrega si hoy es feriado o no
+ (BOOL) esFeriado{
    
    // Obtenemos la fecha de Hoy
    NSDate * date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"dd-MM-yy"];
    
    NSString *hoy = [formatter stringFromDate:date];
    
    // Solo consultamos en la bd una vez al dia por si es feriado
    if (!feriado_check && ![fecha_anterior isEqualToString:hoy]) {
        fecha_anterior = hoy;
        feriado_check = YES;
    
        //NSLog(@"hoy %@  fecha anterior %@",hoy,fecha_anterior);
    
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
        NSString *query = [NSString stringWithFormat:@"SELECT fecha FROM feriado WHERE fecha=\"%@\" LIMIT 1", hoy];
    
        const char *sql = [query UTF8String];
    
        NSLog(@"query %@",query);
        query = nil;
    
        sqlite3_stmt *sqlStatement;
    
        if(sqlite3_prepare(db, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement");
        }
    
        NSLog(@"Hoy es %@",hoy);
        hoy = nil;
    
        // Ahora obtenemos los datos
        if(sqlite3_step(sqlStatement) == SQLITE_ROW) {
            NSLog(@"ES Feriado!");
            esFeriado = YES;
        } else {
    
            NSLog(@"No es Feriado :C");
            esFeriado = NO;
        }
    
    } else {
        feriado_check = NO;
    }
    
    return esFeriado;
}
@end
