#import <React/UIView+React.h>
#import "AMapSmoothMoveMarker.h"
#import "Coordinate.h"
#import "CustomMovingAnnotation.h"

#pragma ide diagnostic ignored "OCUnusedMethodInspection"
#pragma clang diagnostic ignored "-Woverriding-method-mismatch"

@implementation AMapSmoothMoveMarker {
    PausableMovingAnnotation *_annotation;//贴图标注
    MAAnnotationView *_annotationView;//标注视图
    MAAnnotationMoveAnimation *currentStopLoc;//
    MACustomCalloutView *_calloutView;//气泡视图
    NSMutableArray<Coordinate *> *_coordinates;//
    NSMutableArray<Coordinate *> *_mapBounds;//边界
    UIView *_customView;
    __weak AMapView *_mapView;
    MAPinAnnotationColor _pinColor;
    UIImage *_image;
    CGPoint _centerOffset;
    BOOL _draggable;
    BOOL _active;
    BOOL _canShowCallout; //是否显示气泡
    BOOL _enabled;
    BOOL _enableListen;
    BOOL _autoStart;
    NSInteger _zIndex;
    NSInteger _duration; //动画时间
    NSUInteger temp;
    CLLocationCoordinate2D _stopCor;
}
// MAAnimatedAnnotation
- (instancetype)init {
    _annotation = [PausableMovingAnnotation new];
    _coordinates = [[NSMutableArray alloc] init];
    _mapBounds = [[NSMutableArray alloc] init];
    _enabled = YES;
    _canShowCallout = YES;
    _draggable = NO;
    temp = 0;
    self = [super init];
    return self;
}

- (void)setDuration:(NSInteger)duration {
    _duration = duration;
}

- (void)setImage:(NSString *)name {
    _image = [UIImage imageNamed:name];
    if (_image != nil) {
        _annotationView.image = _image;
    }
}

- (void)setCoordinates:(NSArray<Coordinate *> *)coordinates {
    [_coordinates removeAllObjects];
    [_coordinates addObjectsFromArray:coordinates];
    CLLocationCoordinate2D coords[coordinates.count];
    [self setStop];
    for (NSUInteger i = 0; i < coordinates.count; i++) {
        coords[i] = coordinates[i].coordinate;
    }
    _annotation.coordinate = coords[0];
    if(_annotationView != nil) {
        if(_autoStart){
            [_annotation addMoveAnimationWithKeyCoordinates:coords count:coordinates.count withDuration:_duration withName:nil completeCallback:^(BOOL isFinished) {
              }stepCallback:^(MAAnnotationMoveAnimation *currentAni) {
                   currentStopLoc = currentAni;
                  if(_enableListen){
                       _onMarkerMove(
                          @{
                               @"latitude": @(_annotation.coordinate.latitude),
                               @"longitude":@(_annotation.coordinate.longitude),
                           }
                       );
                   }
              }
            ];
        }
        // 保持地图旋转角度不变
        CGFloat ration = [_mapView getMapStatus].rotationDegree;
        MAMapRect rect = [_mapView visibleMapRect];
        MAMapPoint point = MAMapPointForCoordinate(_coordinates[_coordinates.count-1].coordinate);
        BOOL isLastPointInMap = MAMapRectContainsPoint(rect,point);
        if(!isLastPointInMap){
            // 如果最后一个点不在地图中 则进行缩放展示地图
            [self showsAllPoints];
            [_mapView setRotationDegree:ration animated:false duration:0];
        }
    }
}

- (void)setMapBounds:(NSArray<Coordinate *> *)bounds {
    BOOL noFirstInit = _mapBounds.count>0;
    [_mapBounds removeAllObjects];
    [_mapBounds addObjectsFromArray:bounds];
    if(noFirstInit){
        MACoordinateRegion region =  [self getBounds];
        [_mapView setRegion: region];
    }
}

- (void)setActive:(BOOL)active {
    _active = active;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (active) {
            [self->_mapView selectAnnotation:self->_annotation animated:YES];
        } else {
            [self->_mapView deselectAnnotation:self->_annotation animated:YES];
        }
    });
}

- (void)setEnableListen:(BOOL)enableListen {
    _enableListen = enableListen;
}

- (void)setAutoStart:(BOOL)autostart {
    _autoStart = autostart;
}

