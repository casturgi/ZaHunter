//
//  ViewController.m
//  ZaHunter
//
//  Created by cory Sturgis on 10/14/15.
//  Copyright © 2015 CorySturgis. All rights reserved.
//
//#import "Pizzaria.h"
#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface ViewController () <MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>

@property NSArray *pizzaPlaces;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UITextView *myTextView;
@property BOOL didFind;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pizzaPlaces = [NSArray new];
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *location = locations.firstObject;
    if (location.verticalAccuracy < 1000 && location.horizontalAccuracy < 1000 && self.didFind == !YES) {
        self.didFind = YES;
        [self.locationManager stopUpdatingLocation];
        [self findPizzaNear:location];
    }
}

-(void)findPizzaNear:(CLLocation *)location{
    MKLocalSearchRequest *request = [MKLocalSearchRequest new];
    request.naturalLanguageQuery = @"Pizza";
    request.region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(1, 1));
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
        NSArray *mapItems = response.mapItems;
        [self saveAsArray:mapItems];
        self.myTextView.text = [NSString stringWithFormat:@"%@", self.pizzaPlaces];
    }];
}

-(void)saveAsArray:(NSArray *)inputArray{
    self.pizzaPlaces = [NSMutableArray arrayWithArray:inputArray];
    NSLog(@"%@",self.pizzaPlaces);
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.pizzaPlaces.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSString *name = [[self.pizzaPlaces objectAtIndex:indexPath.row] valueForKey:@"name"];
    cell.textLabel.text = name;
    return cell;
}


@end
