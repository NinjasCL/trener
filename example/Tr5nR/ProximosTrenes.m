//
//  ProximosTrenes.m
//  Tr5nR
//
//  Created by Camilo on 11-12-12.
//  Copyright (c) 2012 Camilo Castro. All rights reserved.
//

#import "ProximosTrenes.h"

@interface ProximosTrenes ()

@end

@implementation ProximosTrenes
@synthesize proximos = _proximos;



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.proximos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Proximo";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if ([self.proximos count] > 0) {
        Horario *proximo = [self.proximos objectAtIndex:indexPath.row];
    
        NSString * minutos = [NSString stringWithFormat:@"%1.0f Minutos",[proximo.minutos doubleValue]];
    
        cell.textLabel.text = minutos;
        cell.detailTextLabel.text = proximo.hora;
 
    } else {
        cell.textLabel.text = @"No hay trenes";
        cell.detailTextLabel.text = @"";
    }
    
    
    return cell;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    // Colores Bonitos
    if (indexPath.row % 2)
        [cell setBackgroundColor:[UIColor colorWithRed:.933 green:.923 blue:.923 alpha:1]];
    
    else
        [cell setBackgroundColor:[UIColor clearColor]];
}

@end