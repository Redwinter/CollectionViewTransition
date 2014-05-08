/*
     File: APLCollectionViewController.m
 Abstract: Base UICollectionViewController containing the basic functionality for collection views.
  Version: 1.1
 
 Modified within interpreted permission constraints from AppleVersion by Erik Fleuter for test
 Copyright (C) ErikFleuter 2014
 
 */

#import "APLCollectionViewController.h"
#import "APLTransitionLayout.h"
#import "APLCollectionViewCell.h"

#define USE_IMAGES   1  // if 1 images are used for each cell, if 0 we use varying UIColors swatches for each cell

#define MAX_COUNT    24
#define CELL_ID      @"CELL_ID"


#pragma mark -

@implementation APLCollectionViewController

- (id)initWithCollectionViewLayout:(UICollectionViewFlowLayout *)layout
{
    if (self = [super initWithCollectionViewLayout:layout])
    {
        // make sure we know about our cell prototype so dequeueReusableCellWithReuseIdentifier can work
        [self.collectionView registerClass:[APLCollectionViewCell class] forCellWithReuseIdentifier:CELL_ID];
        
       
        self.imageURLS = [[NSMutableArray alloc] initWithObjects:@"http://tinyurl.com/qezd53j", @"http://tinyurl.com/murmbuk", @"http://tinyurl.com/mefege3", @"http://tinyurl.com/o4s6vpc", @"http://tinyurl.com/kth34vq",@"http://tinyurl.com/n9n4abz", nil];
        
         //TODO: try live image URLS from JSON maybe if Getty provides call?
        //self.imageURLS = [self getImageURLsForCategory:@"ACategoryName" inSize:nil];
        
    }
    return self;
}


#pragma mark -IMAGE LOADING-
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    APLCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_ID forIndexPath:indexPath];
    
#if USE_IMAGES
    // set the cell to use an image
    
    if((long)indexPath.item < [self.imageURLS count]){
        // TODO: try an AsyncImage maybe if we keep something like this
        NSString *imageURL = [self.imageURLS objectAtIndex:(long)indexPath.item];
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
        UIImage *pImage=[UIImage imageWithData:imageData];
        [cell.imageView setImage:pImage];
    }
    else{
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"sa%ld.jpg", (long)indexPath.item]];
    }
    
#else
    // set the cell to use a color swatch
    CGFloat hue = ((CGFloat)indexPath.item)/MAX_COUNT;
    UIColor *cellColor = [UIColor colorWithHue:hue saturation:1.0 brightness:1.0 alpha:1.0];
    cell.contentView.backgroundColor = cellColor;
#endif
    
    return cell;
}

#pragma mark -COLLECTION VIEW ARCANA-

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return MAX_COUNT;
}

- (UICollectionViewController *)nextViewControllerAtPoint:(CGPoint)p
{
    return nil; // subclass must override this method
}

// return our own UICollectionViewTransitionLayout object subclass to help in the transition
// the cell positions based on gesture position
//
- (UICollectionViewTransitionLayout *)collectionView:(UICollectionView *)collectionView transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout newLayout:(UICollectionViewLayout *)toLayout
{
    APLTransitionLayout *myCustomTransitionLayout =
        [[APLTransitionLayout alloc] initWithCurrentLayout:fromLayout nextLayout:toLayout];
    return myCustomTransitionLayout;
}


#pragma mark -JSON PARSING-
// JSON call if we want to try live URLS
- (NSMutableArray*)getImageURLsForCategory:(id)category inSize:(id)size
{
    NSLog(@"Fetching images for category %@ in size:%@", category, size);
    
    // TODO: URL goes here for getting JSON response
    NSString *urlString=[NSString stringWithFormat:@"actual url to use based on category %@",category];
    
    //after that convert that url nsutf8string
    NSString *encodedURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[[NSURL alloc]initWithString:encodedURL];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    NSURLResponse *response;
    __autoreleasing NSError* error = nil; // __autoreleasing is new way of [error autorelease]?
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    /**TODO: would want async so as to not block UI? [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
     // some completion handler here
     }];
     
     **/
    
    //id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    NSDictionary *JSONDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves|| NSJSONReadingMutableContainers error:&error];
    
    /** TODO: JSON may be array or dict for base, so prep for either
     NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: &e];
     
     if (!jsonArray)
     {
     NSLog(@"Error parsing JSON: %@", e);
     }
     else
     {
     for(NSDictionary *item in jsonArray) {
     NSLog(@"Item: %@", item);
     // sort out which one we need
     }
     }
     **/
    
    NSMutableArray *imageURLArr = [[NSMutableArray alloc]initWithCapacity:20];
    
    // tell us what's in the JSON & put the image URLs we need in the array
    if (JSONDict) {
        [self.imageURLS removeAllObjects]; // out with the old
    }
    [JSONDict enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id key, id obj, BOOL *stop) {
        NSLog(@"getImageURLS JSON contains key:%@, value:%@", key, obj);
        
        // TODO: add actual checkers
        if ([imageURLArr count] == MAX_COUNT) {
            *stop = YES;
        }
        if ([key isEqualToString:@"putActualImageKeyHere"] && YES) {
            // insert an image into the stored list so we can fetch it via URL
            [imageURLArr addObject:obj];
        }
    }];
    
    return imageURLArr;
}

@end
