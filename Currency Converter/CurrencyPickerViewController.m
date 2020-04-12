//
//  CurrencyPickerViewController.m
//  Currency Converter
//
//  Created by Luís Lira on 06/04/2020.
//  Copyright © 2020 Luís Lira. All rights reserved.
//

#import "CurrencyPickerViewController.h"
#import "CurrencyTableViewCell.h"
#import "Constants.h"
#import "RatesViewController.h"
#import "AppDelegate.h"

@interface CurrencyPickerViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *currenciesTableView;
@property (strong, nonatomic)  NSIndexPath* lastIndexPath;
@property (weak, nonatomic) IBOutlet UISearchBar *currencySearchBar;


@property (strong,nonatomic) NSMutableArray *filteredResults;
@property BOOL isFiltered;

@end

@implementation CurrencyPickerViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isFiltered = NO;
    self.currencySearchBar.delegate = self;
    if(self.currenciesKeys==nil){
        self.currenciesTableView.hidden=YES;
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"NO_CONNECTION", @"")
                                                                       message:NSLocalizedString(@"CHECK_CONNECTION", @"")
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    [self.currenciesTableView registerNib:[UINib nibWithNibName:@"CurrencyTableViewCell" bundle:nil]
                   forCellReuseIdentifier:@"CurrencyCell"];
}
#pragma mark - TableView (delegate, dataSource)

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(searchText.length==0){
        self.isFiltered=NO;
    } else{
        self.isFiltered =YES;
        self.filteredResults = [[NSMutableArray alloc]init];
        
        for(NSString *key in self.currenciesKeys){
            NSRange nameRange = [key rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (nameRange.location != NSNotFound) {
                [self.filteredResults addObject:key];
            }
        }
    }
    [self.currenciesTableView reloadData];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"CurrencyCell";
    
    CurrencyTableViewCell *cell = (CurrencyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if ([indexPath compare:self.lastIndexPath] == NSOrderedSame){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if(self.isFiltered){
        NSString *filterKey = self.filteredResults[indexPath.row];
        cell.currencyImageView.image = [UIImage imageNamed:filterKey];
        cell.currencyTagLabel.text = filterKey;
        cell.currencyNameLabel.text = [NSString stringWithFormat:@"%@",[self.currenciesNames objectForKey:filterKey]];
    } else{
        NSString *key = self.currenciesKeys[indexPath.row];
        cell.currencyImageView.image = [UIImage imageNamed:key];
        cell.currencyTagLabel.text = key;
        cell.currencyNameLabel.text = [NSString stringWithFormat:@"%@",[self.currenciesNames objectForKey:key]];
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.isFiltered){
        return [self.filteredResults count];
    }
    return [self.currenciesKeys count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROW_HEIGHT_RATES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.lastIndexPath = indexPath;
    [tableView reloadData];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *key;
    if(self.isFiltered){
        key = self.filteredResults[indexPath.row];
    } else{
        key = self.currenciesKeys[indexPath.row];
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:key forKey:@"favorite_base_currency"];
    [userDefaults synchronize];
    
    switch ([self.returnFlag integerValue]) {
        case 0:
            delegate.selectedTag = key;
            break;
        case 1:
            delegate.fromCurrency = key;
            
            break;
        case 2:
            delegate.toCurrency = key;
            break;
        default:
            break;
    }
    [self.navigationController popViewControllerAnimated:YES];
}




@end
