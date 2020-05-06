//
//  Estaciones.m
//  Tr5nR
//
//  Created by Camilo on 04-12-12.
//  Copyright (c) 2012 Camilo Castro. All rights reserved.
//

#import "Estaciones.h"
#import "DBConfig.h"

//static sqlite3 *db;
//static NSString *dbName = @"tr5nr.sqlite";

@implementation Estaciones

// Obtiene la lista de estaciones
// y entrega un arreglo del objeto estacion
+ (NSArray *) obtener{
    NSMutableArray __strong *estaciones = [[NSMutableArray alloc] init];
    
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
        char *sql = "SELECT * FROM estacion";
        
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare(db, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement");
        }
        
        // Ahora obtenemos los datos
        while (sqlite3_step(sqlStatement) == SQLITE_ROW) {
            
            Estacion *estacion = [[Estacion alloc] init];
            estacion.codigo = [NSNumber numberWithInt:sqlite3_column_int(sqlStatement,0)];
            estacion.nombre = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 1)];
            estacion.tramo = [NSNumber numberWithInt:sqlite3_column_int(sqlStatement,2)];
            estacion.tiempo = [NSNumber numberWithInt:sqlite3_column_int(sqlStatement,3)];
            estacion.latitud = [NSNumber numberWithInt:sqlite3_column_int(sqlStatement,4)];
            estacion.longitud = [NSNumber numberWithInt:sqlite3_column_int(sqlStatement,5)];
            estacion.tipo = [NSNumber numberWithInt:sqlite3_column_int(sqlStatement,6)];
            
            [estaciones addObject:estacion];
            estacion = nil;
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
        
    }
    @finally {
        return [estaciones copy];
    }
}

+ (Estacion *) obtenerEstacion:(NSString *) nombreEstacion{
    
    // Obtiene los datos de una estacion por su nombre
    NSArray *estaciones = [NSArray arrayWithArray:[self obtener]];
    
    NSMutableArray *nombres = [[NSMutableArray alloc] init];
    
    for (Estacion *estacion in estaciones) {
        [nombres addObject:estacion.nombre];
    }
    
    int ubicacion = 0;

    ubicacion = [nombres indexOfObject:nombreEstacion];
    
    return [estaciones objectAtIndex:ubicacion];

}

+ (NSArray *) obtenerSoloDireccionLimache{
    // Obtiene todas las estaciones que solo pueden ser alcanzadas por un tren que llegue a Limache
    
    NSArray *soloDireccionLimache = [NSArray arrayWithObjects:@"Peñablanca",@"Limache",@"Olmué",@"Quillota",@"La Calera",@"Limache Viejo", nil];
    
    return soloDireccionLimache;
    
}


+ (void) guardarEstacion:(Estacion *)estacion guardarOrigen:(BOOL) guardarOrigen{
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:estacion];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (guardarOrigen)
        [defaults setObject:myEncodedObject forKey:@"origen"];
    else 
        [defaults setObject:myEncodedObject forKey:@"destino"];
        
    [defaults synchronize];
}

+ (Estacion *) obtenerEstacionOrigen: (BOOL) obtenerOrigen{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSData *myEncodedObject = nil;
    
    if (obtenerOrigen)
        myEncodedObject = [defaults objectForKey:@"origen"];
    else
        myEncodedObject = [defaults objectForKey:@"destino"];
    
    Estacion *estacion = (Estacion *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    
    return estacion;
}

@end
