//
//  BMRecommendViewController.m
//  BananaNews
//
//  Created by 龚涛 on 3/19/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import "BMRecommendViewController.h"

#import "BMMovieItemView.h"

#import "BMSNSLoginView.h"

#import "BMCommentViewController.h"

@interface BMRecommendViewController ()

@property (nonatomic, strong) UILabel *pageLabel;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, assign) BOOL isReachable;

- (void)_networkNotice:(NSNotification *)notice;

- (void)_updateData;

- (void)_loginToSite:(NSNotification *)notice;

- (void)_comment;

@end

@implementation BMRecommendViewController

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
    _isReachable = NO;
    
    self.view.backgroundColor = Color_ViewBg;
    
    CGFloat y = IS_IPhone5_or_5s?275.0:248.0;
    
    self.operateSubview = [[BMOperateSubView alloc] initWithFrame:CGRectMake(65.0, y, 190.0, 120.0)];
    self.operateSubview.delegate = self;
    [self.view addSubview:self.operateSubview];
    
    y = IS_IPhone5_or_5s?45.0:30.0;
    
    self.pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, y)];
    self.pageLabel.backgroundColor = [UIColor clearColor];
    self.pageLabel.textColor = Color_NavBarBg;
    self.pageLabel.font = [UIFont systemFontOfSize:17.0];
    self.pageLabel.text = @"1/3";
    self.pageLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.pageLabel];
    
    BMCommonScrollorView *scView=[[BMCommonScrollorView alloc] initWithFrame:CGRectMake(0, y, self.view.bounds.size.width, 180.0)];
    scView.dataSource = self;
    scView.delegate = self;
    [self.view addSubview:scView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(58.0, CGRectGetMaxY(scView.frame)-5.0, 204.0, 45.0)];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"666666"];
    self.titleLabel.font = [UIFont systemFontOfSize:17.0];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.titleLabel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_loginToSite:) name:kLoginSuccessNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_networkNotice:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DataBase method

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[self fetchRequest] managedObjectContext:[self managedObjectContext] sectionNameKeyPath:nil cacheName:@"recommend"];
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
    request.predicate = [NSPredicate predicateWithFormat:@"(ANY category.isHead == %@) AND (%K >= %@)", [NSNumber numberWithBool:YES], kStatus, [NSNumber numberWithInt:0]];
    [request setSortDescriptors:[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:kNid ascending:NO], [NSSortDescriptor sortDescriptorWithKey:kStatus ascending:NO], nil]];
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

#pragma mark - Private

- (void)_networkNotice:(NSNotification *)notice
{
    NSNumber *status = notice.userInfo[AFNetworkingReachabilityNotificationStatusItem];
    
    BOOL isReachable = status.integerValue>AFNetworkReachabilityStatusNotReachable;
    if (isReachable && !_isReachable) {
        _isReachable = isReachable;
        BMNewsManager *manager = [BMNewsManager sharedManager];
        [manager configInit:^(void){
            [manager getConfigSuccess:^(void){
#warning 更新数据
                [self _updateData];
            }
                              failure:nil];
        }];
    }
    
    switch (status.integerValue) {
        case AFNetworkReachabilityStatusUnknown:
        case AFNetworkReachabilityStatusNotReachable: {
            NSLog(@"网络不给力");
            break;
        }
        case AFNetworkReachabilityStatusReachableViaWWAN: {
            NSLog(@"WWAN");
            break;
        }
        case AFNetworkReachabilityStatusReachableViaWiFi: {
            NSLog(@"WIFI");
            break;
        }
        default:
            break;
    }
}

- (void)_updateData
{
    int count = [[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
    NSLog(@"%i", count);
    if (count < 3) {
#warning 请求网络
        BMNewsManager *manager = [BMNewsManager sharedManager];
        NewsCategory *category = [manager getRecommendNewsCategory:[self managedObjectContext]];
        if (category) {
            [manager getDownloadList:category.category_id
                                page:1
                             success:^(NSArray *array){
                                 
                             }
                             failure:^(NSError *error){
                                 
                             }];
        }
    }
}

- (void)_loginToSite:(NSNotification *)notice
{
    User *user = notice.userInfo[@"user"];
    if (user) {
        [self _comment];
    }
}

- (void)_comment
{
    BMCommentViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"commentViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -

- (void)videoDelete
{
    
}

- (void)videoShare
{
//    [[BMNewsManager sharedManager] shareNews:news delegate:self];
}

- (void)videoGood
{
    
}

- (void)videoBad
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kLoginKey]) {
        [self _comment];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"评论" message:@"亲~请先登录再评论" delegate:self cancelButtonTitle:@"暂不" otherButtonTitles:@"登录", nil];
        [alertView show];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"登录"]) {
        BMSNSLoginView *loginView = [[BMSNSLoginView alloc] initWithFrame:self.parentViewController.view.bounds];
        [loginView showInView:self.parentViewController.view];
    }
}

#pragma mark - UMSocialUIDelegate

- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    if (response.responseCode == UMSResponseCodeSuccess) {
//        [[BMNewsManager sharedManager] shareToSite:news.nid.integerValue success:nil failure:nil];
    }
}

#pragma mark - BMCommonScrollorViewDataSource

- (UIView *)pageAtIndex:(NSInteger)index withFrame:(CGRect)frame;
{
    BMMovieItemView *item = [[BMMovieItemView alloc] initWithFrame:frame];
    return item;
}

#pragma mark - BMCommonScrollorViewDataSource

- (void)commonScrollorViewDidSelectPage:(NSUInteger)index
{
    self.pageLabel.text = [NSString stringWithFormat:@"%i/3", index+1];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    NSLog(@"willChange");
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    NSLog(@"didChangeObject");
//    int number = [[[controller sections] objectAtIndex:[indexPath section]] numberOfObjects];
//    
//    switch(type) {
//            
//        case NSFetchedResultsChangeInsert:
//            if (_numberOfFetchLimit <= number) {
//                if ([newIndexPath row] < _numberOfFetchLimit) {
//                    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:_numberOfFetchLimit-1 inSection:[newIndexPath section]]] withRowAnimation:_rowAnimation];
//                    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:_rowAnimation];
//                }
//            }
//            else {
//                [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:_rowAnimation];
//            }
//            break;
//            
//        case NSFetchedResultsChangeDelete:
//            if (_numberOfFetchLimit <= number) {
//                if ([indexPath row] < _numberOfFetchLimit) {
//                    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:_rowAnimation];
//                    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:_numberOfFetchLimit-1 inSection:[indexPath section]]] withRowAnimation:_rowAnimation];
//                }
//            }
//            else {
//                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:_rowAnimation];
//            }
//            break;
//            
//        case NSFetchedResultsChangeUpdate:
//            [self configCell:[self.tableView cellForRowAtIndexPath:indexPath] cellForRowAtIndexPath:indexPath fetchedResultsController:self.fetchedResultsController];
//            break;
//            
//        case NSFetchedResultsChangeMove:
//            [self.tableView deleteRowsAtIndexPaths:[NSArray
//                                                    arrayWithObject:indexPath] withRowAnimation:_rowAnimation];
//            [self.tableView insertRowsAtIndexPaths:[NSArray
//                                                    arrayWithObject:newIndexPath] withRowAnimation:_rowAnimation];
//            break;
//    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    NSLog(@"didChange");
    [self _updateData];
}


@end
