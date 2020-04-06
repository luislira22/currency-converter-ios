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

@interface CurrencyPickerViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *currenciesTableView;

@end

@implementation CurrencyPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.currenciesTableView registerNib:[UINib nibWithNibName:@"CurrencyTableViewCell" bundle:nil]
     forCellReuseIdentifier:@"CurrencyCell"];}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"CurrencyCell";
        
        CurrencyTableViewCell *cell = (CurrencyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CurrencyCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
    //    cell.filmNameLabel.text = [[self.filmsResponse objectAtIndex:indexPath.row]objectForKey:@"title"];
    //    cell.yearLabel.text = [[self.filmsResponse objectAtIndex:indexPath.row]objectForKey:@"release_date"];
        return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


@end
