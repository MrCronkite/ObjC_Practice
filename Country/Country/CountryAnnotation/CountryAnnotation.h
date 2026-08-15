//
//  CountryAnnotation.h
//  Country
//
//  Created by Влад Шимченко on 15.08.2026.
//

// CountryAnnotation.h
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CountryAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSString *subtitle;

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate
                              title:(nullable NSString *)title
                           subtitle:(nullable NSString *)subtitle;

@end

NS_ASSUME_NONNULL_END
