//
//  BMSubUserViewController.m
//  BananaNews
//
//  Created by 龚涛 on 3/19/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import "BMSubUserViewController.h"

#import "BMHistoryTableViewController.h"

@interface BMSubUserViewController ()

@end

@implementation BMSubUserViewController

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
    self.view.backgroundColor = Color_ViewBg;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    id appDelegate = [UIApplication sharedApplication].delegate;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName: News_Entity inManagedObjectContext:[appDelegate managedObjectContext]];
    [request setEntity:entity];
    NSSortDescriptor *sortDesciptor = [NSSortDescriptor sortDescriptorWithKey:@"history_day" ascending:NO];
    request.predicate = [NSPredicate predicateWithFormat:@"history_day != nil"];
    
    [request setSortDescriptors:[NSArray arrayWithObject:sortDesciptor]];
    
    BMHistoryTableViewController *newsVC = [[BMHistoryTableViewController alloc] initWithRequest:request cacheName:@"cacheCollection"];
    newsVC.view.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    newsVC.tableView.frame=CGRectMake(0, 160, self.view.bounds.size.width, self.view.bounds.size.height);
    //newsVC.tableView.contentInset=UIEdgeInsetsMake(-160, 0.0f, 0.0f, 0.0f);
    newsVC.view.backgroundColor=[UIColor clearColor];
    UIButton *userButton=[[UIButton alloc]initWithFrame:CGRectMake(130, 30, 60, 60)];
    
    [userButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 110, 300, 15)];
    label.textColor=Color_NavBarBg;
    label.font=[UIFont systemFontOfSize:14];
    label.textAlignment=UITextAlignmentCenter;
    if (![[NSUserDefaults standardUserDefaults] objectForKey:kLoginKey])
    {
        label.text=@"请登录";
        [userButton setImage:[UIImage imageNamed:@"工具栏我的高亮.png"] forState:UIControlStateNormal];
    }
    else
    {
        User *user=[[BMNewsManager sharedManager]getMainUser];
        label.text=@"name";
        UIImageView *image;
        [image setImageWithURL:[NSURL URLWithString:user.avatar] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
        }];
        [userButton setImage:image.image forState:UIControlStateNormal];
        [userButton setUserInteractionEnabled:NO];
    }
    //NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:avatar]);
    
    [newsVC.view addSubview:userButton];
    [newsVC.view addSubview:label];
    [self addChildViewController:newsVC];
    [self.view addSubview:newsVC.view];

}
-(void)loginButtonClick
{
    UIView *bgView=[[UIView alloc]initWithFrame:self.view.bounds];
    UIView *mask=[[UIView alloc]initWithFrame:self.view.bounds];
    mask.alpha=0.5;
    mask.backgroundColor=[UIColor whiteColor];
    [bgView addSubview:mask];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
