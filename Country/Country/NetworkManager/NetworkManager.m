//
//  NetworkManager.m
//  Country
//
//  Created by Влад Шимченко on 14.08.2026.
//

// NetworkManager.m
#import "NetworkManager.h"

static NSString * const kCountriesURL =
@"https://api.restcountries.com/countries/v5";

static NSString * const kCountriesToken =
@"rc_live_demo";

@interface NetworkManager ()
@property (nonatomic, strong) NSURLSession *session;
@end

@implementation NetworkManager

+ (instancetype)shared {
    static NetworkManager *instance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        instance = [[NetworkManager alloc] init];
    });

    return instance;
}

- (instancetype)init {
    self = [super init];

    if (self) {
        NSURLSessionConfiguration *config =
        [NSURLSessionConfiguration defaultSessionConfiguration];

        config.timeoutIntervalForRequest = 20.0;

        _session = [NSURLSession sessionWithConfiguration:config];
    }

    return self;
}

- (void)fetchAllCountriesWithCompletion:(CountriesCompletion)completion {

    NSURL *url = [NSURL URLWithString:kCountriesURL];

    if (!url) {
        NSError *error = [NSError errorWithDomain:@"NetworkManager"
                                             code:-1
                                         userInfo:@{
            NSLocalizedDescriptionKey: @"Invalid URL"
        }];

        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });

        return;
    }

    // Создаем request вместо dataTaskWithURL:
    NSMutableURLRequest *request =
    [NSMutableURLRequest requestWithURL:url];

    request.HTTPMethod = @"GET";

    // Authorization: Bearer rc_live_demo
    NSString *authorization =
    [NSString stringWithFormat:@"Bearer %@", kCountriesToken];

    [request setValue:authorization
   forHTTPHeaderField:@"Authorization"];

    [request setValue:@"application/json"
   forHTTPHeaderField:@"Accept"];

    NSURLSessionDataTask *task =
    [self.session dataTaskWithRequest:request
                    completionHandler:^(NSData * _Nullable data,
                                        NSURLResponse * _Nullable response,
                                        NSError * _Nullable error) {

        // Network error
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, error);
            });

            return;
        }

        // HTTP status
        NSHTTPURLResponse *httpResponse =
        (NSHTTPURLResponse *)response;

        if (httpResponse.statusCode != 200) {

            NSError *statusError =
            [NSError errorWithDomain:@"NetworkManager"
                                code:httpResponse.statusCode
                            userInfo:@{
                NSLocalizedDescriptionKey:
                    [NSString stringWithFormat:
                     @"Server returned status %ld",
                     (long)httpResponse.statusCode]
            }];

            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, statusError);
            });

            return;
        }

        // JSON parsing
        NSError *jsonError = nil;

        id json =
        [NSJSONSerialization JSONObjectWithData:data
                                        options:0
                                          error:&jsonError];

        if (jsonError) {

            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, jsonError);
            });

            return;
        }

        if (![json isKindOfClass:[NSDictionary class]]) {
            NSError *formatError =
            [NSError errorWithDomain:@"NetworkManager"
                                code:-2
                            userInfo:@{
                NSLocalizedDescriptionKey: @"Unexpected response format"
            }];

            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, formatError);
            });

            return;
        }

        // Получаем data
        NSDictionary *root = (NSDictionary *)json;
        NSDictionary *dataObject = root[@"data"];

        // Получаем objects
        NSArray *rawArray = dataObject[@"objects"];

        if (![dataObject isKindOfClass:[NSDictionary class]] ||
            ![rawArray isKindOfClass:[NSArray class]]) {

            NSError *formatError =
            [NSError errorWithDomain:@"NetworkManager"
                                code:-3
                            userInfo:@{
                NSLocalizedDescriptionKey:
                    @"Missing 'data.objects' in response"
            }];

            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, formatError);
            });

            return;
        }

        NSMutableArray<Country *> *countries =
        [NSMutableArray arrayWithCapacity:rawArray.count];

        for (NSDictionary *dict in rawArray) {

            if (![dict isKindOfClass:[NSDictionary class]]) {
                continue;
            }

            Country *country =
            [[Country alloc] initWithDictionary:dict];

            [countries addObject:country];
        }

        // Sort alphabetically
        [countries sortUsingComparator:^NSComparisonResult(
                                                           Country *a,
                                                           Country *b
                                                           ) {

                                                               return [a.commonName compare:b.commonName];
                                                           }];

        // Return result on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(countries, nil);
        });
    }];

    [task resume];
}

@end
