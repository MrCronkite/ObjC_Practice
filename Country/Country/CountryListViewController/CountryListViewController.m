//
//  CountryListViewController.m
//  Country
//
//  Created by Влад Шимченко on 14.08.2026.
//

// CountryListViewController.m
#import "CountryListViewController.h"
#import "CountryDetailViewController.h"
#import "NetworkManager.h"
#import "Country.h"

@interface CountryListViewController () <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, copy) NSArray<Country *> *allCountries;
@property (nonatomic, copy) NSArray<Country *> *filteredCountries;

@end

@implementation CountryListViewController

static NSString * const kCellID = @"CountryCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Countries";
    self.view.backgroundColor = [UIColor systemBackgroundColor];

    [self setupTableView];
    [self setupSearchController];
    [self setupSpinner];
    [self loadData];
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellID];
    [self.view addSubview:self.tableView];

    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    ]];
}

- (void)setupSearchController {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.obscuresBackgroundDuringPresentation = NO;
    self.searchController.searchBar.placeholder = @"Search country";
    self.navigationItem.searchController = self.searchController;
    self.navigationItem.hidesSearchBarWhenScrolling = NO;
    self.definesPresentationContext = YES;
}

- (void)setupSpinner {
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    self.spinner.translatesAutoresizingMaskIntoConstraints = NO;
    self.spinner.hidesWhenStopped = YES;
    [self.view addSubview:self.spinner];
    [NSLayoutConstraint activateConstraints:@[
        [self.spinner.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.spinner.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
    ]];
}

- (void)loadData {
    [self.spinner startAnimating];
    __weak typeof(self) weakSelf = self;
    [[NetworkManager shared] fetchAllCountriesWithCompletion:^(NSArray<Country *> * _Nullable countries, NSError * _Nullable error) {
        __strong typeof(weakSelf) self = weakSelf;
        if (!self) return;
        [self.spinner stopAnimating];

        if (error) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                          message:error.localizedDescription
                                   preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                [self loadData];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }

        self.allCountries = countries;
        self.filteredCountries = countries;
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredCountries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellID];
    }
    Country *country = self.filteredCountries[indexPath.row];
    NSString *flag = country.flagEmoji ?: @"";
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", flag, country.commonName];
    cell.detailTextLabel.text = country.capital ?: @"—";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Country *country = self.filteredCountries[indexPath.row];
    CountryDetailViewController *detailVC = [[CountryDetailViewController alloc] initWithCountry:country];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *query = searchController.searchBar.text ?: @"";
    if (query.length == 0) {
        self.filteredCountries = self.allCountries;
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"commonName CONTAINS[cd] %@", query];
        self.filteredCountries = [self.allCountries filteredArrayUsingPredicate:predicate];
    }
    [self.tableView reloadData];
}

@end
