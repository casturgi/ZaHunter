//
//  Pizzaria.m
//  ZaHunter
//
//  Created by cory Sturgis on 10/14/15.
//  Copyright © 2015 CorySturgis. All rights reserved.
//
#import <MapKit/MapKit.h>
#import "Pizzaria.h"

@implementation Pizzaria

-(instancetype)initWithSearch:(NSString *)searchString{
        self = [super init];
        if (self) {
            self.pizzaPlaceName = searchString;
        }
        return self;
}
@end