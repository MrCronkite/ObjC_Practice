//
//  Country.m
//  Country
//
//  Created by Влад Шимченко on 14.08.2026.
//

// Country.m
#import "Country.h"

@implementation Country

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        // names
        NSDictionary *names = dict[@"names"];
        self.commonName = names[@"common"] ?: @"Unknown";
        self.officialName = names[@"official"] ?: self.commonName;

        // codes
        NSDictionary *codes = dict[@"codes"];
        self.alpha2Code = codes[@"alpha_2"];
        self.alpha3Code = codes[@"alpha_3"];

        // capitals — массив объектов, берём "primary" или первый
        NSArray *capitalsArr = dict[@"capitals"];
        self.capital = [self primaryCapitalFromArray:capitalsArr];

        // region / subregion / continents
        self.region = dict[@"region"];
        self.subregion = dict[@"subregion"];
        self.continents = dict[@"continents"];

        // population / area / landlocked
        self.population = [dict[@"population"] integerValue];

        // coordinates
        NSDictionary *coordinatesDict = dict[@"coordinates"];
        if (coordinatesDict && coordinatesDict[@"lat"] && coordinatesDict[@"lng"]) {
            double lat = [coordinatesDict[@"lat"] doubleValue];
            double lng = [coordinatesDict[@"lng"] doubleValue];
            self.coordinate = CLLocationCoordinate2DMake(lat, lng);
            self.hasValidCoordinate = YES;
        } else {
            self.hasValidCoordinate = NO;
        }

        NSDictionary *area = dict[@"area"];
        self.areaKm2 = [area[@"kilometers"] doubleValue];

        self.landlocked = [dict[@"landlocked"] boolValue];

        // flag
        NSDictionary *flag = dict[@"flag"];
        self.flagEmoji = flag[@"emoji"];
        self.flagPngURL = flag[@"url_png"];
        self.flagSvgURL = flag[@"url_svg"];
        self.flagDescription = flag[@"description"];

        // currencies
        NSArray *currenciesArr = dict[@"currencies"];
        NSMutableArray *currencyNames = [NSMutableArray array];
        for (NSDictionary *currency in currenciesArr) {
            NSString *cName = currency[@"name"];
            if (cName) [currencyNames addObject:cName];
        }
        self.currencyNames = currencyNames;

        // languages
        NSArray *languagesArr = dict[@"languages"];
        NSMutableArray *languageNames = [NSMutableArray array];
        for (NSDictionary *language in languagesArr) {
            NSString *lName = language[@"name"];
            if (lName) [languageNames addObject:lName];
        }
        self.languageNames = languageNames;

        // timezones / borders / calling codes / tlds
        self.timezones = dict[@"timezones"];
        self.borders = dict[@"borders"];
        self.callingCodes = dict[@"calling_codes"];
        self.tlds = dict[@"tlds"];

        // government
        self.governmentType = dict[@"government_type"];

        // leaders — упрощаем до name/title
        NSArray *leadersArr = dict[@"leaders"];
        NSMutableArray *simplifiedLeaders = [NSMutableArray array];
        for (NSDictionary *leader in leadersArr) {
            NSString *name = leader[@"name"];
            NSString *title = leader[@"title"];
            if (name) {
                [simplifiedLeaders addObject:@{
                    @"name": name,
                    @"title": title ?: @""
                }];
            }
        }
        self.leaders = simplifiedLeaders;

        // links
        NSDictionary *links = dict[@"links"];
        self.wikipediaURL = links[@"wikipedia"];
        self.officialSiteURL = links[@"official"];
    }
    return self;
}

- (nullable NSString *)primaryCapitalFromArray:(NSArray *)capitalsArr {
    if (![capitalsArr isKindOfClass:[NSArray class]] || capitalsArr.count == 0) {
        return nil;
    }

    for (NSDictionary *capitalDict in capitalsArr) {
        NSDictionary *attributes = capitalDict[@"attributes"];
        BOOL isPrimary = [attributes[@"primary"] boolValue];
        if (isPrimary) {
            return capitalDict[@"name"];
        }
    }

    // если ни один не помечен primary — берём первый
    NSDictionary *first = capitalsArr.firstObject;
    return first[@"name"];
}

@end
