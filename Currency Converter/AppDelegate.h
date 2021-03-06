//
//  AppDelegate.h
//  Currency Converter
//
//  Created by Luís Lira on 06/04/2020.
//  Copyright © 2020 Luís Lira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (strong, nonatomic) NSString *selectedTag;
@property (strong, nonatomic) NSString *fromCurrency;
@property (strong, nonatomic) NSString *toCurrency;


- (void)saveContext;


@end

