// 
// Wire
// Copyright (C) 2016 Wire Swiss GmbH
// 
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program. If not, see http://www.gnu.org/licenses/.
// 


#import "PushTransition.h"
#import "UIView+MTAnimation.h"

@implementation PushTransition

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.55f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    CGRect initialFrameFromViewController = [transitionContext initialFrameForViewController:fromViewController];
    CGRect finalFrameToViewController = [transitionContext finalFrameForViewController:toViewController];
    
    CGAffineTransform offscreenRight = CGAffineTransformMakeTranslation(initialFrameFromViewController.size.width, 0);
    CGAffineTransform offscreenLeft = CGAffineTransformMakeTranslation(-initialFrameFromViewController.size.width, 0);

    CGAffineTransform toViewStartTransform = self.rightToLeft ? offscreenLeft : offscreenRight;
    CGAffineTransform fromViewEndTransform = self.rightToLeft ? offscreenRight : offscreenLeft;
    
    fromView.frame = initialFrameFromViewController;
    toView.frame = finalFrameToViewController;
    toView.transform = toViewStartTransform;
    
    [containerView addSubview:toView];
    [containerView addSubview:fromView];
    
    dispatch_block_t animation = ^{
        fromView.transform = fromViewEndTransform;
        toView.transform = CGAffineTransformIdentity;
    };
    
    void (^completion)(BOOL) = ^(BOOL finished) {
        fromView.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:YES];
    };
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [UIView mt_animateWithViews:@[toView, fromView]
                       duration:duration
                 timingFunction:MTTimingFunctionEaseOutExpo
                     animations:animation
                     completion:^(){
                         completion(YES);
                     }];
}

- (BOOL)rightToLeft
{
    return UIApplication.sharedApplication.userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft;
}

@end
