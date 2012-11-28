//
//  CtquanLocationsViewController.h
//  OO
//
//  Created by apple on 12-11-22.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface CtquanLocationsViewController : UITableViewController <BMKSearchDelegate, UISearchBarDelegate>
@property (strong, nonatomic) NSMutableArray *locations;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *locationTable;
@property (strong, nonatomic) IBOutlet UIButton *navTitle;
@property (nonatomic) BOOL isSearching;
@property (strong, nonatomic) BMKSearch *search;
@property (strong, nonatomic) BMKMapView *mapView;
@end
