//
//  AsyncImageView.h
//  CollectionViewTransition
//
//  Created by Erik Fleuter on 5/7/14.
//  Copyright (c) 2014 Apple, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AsyncImageView : UIView
	//could instead be a subclass of UIImageView instead of UIView, depending on what other features you want to
	// to build into this class?
    
@property (nonatomic, strong) NSURLConnection* connection; //keep a reference to the connection so we can cancel download in dealloc
@property (nonatomic, strong)NSMutableData* data; //keep reference to the data so we can collect it as it downloads

//UIImage reference? We keep it in self.subviews - no need to re-code what we have in the parent class


- (void)loadImageFromURL:(NSURL*)url;
- (UIImage*) image;

@end

