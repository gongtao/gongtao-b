//
//  BMTabViewController.m
//  BananaNews
//
//  Created by 龚涛 on 1/10/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import "BMTabViewController.h"

#define kBMTabButtonTag     1000

@interface BMTabViewController ()

@property (nonatomic, strong) UIView *scrollBgView;

- (void)_tabButtonPressed:(UIButton *)button;

@end

@implementation BMTabViewController

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
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.backgroundColor = Color_TabBar;
    _scrollView.scrollsToTop = NO;
    [self.view addSubview:_scrollView];
    
    _scrollBgView = [[UIView alloc] init];
    _scrollBgView.backgroundColor = Color_GrayLine;
    [_scrollView addSubview:_scrollBgView];
    
    _page = -1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - Private

- (void)_tabButtonPressed:(UIButton *)button
{
    [self selectPage:button.tag-kBMTabButtonTag];
}

#pragma mark - Public

- (void)setPage:(NSInteger)page
{
    if (page == _page) {
        return;
    }
    UIButton *button = (UIButton *)[_scrollBgView viewWithTag:page+kBMTabButtonTag];
    if (button) {
        button.backgroundColor = Color_TabBarSelect;
        [button setTitleColor:Color_NewsFont forState:UIControlStateNormal];
    }
    
    button = (UIButton *)[_scrollBgView viewWithTag:_page+kBMTabButtonTag];
    if (button) {
        button.backgroundColor = Color_TabBar;
        [button setTitleColor:Color_SideFont forState:UIControlStateNormal];
    }
    
    _page = page;
}

- (void)selectPage:(NSUInteger)page
{
    if (_page != page) {
        if ([_delegate respondsToSelector:@selector(didSelectTab:index:)]) {
            [_delegate didSelectTab:self index:page];
        }
    }
    self.page = page;
}

- (NSInteger)pageNum
{
    return [[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
}

- (void)tabsUpdate
{
    NSString *title = nil;
    if (_page != -1) {
        UIButton *button = (UIButton *)[_scrollBgView viewWithTag:_page+kBMTabButtonTag];
        title = button.titleLabel.text;
    }
    
    [_scrollBgView.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL* stop){
        [obj removeFromSuperview];
    }];
    
    int page = 0;
    int count = [[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
    __block CGRect frame = CGRectMake(0.0, 0.0, 45.0, 32.0);
    for (int i = 0; i < count; i++) {
        NewsCategory *obj = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        UIButton *button = [[UIButton alloc] initWithFrame:frame];
        button.backgroundColor = Color_TabBar;
        button.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [button setTitle:obj.cname forState:UIControlStateNormal];
        [button setTitleColor:Color_SideFont forState:UIControlStateNormal];
        [button addTarget:self action:@selector(_tabButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = kBMTabButtonTag+i;
        [_scrollBgView addSubview:button];
        frame.origin.x += frame.size.width+1.0;
        if ([obj.cname isEqualToString:title]) {
            page = i;
        }
    };
    
    frame.size.width = frame.origin.x-1.0;
    frame.origin.x = 0.0;
    _scrollBgView.frame = frame;
    
    _scrollView.contentSize = frame.size;
    
    _page = -1;
    [self selectPage:page];
}

#pragma mark - Property method

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[self fetchRequest] managedObjectContext:[self managedObjectContext] sectionNameKeyPath:nil cacheName:@"NewsCategoryTabs"];
    _fetchedResultsController.delegate = self;
    
    [self performFetch];
    
    return _fetchedResultsController;
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

- (NSManagedObjectContext *)managedObjectContext
{
    id appDelegate = [UIApplication sharedApplication].delegate;
    return [appDelegate managedObjectContext];
}

- (NSFetchRequest *)fetchRequest
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NewsCategory_Entity inManagedObjectContext:[self managedObjectContext]];
    [request setEntity:entity];
    request.predicate = [NSPredicate predicateWithFormat:@"%K == %@", kIsHead, [NSNumber numberWithBool:YES]];
    NSSortDescriptor *sortDesciptor = [NSSortDescriptor sortDescriptorWithKey:kCategoryId ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDesciptor]];
    return request;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self tabsUpdate];
}

@end
