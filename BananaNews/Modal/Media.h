//
//  Media.h
//  BananaNews
//
//  Created by 龚涛 on 1/3/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Media : NSManagedObject

@property (nonatomic, retain) NSNumber * mid;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * large;
@property (nonatomic, retain) NSString * small;
@property (nonatomic, retain) NSSet *news;
@end

@interface Media (CoreDataGeneratedAccessors)

- (void)addNewsObject:(NSManagedObject *)value;
- (void)removeNewsObject:(NSManagedObject *)value;
- (void)addNews:(NSSet *)values;
- (void)removeNews:(NSSet *)values;

@end
