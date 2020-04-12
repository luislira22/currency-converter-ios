//
//  CalculatorViewController.m
//  Currency Converter
//
//  Created by Luís Lira on 06/04/2020.
//  Copyright © 2020 Luís Lira. All rights reserved.
//

#import "CalculatorViewController.h"
#import "AFNetworking.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "Currency.h"
#import "CurrencyPickerViewController.h"

@interface CalculatorViewController ()

@property (weak, nonatomic) IBOutlet UILabel *currency1TagLabel;
@property (weak, nonatomic) IBOutlet UILabel *currency1NameLabel;
@property (weak, nonatomic) IBOutlet UITextField *currency1TextField;
@property (weak, nonatomic) IBOutlet UIImageView *currency1ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *currency2ImageView;

@property (weak, nonatomic) IBOutlet UILabel *currency2TagLabel;
@property (weak, nonatomic) IBOutlet UILabel *currency2NameLabel;
@property (weak, nonatomic) IBOutlet UITextField *currency2TextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) NSDictionary *rates;
@property (strong, nonatomic) NSDictionary *names;

@property (strong,nonatomic) Currency *from;
@property (strong,nonatomic) Currency *to;
@property (strong,nonatomic) NSString *amount;
@property (weak, nonatomic) IBOutlet UIButton *calculateButton;
@property (weak, nonatomic) IBOutlet UIButton *currency1Button;
@property (weak, nonatomic) IBOutlet UIButton *currency2Button;
@property (weak, nonatomic) IBOutlet UIButton *swapButton;

@end

@implementation CalculatorViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set UI elements
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    [self.currency1TextField setKeyboardType:UIKeyboardTypeDecimalPad];
    [self loadingData];
    
    [self.currency1NameLabel setText:NSLocalizedString(@"CURRENCY",@"")];
    [self.currency2NameLabel setText:NSLocalizedString(@"CURRENCY",@"")];

}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(delegate.fromCurrency!=nil){
        self.from = [self defineCurrency:delegate.fromCurrency];
        self.currency1TagLabel.text= self.from.tag;
        self.currency1NameLabel.text= self.from.name;
        self.currency1ImageView.image = self.from.image;
    }
    if(delegate.toCurrency!=nil){
        self.to = [self defineCurrency:delegate.toCurrency];
        self.currency2TagLabel.text= self.to.tag;
        self.currency2NameLabel.text= self.to.name;
        self.currency2ImageView.image = self.to.image;
    }
}

#pragma mark - API

- (void) performGETData:(NSString *)requestPath :(NSDictionary *)parameters :(void (^)(NSDictionary *output))success error:(void (^)(NSError *error))failure{
    [self.activityIndicator startAnimating];
    AFHTTPSessionManager *manager   = [AFHTTPSessionManager manager];
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [manager GET:[NSString stringWithFormat:@"%@%@", BASE_URL_API, requestPath] parameters:parameters headers:nil progress:nil
         
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // NSLog(@"Reply GET JSON: %@", responseObject);
        [self.activityIndicator stopAnimating];
        self.currency1Button.enabled = YES;
        self.currency2Button.enabled=YES;
        success(responseObject);
    }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // NSLog(@"Error: %@", error);
        [self.activityIndicator stopAnimating];
        failure(error);
    }];
}


