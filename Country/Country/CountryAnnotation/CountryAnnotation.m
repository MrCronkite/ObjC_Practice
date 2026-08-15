//
//  CountryAnnotation.m
//  Country
//
//  Created by Влад Шимченко on 15.08.2026.
//

// CountryAnnotation.m
#import "CountryAnnotation.h"

@implementation CountryAnnotation

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate
                              title:(nullable NSString *)title
                           subtitle:(nullable NSString *)subtitle {
    self = [super init];
    if (self) {
        _coordinate = coordinate;
        _title = [title copy];
        _subtitle = [subtitle copy];
    }
    return self;
}

@end
