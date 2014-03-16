//
//  AddViewController.m
//  ServerApp
//
//  Created by scott mehus on 3/15/14.
//  Copyright (c) 2014 scott mehus. All rights reserved.
//

#import "AddViewController.h"
#import "Item.h"
#import <AFNetworking/AFNetworking.h>

@interface AddViewController ()

@property (nonatomic, strong) IBOutlet UITextField *titleField;

@property (nonatomic, strong) NSString *baseURL;

- (IBAction)addItem:(id)sender;

@end

@implementation AddViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.baseURL = @"http://stormy-escarpment-3042.herokuapp.com";
    //self.baseURL = @"http://localhost:5000";
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)postMe {
    
    
    NSURL *baseURL = [NSURL URLWithString:self.baseURL];
    
    Item *newItem = [[Item alloc] init];
    newItem.title = self.titleField.text;
    
    NSDictionary *paramz = @{@"itemTitle" : newItem.title};
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    [manager POST:@"add" parameters:paramz success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"POST SUCCESS %@", responseObject);
        [self.delegate didAddItem];
        [self dismissViewControllerAnimated:YES completion:nil];

        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"POST FAIL %@", error);
        
    }];
}

- (IBAction)addItem:(id)sender {
    
    [self postMe];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [self.titleField resignFirstResponder];
    }
}


@end
