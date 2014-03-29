//
//  SBMovieItemView.m
//  BananaNews
//
//  Created by 龚涛 on 3/24/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import "BMMovieItemView.h"

@implementation BMMovieItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        _bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [_bgImageView setImage:[UIImage imageNamed:@"视频框背景.png"]];
        _bgImageView.contentMode = UIViewContentModeCenter;
        _bgImageView.clipsToBounds = YES;
        [self addSubview:_bgImageView];
        
        CGRect frame = self.bounds;
        frame.size.height = 156.0;
        _contentImageView = [[UIImageView alloc] initWithFrame:frame];
        _contentImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_contentImageView];
        
        _frameImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [_frameImageView setImage:[UIImage imageNamed:@"视频框.png"]];
        [self addSubview:_frameImageView];
        
        int count = [[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
        if (count != 0) {
            self.news = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            NSLog(@"add a news%i", self.tag);
        }
    }
    return self;
}

- (void)createFetchData:(NSInteger)index
{
    self.tag = index;
    [self fetchedResultsController];
}

#pragma mark - DataBase method

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[self fetchRequest] managedObjectContext:[self managedObjectContext] sectionNameKeyPath:nil cacheName:[NSString stringWithFormat:@"recommend%i", self.tag]];
    _fetchedResultsController.delegate = self;
    
    [self performFetch];
    
    return _fetchedResultsController;
}

- (NSManagedObjectContext *)managedObjectContext
{
    id appDelegate = [UIApplication sharedApplication].delegate;
    return [appDelegate managedObjectContext];
}

- (NSFetchRequest *)fetchRequest
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:News_Entity inManagedObjectContext:[self managedObjectContext]];
    [request setEntity:entity];
    request.predicate = [NSPredicate predicateWithFormat:@"(ANY category.isHead == %@) AND (%K == %@)", [NSNumber numberWithBool:YES], kStatus, [NSNumber numberWithInt:self.tag]];
    [request setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:kNid ascending:NO]]];
    return request;
}

- (void)performFetch
{
    if (!_fetchedResultsController) {
        [self fetchedResultsController];
        return;
    }
    
    NSError *error = NULL;
    if (![_fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

#pragma mark - NSFetchedResultsControllerDelegate

//- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
//{
//    NSLog(@"willChange%i", self.tag);
//}
//
//- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
//{
//    NSLog(@"didChangeObject%i", self.tag);
//}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    int count = [[[controller sections] objectAtIndex:0] numberOfObjects];
    if (count == 0) {
        NSLog(@"empty a news%i", self.tag);
    }
    else {
        self.news = [controller objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        NSLog(@"add a news%i", self.tag);
    }
}

@end
