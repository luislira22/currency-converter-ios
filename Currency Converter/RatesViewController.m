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

@interface RatesViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *ratesTableView;

@end

@implementation RatesViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
   [self.ratesTableView registerNib:[UINib nibWithNibName:@"RatesTableViewCell" bundle:nil]
    forCellReuseIdentifier:@"RateCell"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - IBAction

- (IBAction)refreshDataTapped:(UIBarButtonItem *)sender {
}

- (IBAction)selectBaseCurrencyTapped:(UIButton *)sender {
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
//    cell.filmNameLabel.text = [[self.filmsResponse objectAtIndex:indexPath.row]objectForKey:@"title"];
//    cell.yearLabel.text = [[self.filmsResponse objectAtIndex:indexPath.row]objectForKey:@"release_date"];
    return cell;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return rowHeight;
}


@end
