//
//  MasterViewController.m
//  CoffeeKit
//
//  Created by freshlhy on 4/16/14.
//  Copyright (c) 2014 freshlhy. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

#import <RestKit/RestKit.h>
#import "Venue.h"
#import "Location.h"
#import "VenueCell.h"

#define kCLIENTID @"P3EQ2FMZA4CV4KMQCYI1SKCBONAM43ZKXKTHQ03SK5AYIBGN"
#define kCLIENTSECRET @"1I2ZHLI4QDKDFKNI012ASOVB4UELDZRGBBNLDM3BT2PXTQZM"

@interface MasterViewController ()
@property(nonatomic, strong) NSArray *venues;
@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureRestKit];
    [self loadVenues];
}

- (void)configureRestKit {
    // initialize AFNetworking HTTPClient
    NSURL *baseURL = [NSURL URLWithString:@"https://api.foursquare.com"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];

    // initialize RestKit
    RKObjectManager *objectManager =
        [[RKObjectManager alloc] initWithHTTPClient:client];

    // setup object mappings
    RKObjectMapping *venueMapping =
        [RKObjectMapping mappingForClass:[Venue class]];
    [venueMapping addAttributeMappingsFromArray:@[ @"name" ]];

    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor
        responseDescriptorWithMapping:venueMapping
                               method:RKRequestMethodGET
                          pathPattern:@"/v2/venues/search"
                              keyPath:@"response.venues"
                          statusCodes:[NSIndexSet indexSetWithIndex:200]];

    [objectManager addResponseDescriptor:responseDescriptor];
    
    // define location object mapping
    RKObjectMapping *locationMapping = [RKObjectMapping mappingForClass:[Location class]];
    [locationMapping addAttributeMappingsFromArray:@[@"address", @"city", @"country", @"crossStreet", @"postalCode", @"state", @"distance", @"lat", @"lng"]];
    
    // define relationship mapping
    [venueMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"location" toKeyPath:@"location" withMapping:locationMapping]];

}

- (void)loadVenues {
    NSString *latLon = @"37.33,-122.03"; // approximate latLon of The Mothership
                                         // (a.k.a Apple headquarters)
    NSString *clientID = kCLIENTID;
    NSString *clientSecret = kCLIENTSECRET;

    NSDictionary *queryParams = @{
        @"ll" : latLon,
        @"client_id" : clientID,
        @"client_secret" : clientSecret,
        @"categoryId" : @"4bf58dd8d48988d1e0931735",
        @"v" : @"20140118"
    };

    [[RKObjectManager sharedManager] getObjectsAtPath:@"/v2/venues/search"
        parameters:queryParams
        success:^(RKObjectRequestOperation *operation,
                  RKMappingResult *mappingResult) {
            _venues = mappingResult.array;
            [self.tableView reloadData];
        }
        failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"What do you mean by 'there is no coffee?': %@", error);
        }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
    return _venues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                        forIndexPath:indexPath];

    Venue *venue = _venues[indexPath.row];
    cell.textLabel.text = venue.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0fm", venue.location.distance.floatValue];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView
    canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath
*)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath
*)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Venue *venue = _venues[indexPath.row];
        [[segue destinationViewController] setDetailItem:venue];
    }
}

@end