- (void) loadingData{
    NSDictionary *parameters = @{
        @"access_key":ACCESS_KEY_API,
    };
    [self performGETData: LATEST_RATES_ENDPOINT :parameters :^(NSDictionary *output) {
        self.rates = [output objectForKey:@"rates"];
        self.keys = [self.rates allKeys];
        self.keys = [self.keys sortedArrayUsingSelector:@selector(compare:)];
        self.calculateButton.enabled=YES;
        self.currency1Button.enabled=YES;
        self.currency2Button.enabled=YES;
        self.swapButton.enabled =YES;
        self.currency1NameLabel.text = NSLocalizedString(@"CURRENCY", @"");
        self.currency2NameLabel.text = NSLocalizedString(@"CURRENCY", @"");

        
        
    } error:^(NSError *error) {
        self.calculateButton.enabled=NO;
        self.currency1Button.enabled=NO;
        self.currency2Button.enabled=NO;
        self.swapButton.enabled =NO;

        UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"SERVICE_UNAVAILABLE", @"")
                                                                       message:NSLocalizedString(@"CHECK_CONNECTION", @"")
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    [self performGETData: CURRENCY_NAME_ENDPOINT :parameters :^(NSDictionary *output) {
        self.names = [output objectForKey:@"symbols"];
    } error:^(NSError *error) {
        self.currency1NameLabel.text= NSLocalizedString(@"UNABLE_TO_RETRIEVE_CALCULATOR_VIEW", @"");
        self.currency2NameLabel.text= NSLocalizedString(@"UNABLE_TO_RETRIEVE_CALCULATOR_VIEW", @"");
    }];
}

#pragma mark - IBAction

- (IBAction)refreshDataTapped:(UIButton *)sender {
    [self loadingData];
    
}
- (IBAction)currency1SelectionTapped:(UIButton *)sender {
    CurrencyPickerViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Currencies"];
    vc.currenciesRates = self.rates;
    vc.currenciesKeys = self.keys;
    vc.currenciesNames = self.names;
    vc.returnFlag = [NSNumber numberWithInt:1];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)currency2SelectionTapped:(UIButton *)sender {
    CurrencyPickerViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Currencies"];
    vc.currenciesRates = self.rates;
    vc.currenciesKeys = self.keys;
    vc.currenciesNames = self.names;
    vc.returnFlag = [NSNumber numberWithInt:2];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)swapCurrenciesTapped:(UIButton *)sender {
    Currency *temp;
    temp =self.from;
    self.from=self.to;
    self.to=temp;
    
    
    self.currency1TagLabel.text= self.from.tag;
    self.currency1NameLabel.text= self.from.name;
    self.currency1ImageView.image = self.from.image;
    self.currency2TagLabel.text= self.to.tag;
    self.currency2NameLabel.text= self.to.name;
    self.currency2ImageView.image = self.to.image;
    
    
    
    if(self.currency1TagLabel.text==nil || self.currency2TagLabel.text==nil){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"NOT_ALLOWED", @"")
                                                                       message:NSLocalizedString(@"SELECT_CURRENCY", @"")
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        [self.currency1NameLabel setText:NSLocalizedString(@"CURRENCY",@"")];
        [self.currency2NameLabel setText:NSLocalizedString(@"CURRENCY",@"")];
    }     else{
        [self performConversion];
    }
}

- (IBAction)calculateValueTapped:(UIButton *)sender {
    [self performConversion];
}

#pragma mark - Auxiliar
- (Currency *) defineCurrency:(NSString *)tag{
    Currency *currency = [[Currency alloc]initWithTag:tag];
    currency.name=[NSString stringWithFormat:@"%@",[self.names objectForKey:tag]];
    return currency;
}

- (void) performConversion{
    if([self.currency1TextField.text isEqual:@""]){
        self.amount=@"1";
        [self.currency1TextField setText:@"1"];
    }else{
        self.amount=self.currency1TextField.text;
    }
    NSDictionary *parametersConversion = @{
        @"access_key":ACCESS_KEY_API,
        @"from":self.from.tag,
        @"to":self.to.tag,
        @"amount":self.amount,
    };
    [self performGETData: CONVERSION_ENDPOINT :parametersConversion :^(NSDictionary *output) {
        NSNumber *result = [output objectForKey:@"result"];
        self.currency2TextField.text = [NSString stringWithFormat:@"%@",result];
    } error:^(NSError *error) {
    }];
}

-(void)dismissKeyboard{
    [self.currency1TextField resignFirstResponder];
}

@end
