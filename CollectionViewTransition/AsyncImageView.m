//
//  AsyncImageView.m
//  CollectionViewTransition
//
//  Created by Erik Fleuter on 5/7/14.
//  Copyright (c) 2014 Apple, Inc. All rights reserved.
//

#import "AsyncImageView.h"

@implementation AsyncImageView

- (void)loadImageFromURL:(NSURL*)url {
    
    // start fresh
    self.connection = nil;
    self.data = nil;
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:60.0];
    self.connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self];
    //TODO error handling, what if connection is nil?
}

- (void)connection:(NSURLConnection *)theConnection
    didReceiveData:(NSData *)incrementalData {
    if (self.data==nil) {
        self.data =
        [[NSMutableData alloc] initWithCapacity:2048];
    }
    [self.data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
    
    self.connection=nil;
    
    if ([[self subviews] count]>0) {
        [[[self subviews] objectAtIndex:0] removeFromSuperview];
    }
    
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:self.data]];
    
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    //imageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth || UIViewAutoresizingFlexibleHeight );
    
    [self addSubview:imageView];
    imageView.frame = self.bounds;
    [imageView setNeedsLayout];
    [self setNeedsLayout];
    self.data=nil;
}

- (UIImage*) image {
    UIImageView* iv = [[self subviews] objectAtIndex:0];
    return [iv image];
}



@end
