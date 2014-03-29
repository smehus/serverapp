//
//  ViewController.m
//  ServerApp
//
//  Created by scott mehus on 3/2/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "Item.h"
#import "SSStackedPageView.h"
#import "UIColor+CatColors.h"
#import "AddViewController.h"
#import "ItemView.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController () <UITableViewDataSource,
                                UITableViewDelegate,
                                SSStackedViewDelegate,
                                AddViewControllerDelegate,
                                UIGestureRecognizerDelegate>


@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSString *post;
@property (nonatomic, strong) NSString *baseURL;
@property (nonatomic, strong) NSString *delete;

@property (nonatomic, strong) IBOutlet SSStackedPageView *stackView;
@property (nonatomic, strong) NSMutableArray *views;

- (IBAction)addItem:(id)sender;
- (IBAction)deleteItem:(id)sender;

@end

@implementation ViewController {
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.views = [[NSMutableArray alloc] initWithCapacity:10];
    self.view.backgroundColor = [UIColor blackColor];

 
    self.stackView.delegate = self;
    self.stackView.pagesHaveShadows = YES;
    self.stackView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.stackView];
    
    self.dataArray = [[NSMutableArray alloc] initWithCapacity:20];
    
    self.baseURL = @"http://stormy-escarpment-3042.herokuapp.com";
    //self.baseURL = @"http://localhost:5000";
    
    // localhost doesn't work without internet connection?
    [self getAllItems];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//WORKS DONT FUCK WKTH
- (void)getAllItems {
    
    NSURL *baseURL = [NSURL URLWithString:self.baseURL];
 
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    [manager GET:@"/get" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"GET SUCCESS %@", responseObject);;
        
        [self parseItems:responseObject];

        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"GET FAIL %@", error);
    }];
    
    
}

- (void)postMe {
    

    NSURL *baseURL = [NSURL URLWithString:self.baseURL];
    
    Item *newItem = [[Item alloc] init];
    newItem.title = @"Bowzer";
    
     NSDictionary *paramz = @{@"itemTitle" : newItem.title};
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    [manager POST:@"add" parameters:paramz success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"POST SUCCESS %@", responseObject);
        [self getAllItems];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"POST FAIL %@", error);
        
    }];
}

- (void)parseItems:(NSArray *)items {
    
    [self.dataArray removeAllObjects];
    NSLog(@"data array count %lu", (unsigned long)self.dataArray.count);
    [self.views removeAllObjects];
    
    int i = 0;
    for (NSDictionary *dict in items) {
        i++;
        Item *item = [[Item alloc] initWithName:[dict objectForKey:@"itemTitle"] andID:[dict objectForKey:@"_id"]];
        UIView *thisView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 200.f, 100.f)];
        [self drawView:thisView andItem:item];
        
        [self.views addObject:thisView];
        [self.dataArray addObject:item];


    }
    
    
    [self.stackView layoutSubviews];
    
    NSNumber *count = [NSNumber numberWithInteger:self.dataArray.count];
    NSLog(@"count: %li", (long)[self numberOfPagesForStackView:self.stackView]);
   
}

- (void)drawView:(UIView *)view andItem:(Item *)item {
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, view.frame.size.width - 20, 50)];
    title.text = item.title;
    title.textColor = [UIColor blackColor];
    title.textAlignment = NSTextAlignmentCenter;
    
    
    [view addSubview:title];
    
}

// WORKS BUT THROWS THE DELETE FAIL ERROR - for some fucking reason
// Also need to call getAllItems before deleting a second time in order to get the new id from array
- (void)deleteItem {
    
    NSURL *baseURL = [NSURL URLWithString:self.baseURL];
    
    Item *item = self.dataArray[0];
    NSLog(@"ITEM ID %@", item.itemID);
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    [manager DELETE:@"deleteItem" parameters:@{@"_id" : item.itemID} success:^(NSURLSessionDataTask *task, id responseObject) {
      
      NSLog(@"DELETE SUCCESS %@", responseObject);
        [self getAllItems];
      
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
      
      NSLog(@"DELETE FAIL %@", error);
      [self getAllItems];
  }];
}

-(UIColor*)colorForIndex:(NSInteger) index {
    NSUInteger itemCount = self.dataArray.count - 1;
    float val = ((float)index / (float)itemCount) * 0.6;
    return [UIColor colorWithRed: 1.0 green:val blue: 0.0 alpha:1.0];
}


- (UIView *)stackView:(SSStackedPageView *)stackView pageForIndex:(NSInteger)index
{
    UIView *thisView = [stackView dequeueReusablePage];
    if (!thisView) {
        thisView = [self.views objectAtIndex:index];
        thisView.backgroundColor = [UIColor getRandomColor];
        thisView.layer.cornerRadius = 5;
        thisView.layer.masksToBounds = YES;
    }
    return thisView;
}



- (NSInteger)numberOfPagesForStackView:(SSStackedPageView *)stackView {
    
    return [self.views count];
}


- (void)stackView:(SSStackedPageView *)stackView selectedPageAtIndex:(NSInteger)index {
    
    
}

- (IBAction)addItem:(id)sender {
    
    [self postMe];

}

- (IBAction)deleteItem:(id)sender {
    
    [self deleteItem];
}

- (void)didAddItem {
    
    NSLog(@"DID ADD ITEM");
    
    [self getAllItems];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AddSegue"]) {
        AddViewController *controller = (AddViewController*)segue.destinationViewController;
        controller.delegate = self;

        
    }
}


















@end
