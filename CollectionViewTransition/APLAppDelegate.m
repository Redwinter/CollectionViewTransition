/*
     File: APLAppDelegate.m
 Abstract: Template delegate for the application.
  Version: 1.1
 
 Modified by Erik Fleuter 2014
 
 */

#import "APLAppDelegate.h"
#import "APLTransitionManager.h"
#import "APLStackLayout.h"
#import "APLStackCollectionViewController.h"

@interface APLAppDelegate () <UINavigationControllerDelegate, APLTransitionManagerDelegate>

@property (nonatomic) APLTransitionManager *transitionManager;

@end


#pragma mark -

@implementation APLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
    
    // setup our layout and initial collection view
    APLStackLayout *stackLayout = [[APLStackLayout alloc] init];
    APLStackCollectionViewController *collectionViewController = [[APLStackCollectionViewController alloc] initWithCollectionViewLayout:stackLayout];
    collectionViewController.title = @"Getty Nature Images Stack";
    navController.navigationBar.translucent = NO;
    navController.delegate = self;
    
    // add the single collection view to our navigation controller
    [navController setViewControllers:@[collectionViewController]];
    
    // we want a light gray for the navigation bar, otherwise it defaults to white
    navController.navigationBar.barTintColor = [UIColor whiteColor];
    
    // create our "transitioning" object to manage the pinch gesture to transitition between stack and grid layouts
    _transitionManager =
        [[APLTransitionManager alloc] initWithCollectionView:collectionViewController.collectionView];
    self.transitionManager.delegate = self;

    return YES;
}


#pragma mark - APLTransitionControllerDelegate

- (void)interactionBeganAtPoint:(CGPoint)p
{
    UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
    
    // Very basic communication between the transition controller and the top view controller
    // It would be easy to add more control, support pop, push or no-op.
    //
    UIViewController *viewController =
        [(APLCollectionViewController *)navController.topViewController nextViewControllerAtPoint:p];
    if (viewController != nil)
    {
        [navController pushViewController:viewController animated:YES];
    }
    else
    {
        [navController popViewControllerAnimated:YES];
    }
}


#pragma mark - UINavigationControllerDelegate

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
    // return our own transition manager if the incoming controller matches ours
    if (animationController == self.transitionManager)
    {
        return self.transitionManager;
    }
    return nil;
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    id transitionManager = nil;
    
    // make sure we are transitioning from or to a collection view controller, and that interaction is allowed
    if ([fromVC isKindOfClass:[UICollectionViewController class]] &&
        [toVC isKindOfClass:[UICollectionViewController class]] &&
        self.transitionManager.hasActiveInteraction)
    {
        self.transitionManager.navigationOperation = operation;
        transitionManager = self.transitionManager;
    }
    return transitionManager;
}

@end
