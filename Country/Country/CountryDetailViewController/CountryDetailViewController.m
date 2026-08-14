//
//  CountryDetailViewController.m
//  Country
//
//  Created by Влад Шимченко on 14.08.2026.
//

// CountryDetailViewController.m
#import "CountryDetailViewController.h"

@interface CountryDetailViewController ()

@property (nonatomic, strong) Country *country;
@property (nonatomic, strong) UIImageView *flagImageView;
@property (nonatomic, strong) UILabel *infoLabel;

@end

@implementation CountryDetailViewController

- (instancetype)initWithCountry:(Country *)country {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _country = country;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.title = self.country.commonName;

    [self setupFlagImageView];
    [self setupInfoLabel];
    [self loadFlagImage];
}

- (void)setupFlagImageView {
    self.flagImageView = [[UIImageView alloc] init];
    self.flagImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.flagImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.flagImageView.backgroundColor = [UIColor secondarySystemBackgroundColor];
    self.flagImageView.layer.cornerRadius = 8;
    self.flagImageView.clipsToBounds = YES;
    [self.view addSubview:self.flagImageView];

    [NSLayoutConstraint activateConstraints:@[
        [self.flagImageView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:16],
        [self.flagImageView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.flagImageView.widthAnchor constraintEqualToConstant:220],
        [self.flagImageView.heightAnchor constraintEqualToConstant:140],
    ]];
}

- (void)setupInfoLabel {
    self.infoLabel = [[UILabel alloc] init];
    self.infoLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.infoLabel.numberOfLines = 0;
    self.infoLabel.font = [UIFont systemFontOfSize:16];
    self.infoLabel.text = [self buildInfoText];
    [self.view addSubview:self.infoLabel];

    [NSLayoutConstraint activateConstraints:@[
        [self.infoLabel.topAnchor constraintEqualToAnchor:self.flagImageView.bottomAnchor constant:20],
        [self.infoLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16],
        [self.infoLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16],
    ]];
}

- (NSString *)buildInfoText {
    NSMutableString *text = [NSMutableString string];
    [text appendFormat:@"Official name: %@\n\n", self.country.officialName];
    [text appendFormat:@"Capital: %@\n\n", self.country.capital ?: @"—"];
    [text appendFormat:@"Region: %@ / %@\n\n", self.country.region ?: @"—", self.country.subregion ?: @"—"];
    [text appendFormat:@"Population: %@\n\n", [self formattedPopulation:self.country.population]];
    [text appendFormat:@"Currencies: %@\n\n",
        self.country.currencyNames.count
            ? [self.country.currencyNames componentsJoinedByString:@", "]
            : @"—"];
    [text appendFormat:@"Languages: %@\n\n",
     self.country.languageNames.count ? [self.country.languageNames componentsJoinedByString:@", "] : @"—"];
    [text appendFormat:@"Timezones: %@", self.country.timezones.count ? [self.country.timezones componentsJoinedByString:@", "] : @"—"];
    return text;
}

- (NSString *)formattedPopulation:(NSInteger)population {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    return [formatter stringFromNumber:@(population)];
}

- (void)loadFlagImage {
    if (!self.country.flagEmoji) return;
    NSURL *url = [NSURL URLWithString:self.country.flagEmoji];
    if (!url) return;

    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url
                                                               completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data && !error) {
            UIImage *image = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.flagImageView.image = image;
            });
        }
    }];
    [task resume];
}

@end
