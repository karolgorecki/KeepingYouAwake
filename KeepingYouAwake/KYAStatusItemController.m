//
//  KYAStatusItemController.m
//  KeepingYouAwake
//
//  Created by Marcel Dierkes on 10.09.17.
//  Copyright © 2017 Marcel Dierkes. All rights reserved.
//

#import "KYAStatusItemController.h"
#import "NSUserDefaults+Keys.h"
#import "KYAMenuBarIcon.h"

@interface KYAStatusItemController ()
@property (nonatomic, readwrite) NSStatusItem *systemStatusItem;
@end

@implementation KYAStatusItemController

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        [self configureStatusItem];
    }
    return self;
}

#pragma mark - Configuration

- (void)configureStatusItem
{
    NSStatusItem *statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    statusItem.highlightMode = ![NSUserDefaults standardUserDefaults].kya_menuBarIconHighlightDisabled;
    
    NSStatusBarButton *button = statusItem.button;
    
    [button sendActionOn:NSLeftMouseUpMask|NSRightMouseUpMask];
    button.target = self;
    button.action = @selector(toggleStatus:);
    
    self.systemStatusItem = statusItem;
    self.activeAppearanceEnabled = NO;
}

- (void)toggleStatus:(id)sender
{
    id<KYAStatusItemControllerDelegate> delegate = self.delegate;
    NSEvent *event = [[NSApplication sharedApplication] currentEvent];
    
    if((event.modifierFlags & NSEventModifierFlagControl)   // ctrl click
       || (event.modifierFlags & NSEventModifierFlagOption) // alt click
       || (event.type == NSEventTypeRightMouseUp))          // right click
    {
        if([delegate respondsToSelector:@selector(statusItemControllerShouldPerformAlternativeAction:)])
        {
            [delegate statusItemControllerShouldPerformAlternativeAction:self];
        }
        return;
    }
    
    if([delegate respondsToSelector:@selector(statusItemControllerShouldPerformMainAction:)])
    {
        [delegate statusItemControllerShouldPerformMainAction:self];
    }
}

#pragma mark - Active Appearance

- (BOOL)isActiveAppearanceEnabled
{
    KYAMenuBarIcon *menubarIcon = [KYAMenuBarIcon currentIcon];
    return self.systemStatusItem.image == menubarIcon.activeIcon;
}

- (void)setActiveAppearanceEnabled:(BOOL)activeAppearanceEnabled
{
    NSStatusBarButton *button = self.systemStatusItem.button;
    KYAMenuBarIcon *menubarIcon = [KYAMenuBarIcon currentIcon];
    
    if(activeAppearanceEnabled)
    {
        button.image = menubarIcon.activeIcon;
        button.toolTip = NSLocalizedString(@"Click to allow sleep\nRight click to show menu",
                                           @"Click to allow sleep\nRight click to show menu");
    }
    else
    {
        button.image = menubarIcon.inactiveIcon;
        button.toolTip = NSLocalizedString(@"Click to prevent sleep\nRight click to show menu",
                                           @"Click to prevent sleep\nRight click to show menu");
    }
}

#pragma mark - Menu

- (void)showMenu:(NSMenu *)menu
{
    [self.systemStatusItem popUpStatusItemMenu:menu];
}

@end
