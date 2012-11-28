//
//  CtquanLocationsViewController.m
//  OO
//
//  Created by apple on 12-11-22.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import "CtquanLocationsViewController.h"
#import "BMKMapView+Location.h"

@interface CtquanLocationsViewController ()

@end

@implementation CtquanLocationsViewController

@synthesize locations, locationTable, searchBar, mapView, search, navTitle;

- (void)getUserLocation {
	[[BMKMapView share] getLocationInSeconds:5
													begin:^{
														[navTitle setTitle:@"正在定位..." forState:UIControlStateNormal];
													} success:^{
														[navTitle setTitle:@"附近的位置" forState:UIControlStateNormal];
													} failure:nil];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	mapView.delegate = (id)self;
	search = [[BMKSearch alloc] init];
	search.delegate = self;
	[self performSelectorInBackground:@selector(getUserLocation) withObject:nil];
	[search reverseGeocode:[CtquanUser current].location.coordinate];
//	[search poiSearchInCity:@"北京" withKey:@"五道口" pageIndex:0];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return locations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"location";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (!cell)
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	UILabel *label = (UILabel *)[cell viewWithTag:1];
	if (locations.count)
		label.text = [[locations objectAtIndex:indexPath.row] performSelector:@selector(name)];
	return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark -
#pragma mark BMKSearchDelegate methods

- (void)onGetPoiResult:(NSArray *)poiResultList searchType:(int)type errorCode:(int)error	{
	if (error == BMKErrorOk) {
		BMKPoiResult* result = [poiResultList objectAtIndex:0];
		locations = (NSMutableArray *)result.poiInfoList;
		[locationTable reloadData];
	}
}

- (void)onGetAddrResult:(BMKAddrInfo*)result errorCode:(int)error {
	NSLog(@"%@", result);
	NSLog(@"222");
}

#pragma mark -
#pragma mark UISearchBarDelegate Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchbar {
	[searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	if (searchText.length == 0) return;
	[search poiSearchInCity:@"北京" withKey:searchText pageIndex:0];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
}

//- (void)viewDidUnload {
//	[self setSearchBar:nil];
//	[super viewDidUnload];
//}
- (void)viewDidUnload {
	[self setNavTitle:nil];
	[super viewDidUnload];
}
@end