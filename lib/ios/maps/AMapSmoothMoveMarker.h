#import "AMapView.h"
#import "AMapCallout.h"

@interface AMapSmoothMoveMarker : UIView

@property(nonatomic, copy) RCTBubblingEventBlock onPress;
@property(nonatomic, copy) RCTBubblingEventBlock onInfoWindowPress;
@property(nonatomic, copy) RCTBubblingEventBlock onDragStart;
@property(nonatomic, copy) RCTBubblingEventBlock onDrag;
@property(nonatomic, copy) RCTBubblingEventBlock onDragEnd;
@property(nonatomic, copy) RCTBubblingEventBlock onMarkerMove;

- (MAAnnotationView *)annotationView;
- (MAAnimatedAnnotation *)annotation;
- (void)setActive:(BOOL)active;
- (void)setStop;
- (void)start;
- (void)restart;
- (void)setMapView:(AMapView *)mapView;
- (void)lockToScreen:(int)x y:(int)y;
- (void)setMapBounds;

@end
