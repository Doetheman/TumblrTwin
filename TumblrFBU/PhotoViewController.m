//
//  PhotoViewController.m
//  TumblrFBU
//
//  Created by Dorian Holmes on 6/27/18.
//  Copyright © 2018 Dorian Holmes. All rights reserved.
//
#import "PhotoViewController.h"
#import "UIImageView+AFNetworking.h"
#import "PhotoCellTableViewCell.h"


@interface PhotoViewController () 

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *posts;
@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSURL *url = [NSURL URLWithString:@"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@", dataDictionary);
            
            // TODO: Get the posts and store in posts property
            // TODO: Reload the table view
            // Get the dictionary from the response key
            NSDictionary *responseDictionary = dataDictionary[@"response"];
            // Store the returned array of dictionaries in our posts property
            self.posts = responseDictionary[@"posts"];

            [self.tableView reloadData];
        }
    }];
    [task resume];
    self.tableView.rowHeight = 260;

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// TABLE VIEW FUNCTIONS

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
 
 



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoCell" forIndexPath:indexPath];
   
    
NSDictionary *post = self.posts[indexPath.row];
NSArray *photos = post[@"photos"];
    if (photos) {
    // 1. Get the first photo in the photos array
    NSDictionary *photo = photos[0];
    
    // 2. Get the original size dictionary from the photo
    NSDictionary *originalSize =  photo[@"original_size"];
    
    // 3. Get the url string from the original size dictionary
    NSString *urlString = originalSize[@"url"];
    
    // 4. Create a URL using the urlString
    NSURL *url = [NSURL URLWithString:urlString];
        // Download the image
        [cell.tumblrDataCell setImageWithURL:url];
        
    };
    
    
    return cell;

}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */



@end
