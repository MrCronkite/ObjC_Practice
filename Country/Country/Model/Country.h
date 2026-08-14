//
//  Country.h
//  Country
//
//  Created by Влад Шимченко on 14.08.2026.
//

// Country.h
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Country : NSObject

@property (nonatomic, copy) NSString *commonName;
@property (nonatomic, copy) NSString *officialName;

@property (nonatomic, copy, nullable) NSString *alpha2Code;
@property (nonatomic, copy, nullable) NSString *alpha3Code;

@property (nonatomic, copy, nullable) NSString *capital;

@property (nonatomic, copy, nullable) NSString *region;
@property (nonatomic, copy, nullable) NSString *subregion;
@property (nonatomic, copy, nullable) NSArray<NSString *> *continents;

@property (nonatomic, assign) NSInteger population;
@property (nonatomic, assign) double areaKm2;
@property (nonatomic, assign) BOOL landlocked;

@property (nonatomic, copy, nullable) NSString *flagEmoji;
@property (nonatomic, copy, nullable) NSString *flagPngURL;
@property (nonatomic, copy, nullable) NSString *flagSvgURL;
@property (nonatomic, copy, nullable) NSString *flagDescription;

@property (nonatomic, copy, nullable) NSArray<NSString *> *currencyNames;
@property (nonatomic, copy, nullable) NSArray<NSString *> *languageNames;
@property (nonatomic, copy, nullable) NSArray<NSString *> *timezones;
@property (nonatomic, copy, nullable) NSArray<NSString *> *borders;
@property (nonatomic, copy, nullable) NSArray<NSString *> *callingCodes;
@property (nonatomic, copy, nullable) NSArray<NSString *> *tlds;

@property (nonatomic, copy, nullable) NSString *governmentType;

// leaders: массив словарей вида {"name": ..., "title": ...}
@property (nonatomic, copy, nullable) NSArray<NSDictionary<NSString *, NSString *> *> *leaders;

@property (nonatomic, copy, nullable) NSString *wikipediaURL;
@property (nonatomic, copy, nullable) NSString *officialSiteURL;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
