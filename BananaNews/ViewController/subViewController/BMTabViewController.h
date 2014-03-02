//
//  BMTabViewController.h
//  BananaNews
//
//  Created by 龚涛 on 1/10/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BMTabViewControllerDelegate;

@interface BMTabViewController : UIViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, weak) id<BMTabViewControllerDelegate> delegate;

- (void)selectPage:(NSUInteger)page;

- (NSFetchRequest *)fetchRequest;

- (void)performFetch;

- (NSManagedObjectContext *)managedObjectContext;

- (NSInteger)pageNum;

- (void)tabsUpdate;

@end

@protocol BMTabViewControllerDelegate <NSObject>

@optional

- (void)didSelectTab:(BMTabViewController *)tabViewController index:(NSUInteger)index;

- (void)didReloadTab:(BMTabViewController *)tabViewController index:(NSUInteger)index;

@end
