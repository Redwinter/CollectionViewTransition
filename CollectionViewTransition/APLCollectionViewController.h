/*
     File: APLCollectionViewController.h
 Abstract: Base UICollectionViewController containing the basic functionality for collection views.
  Version: 1.1
 
 Modified within interpreted permission constraints from AppleVersion by Erik Fleuter for test
 Copyright (C) ErikFleuter 2014
 
 */


@import UIKit;

@interface APLCollectionViewController : UICollectionViewController

@property (strong,nonatomic) NSMutableArray* imageURLS;

- (UICollectionViewController *)nextViewControllerAtPoint:(CGPoint)p;

@end
