#import <React/RCTUIManager.h>
#import "AMapSmoothMoveMarker.h"

#pragma ide diagnostic ignored "OCUnusedClassInspection"

@interface AMapSmoothMoveMarkerManager : RCTViewManager
@end

@implementation AMapSmoothMoveMarkerManager {
}

RCT_EXPORT_MODULE()

- (UIView *)view {
    return [AMapSmoothMoveMarker new];
}

RCT_EXPORT_VIEW_PROPERTY(coordinates, CoordinateArray)
RCT_EXPORT_VIEW_PROPERTY(mapBounds, CoordinateArray)
RCT_EXPORT_VIEW_PROPERTY(duration, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(image, NSString)
RCT_EXPORT_VIEW_PROPERTY(enableListen, BOOL)
RCT_EXPORT_VIEW_PROPERTY(autoStart, BOOL)
RCT_EXPORT_VIEW_PROPERTY(onMarkerMove, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(offsetBottom,CGFloat)


RCT_EXPORT_METHOD(lockToScreen:(nonnull NSNumber *)reactTag x:(int)x y:(int)y) {
    [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
        AMapSmoothMoveMarker *marker = (AMapSmoothMoveMarker *) viewRegistry[reactTag];
        [marker lockToScreen:x y:y];
    }];
}

RCT_EXPORT_METHOD(stop:(nonnull NSNumber *)reactTag) {
    [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
        AMapSmoothMoveMarker *marker = (AMapSmoothMoveMarker *) viewRegistry[reactTag];
        [marker setStop];
    }];
}
RCT_EXPORT_METHOD(start:(nonnull NSNumber *)reactTag) {
    [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
        AMapSmoothMoveMarker *marker = (AMapSmoothMoveMarker *) viewRegistry[reactTag];
        [marker start];
    }];
}
RCT_EXPORT_METHOD(restart:(nonnull NSNumber *)reactTag) {
    [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
        AMapSmoothMoveMarker *marker = (AMapSmoothMoveMarker *) viewRegistry[reactTag];
        [marker restart];
    }];
}


@end
