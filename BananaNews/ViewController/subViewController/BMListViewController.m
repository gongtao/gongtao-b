//
//  BMListViewController.m
//  BananaNews
//
//  Created by 龚涛 on 1/3/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import "BMListViewController.h"

#import "BMNewsListCell.h"

@interface BMListViewController ()

@end

@implementation BMListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.rowAnimation = UITableViewRowAnimationNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Override

- (NSFetchRequest *)fetchRequest
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:News_Entity inManagedObjectContext:[self managedObjectContext]];
    [request setEntity:entity];
    NSSortDescriptor *sortDesciptor = [NSSortDescriptor sortDescriptorWithKey:kNid ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDesciptor]];
    return request;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    static NSString *CellIdentifier = @"ListCell";
    BMNewsListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[BMNewsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    News *news = [fetchedResultsController objectAtIndexPath:indexPath];
    [cell configCellNews:news];
    
    return cell;
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    News *news = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if (!news.medias || news.medias.count == 0) {
        return news.text_height.floatValue+52.0;
    }
    return news.text_height.floatValue+64.0;
}

@end
