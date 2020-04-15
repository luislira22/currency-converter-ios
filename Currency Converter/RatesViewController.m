//
//  RatesViewController.m
//  Currency Converter
//
//  Created by Luís Lira on 06/04/2020.
//  Copyright © 2020 Luís Lira. All rights reserved.
//

#import "RatesViewController.h"
#import "RatesTableViewCell.h"
#import "Constants.h"
#import "AFNetworking.h"
#import "Currency.h"
#import "CurrencyPickerViewController.h"
#import "AppDelegate.h"


@interface RatesViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingActivityIndicator;
@property (weak, nonatomic) IBOutlet UIView *baseCurrencyView;
@property (weak, nonatomic) IBOutlet UITableView *ratesTableView;
@property (weak, nonatomic) IBOutlet UIButton *currencyListButton;

@property (weak, nonatomic) IBOutlet UIImageView *currencyImageView;
@property (weak, nonatomic) IBOutlet UILabel *currencyTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *currencyNameLabel;
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;

@property (strong, nonatomic) NSDictionary *ratesResponse;
@property (strong,nonatomic) NSString *yesterdayDate;
@property (strong, nonatomic) NSDictionary *yesterdayRatesResponse;
@property (strong, nonatomic) NSDictionary *namesResponse;
@property (strong, nonatomic) NSString *baseCurrency;
@property (strong, nonatomic) NSString *date;
@property (strong,nonatomic) NSMutableArray *mutableKeys;
@property BOOL connectionFlag;

@end

@implementation RatesViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    //Hide when loading
    self.baseCurrencyView.hidden=YES;
    self.ratesTableView.hidden=YES;
    
    //Register table nib
    [self.ratesTableView registerNib:[UINib nibWithNibName:@"RatesTableViewCell" bundle:nil]
              forCellReuseIdentifier:@"RateCell"];
    [self loadData];
    
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //Hide when loading
    self.ratesTableView.hidden=YES;
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(delegate.selectedTag!=nil){
        self.baseCurrency = delegate.selectedTag;
        [self defineBaseCurrency:self.baseCurrency];
    }
    [self loadData];
        self.ratesTableView.hidden=NO;
}

#pragma mark - API

