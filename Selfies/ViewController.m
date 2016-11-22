//
//  ViewController.m
//  Selfies
//
//  Created by Stefan Verveniotis on 2016-11-21.
//  Copyright © 2016 Stefan Verveniotis. All rights reserved.
//

#import "ViewController.h"
#import "PhotoViewCell.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (nonatomic) NSArray * repos;
@property (nonatomic) NSMutableArray <Photo *> * photoArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.photoArray = [NSMutableArray new];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)self.photoCollectionView.collectionViewLayout;
    layout.itemSize = CGSizeMake(self.view.bounds.size.width/2, self.view.bounds.size.width/2);
    
    NSURL *url = [NSURL URLWithString:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=ba6e9d8cf12ab06de7e7d7668c94cd32&tags=cat&has_geo=1"];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        
        
        if (error) { // 1
            // Handle the error
            NSLog(@"error: %@", error.localizedDescription);
            return;
        }
        
        NSError *jsonError = nil;
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError]; // 2
        self.repos = [[dataDict objectForKey:@"photos"] objectForKey:@"photo"];
        if (jsonError) { // 3
            // Handle the error
            NSLog(@"jsonError: %@", jsonError.localizedDescription);
            return;
        }
        
        // If we reach this point, we have successfully retrieved the JSON from the API
        for (NSDictionary *photo in self.repos) {
            
            NSString *urlString = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg", [photo objectForKey:@"farm"], [photo objectForKey:@"server"], [photo objectForKey:@"id"], [photo objectForKey:@"secret"]];
            NSURL *photoUrl = [NSURL URLWithString:urlString];
//            NSLog(@"url: %@", urlString);
            NSURLRequest *photoRequest = [[NSURLRequest alloc] initWithURL:photoUrl];
            
            
            
            
            NSURLSessionDataTask *photoDataTask = [session dataTaskWithRequest:photoRequest completionHandler:^(NSData * _Nullable photoData, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                
                
                if (error) { // 1
                    // Handle the error
                    NSLog(@"error: %@", error.localizedDescription);
                    return;
                }
                
               
                UIImage *currentPhoto = [UIImage imageWithData:photoData];
                Photo * newPhoto = [Photo new];
                newPhoto.photo = currentPhoto;
                newPhoto.label = [photo objectForKey:@"title"];
                [self.photoArray addObject:newPhoto];
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self.photoCollectionView reloadData];
                }];
            }];
            [photoDataTask resume];
            
            
        }
        
    }];
   // [self.photoCollectionView reloadData];
    [dataTask resume];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark Collection View Delegate Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.repos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [PhotoViewCell new];
        
    }
    if (self.photoArray.count > indexPath.row) {
        cell.photo.image = self.photoArray[indexPath.row].photo;
        cell.label.text = self.photoArray[indexPath.row].label;
    }
    return cell;
}


@end