- (void)setStop {
    _stopCor = _annotation.coordinate;
    for(MAAnnotationMoveAnimation *animation in [_annotation allMoveAnimations]) {
        [animation cancel];
    }
    [_annotation setCoordinate:_stopCor];
//    if(currentStopLoc.passedPointCount !=nil && currentStopLoc.passedPointCount>0){
//        [_annotation setCoordinate:_coordinates[currentStopLoc.passedPointCount-1].coordinate];
//
}

- (void)start {
   
    if(currentStopLoc.passedPointCount >= 0 && currentStopLoc.passedPointCount<=_coordinates.count){
        if(temp==0){
            temp = temp + currentStopLoc.passedPointCount;
        }else{
            temp = temp + currentStopLoc.passedPointCount - 1;
        }
    }
   CLLocationCoordinate2D coords[_coordinates.count - temp + 1];
   for (NSUInteger i = 0; i < _coordinates.count - temp + 1; i++) {
       if(i==0){
           if(temp == 0){
               coords[i] = _annotation.coordinate;
           }else{
                coords[i] = _stopCor;
           }
       }else{
           coords[i] = _coordinates[i + temp -1].coordinate;
       }
   }
    NSLog(@"%i",_coordinates.count - temp + 1);
   _annotation.coordinate = coords[0];
    NSInteger tempDurantion = (_duration* (_coordinates.count - temp)/_coordinates.count );
    if(tempDurantion==0){
        tempDurantion =1;
    }
   if(_annotationView != nil) {
       [_annotation addMoveAnimationWithKeyCoordinates:coords count:_coordinates.count - temp + 1 withDuration: tempDurantion withName:nil completeCallback:^(BOOL isFinished) {

          }
        stepCallback:^(MAAnnotationMoveAnimation *currentAni) {
           currentStopLoc = currentAni;
            if(_enableListen){
                 _onMarkerMove(
                    @{
                         @"latitude": @(_annotation.coordinate.latitude),
                         @"longitude":@(_annotation.coordinate.longitude),
                     }
                 );
             }
        }
        ];
   }
}

- (void)restart {
    CLLocationCoordinate2D coords[_coordinates.count];
    for (NSUInteger i = 0; i < _coordinates.count; i++) {
        coords[i] = _coordinates[i].coordinate;
    }
    temp = 0;
    _annotation.coordinate = coords[0];
   if(_annotationView != nil && _autoStart) {
       [_annotation addMoveAnimationWithKeyCoordinates:coords count:_coordinates.count withDuration:_duration withName:nil completeCallback:^(BOOL isFinished) {

          }
        stepCallback:^(MAAnnotationMoveAnimation *currentAni) {
           currentStopLoc = currentAni;
            if(_enableListen){
                 _onMarkerMove(
                    @{
                         @"latitude": @(_annotation.coordinate.latitude),
                         @"longitude":@(_annotation.coordinate.longitude),
                     }
                 );
             }
        }
        ];
   }
}

- (PausableMovingAnnotation *)annotation {
    return _annotation;
}

- (void)setMapView:(AMapView *)mapView {
    _mapView = mapView;
    MACoordinateRegion region = [self getBounds];
    [_mapView setRegion:region];
}

- (void)_handleTap:(UITapGestureRecognizer *)recognizer {
    [_mapView selectAnnotation:_annotation animated:YES];
}

- (MACoordinateRegion) getBounds{
    NSMutableArray<Coordinate *> *_coor = [[NSMutableArray alloc] init];
        if(_mapBounds.count >0){
            _coor = _mapBounds;
        }else{
            _coor = _coordinates;
        }
        CLLocationDegrees maxLng = _coor[0].coordinate.longitude;
        CLLocationDegrees maxLat = _coor[0].coordinate.latitude;
        CLLocationDegrees minLat = _coor[0].coordinate.latitude;
        CLLocationDegrees minLng = _coor[0].coordinate.longitude;
        for (NSUInteger i = 0; i < _coor.count; i++) {
            if(_coor[i].coordinate.longitude > maxLng){
                maxLng = _coor[i].coordinate.longitude;
            }
            if(_coor[i].coordinate.latitude > maxLat){
                maxLat = _coor[i].coordinate.latitude;
            }
            if(_coor[i].coordinate.longitude < minLng){
                minLng = _coor[i].coordinate.longitude;
            }
            if(_coor[i].coordinate.latitude < minLat){
                minLat = _coor[i].coordinate.latitude;
            }
        }
        CLLocationDegrees ofX =  ABS(maxLat - minLat) * 1.2;
        CLLocationDegrees ofY = ABS(maxLng - minLng) * 1.2;
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake((maxLat + minLat)/2, (maxLng + minLng)/2);
        MACoordinateSpan offset = MACoordinateSpanMake(ofX,ofY);
        return MACoordinateRegionMake(center, offset);
}

