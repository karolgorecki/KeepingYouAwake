//
//  KYAStatusItemController.h
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 10.09.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol KYAStatusItemControllerDelegate;

@interface KYAStatusItemController : NSObject
@property (nonatomic, readonly) NSStatusItem *systemStatusItem;
@property (weak, nonatomic, nullable) id<KYAStatusItemControllerDelegate> delegate;
@property (nonatomic, getter=isActiveAppearanceEnabled) BOOL activeAppearanceEnabled;

- (instancetype)init NS_DESIGNATED_INITIALIZER;

- (void)showMenu:(NSMenu *)menu;

@end

@protocol KYAStatusItemControllerDelegate <NSObject>
@optional
- (void)statusItemControllerShouldPerformMainAction:(KYAStatusItemController *)controller;
- (void)statusItemControllerShouldPerformAlternativeAction:(KYAStatusItemController *)controller;
@end

NS_ASSUME_NONNULL_END
