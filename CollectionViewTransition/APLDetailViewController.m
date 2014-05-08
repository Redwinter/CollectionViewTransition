/*
     File: APLDetailViewController.m
 Abstract: The view controller showing a single image (used as the detail view controller)
 
  Version: 1.1
 
Modified by Erik Fleuter 2014
 
 */

#import "APLDetailViewController.h"

@interface APLDetailViewController ()
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@end

#pragma mark -

@implementation APLDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    // setup our image view if an image was set to this view controller
    self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.x, self.image.size.width, self.image.size.height); //added
    self.imageView.image = self.image;
    
    
    
}

@end