- (MAAnnotationView *)annotationView {
    if (_annotationView == nil) {
        if (_customView) {
            _customView.hidden = NO;
            _annotationView = [[MAAnnotationView alloc] initWithAnnotation:_annotation reuseIdentifier:nil];
            _annotationView.bounds = _customView.bounds;
            [_annotationView addSubview:_customView];
            [_annotationView addGestureRecognizer:[
                    [UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleTap:)]];
        } else {
            _annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:_annotation reuseIdentifier:nil];
            ((MAPinAnnotationView *) _annotationView).pinColor = _pinColor;
        }

        _annotationView.enabled = _enabled;
        _annotationView.canShowCallout = _canShowCallout;
        _annotationView.draggable = _draggable;
        _annotationView.customCalloutView = _calloutView;
        _annotationView.centerOffset = _centerOffset;

        if (_zIndex) {
            _annotationView.zIndex = _zIndex;
        }

        if (_image != nil) {
            _annotationView.image = _image;
        }
        CLLocationCoordinate2D coords[_coordinates.count];
        for (NSUInteger i = 0; i < _coordinates.count; i++) {
            coords[i] = _coordinates[i].coordinate;
        }
        if(_autoStart){
            [_annotation addMoveAnimationWithKeyCoordinates:coords count:_coordinates.count withDuration:_duration withName:nil completeCallback:^(BOOL isFinished) {

              } stepCallback:^(MAAnnotationMoveAnimation *currentAni) {
                   currentStopLoc = currentAni;
                  if(_enableListen){
                      _onMarkerMove(
                                     @{
                                          @"latitude": @(_annotation.coordinate.latitude),
                                          @"longitude":@(_annotation.coordinate.longitude),
                                      }
                      );
                  }
            }
             
             ];

        }
        [self setActive:_active];
    }
    return _annotationView;
}

- (void)showsAllPoints {
    MAMapRect rect = MAMapRectZero;
    UIEdgeInsets insets = UIEdgeInsetsMake(50,50, 50, 50);
    for (Coordinate *myCoor in _coordinates) {

        ///annotation相对于中心点的对角线坐标
        CLLocationCoordinate2D diagonalPoint = CLLocationCoordinate2DMake(_mapView.centerCoordinate.latitude - (myCoor.coordinate.latitude - _mapView.centerCoordinate.latitude),_mapView.centerCoordinate.longitude - (myCoor.coordinate.longitude - _mapView.centerCoordinate.longitude));

        MAMapPoint annotationMapPoint = MAMapPointForCoordinate(myCoor.coordinate);
        MAMapPoint diagonalPointMapPoint = MAMapPointForCoordinate(diagonalPoint);

        ///根据annotation点和对角线点计算出对应的rect（相对于中心点）
        MAMapRect annotationRect = MAMapRectMake(MIN(annotationMapPoint.x, diagonalPointMapPoint.x), MIN(annotationMapPoint.y, diagonalPointMapPoint.y), ABS(annotationMapPoint.x - diagonalPointMapPoint.x), ABS(annotationMapPoint.y - diagonalPointMapPoint.y));

        rect = MAMapRectUnion(rect, annotationRect);
    }

    [_mapView setVisibleMapRect:rect edgePadding:insets animated:YES];
}

- (void)didAddSubview:(UIView *)subview {
   if ([subview isKindOfClass:[AMapCallout class]]) {
       _calloutView = [[MACustomCalloutView alloc] initWithCustomView:subview];
       _annotationView.customCalloutView = _calloutView;
   } else {
       _customView = subview;
       _customView.hidden = YES;
   }
}

- (void)lockToScreen:(int)x y:(int)y {
    _annotation.lockedToScreen = YES;
    _annotation.lockedScreenPoint = CGPointMake(x, y);
}

@end


