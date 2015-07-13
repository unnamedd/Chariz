//
//  CHRCharizWebScriptObject.h
//  Chariz
//
//  Created by Adam D on 13/07/2015.
//  Copyright (c) 2015 HASHBANG Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CPMPackageManagerAggregate;

@interface CHRCharizWebScriptObject : NSObject

@property (strong, nonatomic, readonly) CPMPackageManagerAggregate *packageManagerAggregate;

@end
