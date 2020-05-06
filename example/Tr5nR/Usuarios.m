//
//  Usuarios.m
//  Tr5nR
//
//  Created by Camilo on 04-12-12.
//  Copyright (c) 2012 Camilo Castro. All rights reserved.
//

#import "Usuarios.h"
#import "DBConfig.h"

@implementation Usuarios
+ (NSArray *) obtener{
    NSMutableArray *usuarios = [[NSMutableArray alloc] init];
    
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
        char *sql = "SELECT * FROM usuario";
        
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare(db, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement");
        }
        
        // Ahora obtenemos los datos
        while (sqlite3_step(sqlStatement) == SQLITE_ROW) {
            
            Usuario *usuario = [[Usuario alloc] init];
            usuario.codigo = [NSNumber numberWithInt:sqlite3_column_int(sqlStatement, 0) ];
            usuario.tipo = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,1)];
            
            [usuarios addObject:usuario];
            usuario = nil;
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
        
    }
    @finally {
        return [usuarios copy];
    }

}
 
+ (void) guardarUsuario:(Usuario *) usuario {
    NSData *usuarioEncoded = [NSKeyedArchiver archivedDataWithRootObject:usuario];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:usuarioEncoded forKey:@"usuario"];
    [defaults synchronize];
}

// Obtiene el usuario desde memoria interna
+ (Usuario *) obtenerUsuario {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSData *usuarioEncoded = [defaults objectForKey:@"usuario"];
    
    Usuario *usuario = (Usuario *) [NSKeyedUnarchiver unarchiveObjectWithData:usuarioEncoded];
    
    return usuario;
    
}

// Obtiene un usuario segun codigo
+ (Usuario *) obtenerUsuario:(NSNumber *)codigo {
    NSArray * usuarios = [NSArray arrayWithArray:[self obtener]];
    
    Usuario *usuario = [[Usuario alloc] init];
    // Si existe el codigo dentro de los usuarios lo entregamos
    // si no, entregamos el usuario guardado en memoria
    @try{
        
    if ([usuarios containsObject:[usuarios objectAtIndex:codigo.intValue]]) {
        usuario =  [usuarios objectAtIndex:codigo.intValue];
        }
    
    }@catch (NSException *exception) {
        NSLog(@"%@",exception);
        usuario = [self obtenerUsuario];
    } @finally {
        return usuario;
    }
    
}

@end