- (void) performGETData:(NSString *)requestPath :(NSDictionary *)parameters :(void (^)(NSDictionary *output))success error:(void (^)(NSError *error))failure{
    [self.loadingActivityIndicator startAnimating];
    AFHTTPSessionManager *manager   = [AFHTTPSessionManager manager];
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [manager GET:[NSString stringWithFormat:@"%@%@", BASE_URL_API, requestPath] parameters:parameters headers:nil progress:nil
     
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // NSLog(@"Reply GET JSON: %@", responseObject);
        success(responseObject);
        [self.loadingActivityIndicator stopAnimating];
        self.currencyListButton.enabled=YES;
        self.ratesTableView.hidden =NO;
        self.tapGesture.enabled = YES;
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // NSLog(@"Error: %@", error);
        failure(error);
        [self.loadingActivityIndicator stopAnimating];
        //self.ratesTableView.hidden =YES;
        self.currencyListButton.enabled=NO;
        self.tapGesture.enabled = NO;
        UIAlertController* alert = [UIAlertController alertControllerWithTitle: NSLocalizedString(@"SERVICE_UNAVAILABLE", @"")
                                                                       message:NSLocalizedString(@"CACHED_RESULTS", @"")
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}


- (void) loadData{
    self.ratesTableView.hidden=YES;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if(self.baseCurrency==nil){
        self.baseCurrency=  [userDefaults objectForKey:@"favorite_base_currency"];
        if(self.baseCurrency==nil){
            self.baseCurrency=BASE_CURRENCY_EUR;
        }
    }
    NSDictionary *parameters = @{
        @"access_key":ACCESS_KEY_API,
        @"base":self.baseCurrency
    };
    //API call for latest rates
    [self performGETData: LATEST_RATES_ENDPOINT :parameters :^(NSDictionary *output) {
        self.ratesResponse = [output objectForKey:@"rates"];
        [self.ratesTableView reloadData];
        self.rateKeys = [self.ratesResponse allKeys];
        self.rateKeys = [self.rateKeys sortedArrayUsingSelector:@selector(compare:)];
        self.mutableKeys = [NSMutableArray arrayWithArray:self.rateKeys];
        [self.mutableKeys removeObject:self.baseCurrency];
        self.baseCurrencyView.hidden=NO;
        [userDefaults setObject:self.ratesResponse forKey:@"stored_rates"];
        [userDefaults setObject:self.rateKeys forKey:@"stored_keys"];
        
    } error:^(NSError *error) {
        self.ratesResponse = [userDefaults objectForKey:@"stored_rates"];
        [self.ratesTableView reloadData];
        self.rateKeys = [userDefaults objectForKey:@"stored_keys"];
        self.baseCurrencyView.hidden=NO;
    }];
    
    //APi call for currency names
    [self performGETData: CURRENCY_NAME_ENDPOINT :parameters :^(NSDictionary *output) {
        self.namesResponse = [output objectForKey:@"symbols"];
        [self.ratesTableView reloadData];
        [self defineBaseCurrency:self.baseCurrency];
        [userDefaults setObject:self.namesResponse forKey:@"stored_names"];
    } error:^(NSError *error) {
        self.namesResponse = [userDefaults objectForKey:@"stored_names"];
        [self.ratesTableView reloadData];
        [self defineBaseCurrency:self.baseCurrency];
    }];
    
    //APi call for date
    [self performGETData: LATEST_RATES_ENDPOINT :parameters :^(NSDictionary *output) {
        self.date = [output objectForKey:@"timestamp"];
        [self.ratesTableView reloadData];
        [userDefaults setObject:self.date forKey:@"stored_date"];
    } error:^(NSError *error) {
        self.date = [userDefaults objectForKey:@"stored_date"];
        [self.ratesTableView reloadData];
    }];
    
    NSDateFormatter *dateFormatterSimple=[[NSDateFormatter alloc]init];
    [dateFormatterSimple setDateFormat:@"yyyy-MM-dd"];
    NSString *yesterdayTS =[self yesterdaysDateAsTimeStamp];
    self.yesterdayDate = [self formatDateWithString:yesterdayTS format:dateFormatterSimple];
    NSString *dateEndpoint = @"/";
    dateEndpoint = [dateEndpoint stringByAppendingString:self.yesterdayDate];
    
    //API call for yesterday's rates
    [self performGETData: dateEndpoint :parameters :^(NSDictionary *output) {
        self.yesterdayRatesResponse = [output objectForKey:@"rates"];
        [self.ratesTableView reloadData];
        self.connectionFlag=YES;
    } error:^(NSError *error) {
        self.connectionFlag=NO;
    }];
    self.ratesTableView.hidden=NO;
    
}

#pragma mark - IBAction

- (IBAction)refreshDataTapped:(UIBarButtonItem *)sender {
    [self loadData];
}

- (IBAction)selectBaseCurrencyTapped:(UIButton *)sender {
    CurrencyPickerViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Currencies"];
    vc.currenciesRates = self.ratesResponse;
    vc.currenciesNames = self.namesResponse;
    vc.currenciesKeys = self.rateKeys;
    vc.returnFlag = [NSNumber numberWithInt:0];
    vc.favoriteFlag = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)baseCurrencyTapped:(id)sender {
    [self selectBaseCurrencyTapped:sender];
}


#pragma mark - TableView (delegate, dataSource)

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"RateCell";
    
    RatesTableViewCell *cell = (RatesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RateCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSString *key = self.mutableKeys[indexPath.row]; // EUR, USD ex.
    cell.countryImageView.image = [UIImage imageNamed:key];
    cell.currencyBigTagLabel.text = key;
    cell.currencyMiniTagLabel.text = key;
    cell.currencyValueLabel.text = [NSString stringWithFormat:@"%@",[self.ratesResponse objectForKey:key]];
    cell.currencyNameLabel.text = [NSString stringWithFormat:@"%@",[self.namesResponse objectForKey:key]];
    
    NSString *today = [NSString stringWithFormat:@"%@",[self.ratesResponse objectForKey:key]];
    NSString *yesterday =[NSString stringWithFormat:@"%@",[self.yesterdayRatesResponse objectForKey:key]];
    double result;
    if(self.connectionFlag==YES){
        result = ([today doubleValue] - [yesterday doubleValue]);
    } else{
        result =0;
    }
    
    if(result>0){
        [cell.fluctuationLabel setTextColor:[UIColor greenColor]];
        cell.fluctuationLabel.text = [NSString stringWithFormat:@"+%f",result];
    } else if(result<0){
        [cell.fluctuationLabel setTextColor:[UIColor redColor]];
        cell.fluctuationLabel.text = [NSString stringWithFormat:@"%f",result];
        
    }else{
        [cell.fluctuationLabel setTextColor:[UIColor yellowColor]];
        cell.fluctuationLabel.text = [NSString stringWithFormat:@"%f",result];
    }
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    cell.dateLabel.text = [self formatDateWithString:self.date format:dateFormatter];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.ratesResponse count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROW_HEIGHT_RATES;
}

#pragma mark - Auxiliar

- (void) defineBaseCurrency:(NSString *)tag {
    Currency *currency = [[Currency alloc]init];
    currency.tag=tag;
    currency.name=[NSString stringWithFormat:@"%@",[self.namesResponse objectForKey:tag]];
    if([self.baseCurrency isEqual:@"EUR"]){
        currency.name=@"Euro";
    }
    currency.image=[UIImage imageNamed:currency.tag];
    self.currencyTagLabel.text = currency.tag;
    self.currencyNameLabel.text = currency.name;
    self.currencyImageView.image = currency.image;
}

- (NSString *) formatDateWithString:(NSString *)value format:(NSDateFormatter *)dateFormatter{
    double timestamp =  [value doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSString *dateString=[dateFormatter stringFromDate:date];
    return dateString;
}

- (NSString *) yesterdaysDateAsTimeStamp {
    NSDate *date = [NSDate date];
    NSDate *e = [date dateByAddingTimeInterval:(-60*60*24)];
    return [NSString stringWithFormat:@"%f",[e timeIntervalSince1970]];
}

@end
