//
//  NetworkManager.h
//  Country
//
//  Created by Влад Шимченко on 14.08.2026.
//

// NetworkManager.h
#import <Foundation/Foundation.h>
#import "Country.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^CountriesCompletion)(NSArray<Country *> * _Nullable countries, NSError * _Nullable error);

@interface NetworkManager : NSObject

+ (instancetype)shared;
- (void)fetchAllCountriesWithCompletion:(CountriesCompletion)completion;

@end

NS_ASSUME_NONNULL_END
