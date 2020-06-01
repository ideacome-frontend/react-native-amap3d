/// <reference types="react" />
import { MapStatus, MapType, Region, LatLng, Location } from "../types";
import Component from "./component";
import Marker from "./marker";
import Polyline from "./polyline";
import MultiPoint from "./multi-point";
import SmoothMoveMarker from "./smooth-marker";
export interface MapViewProps {
    /**
     * 地图类型
     */
    mapType?: MapType;
    /**
     * 地图中心
     */
    center?: LatLng;
    /**
     * 地图显示区域
     */
    region?: Region;
    /**
     * 缩放级别
     */
    zoomLevel?: number;
    /**
     * 倾斜角度，取值范围 [0, 60]
     */
    rotation?: number;
    /**
     * 倾斜角度
     */
    tilt?: number;
    /**
     * 是否启用定位
     */
    locationEnabled?: boolean;
    /**
     * 定位间隔(ms)，默认 2000
     *
     * @platform android
     */
    locationInterval?: number;
    /**
     * 定位的最小更新距离
     *
     * @platform ios
     */
    distanceFilter?: number;
    /**
     * 是否显示室内地图
     */
    showsIndoorMap?: boolean;
    /**
     * 是否显示室内地图楼层切换控件
     *
     * TODO: 似乎并不能正常显示
     */
    showsIndoorSwitch?: boolean;
    /**
     * 是否显示3D建筑
     */
    showsBuildings?: boolean;
    /**
     * 是否显示文本标签
     */
    showsLabels?: boolean;
    /**
     * 是否显示指南针
     */
    showsCompass?: boolean;
    /**
     * 是否显示放大缩小按钮
     *
     * @platform android
     */
    showsZoomControls?: boolean;
    /**
     * 是否显示比例尺
     */
    showsScale?: boolean;
    /**
     * 是否显示定位按钮
     *
     * @platform android
     */
    showsLocationButton?: boolean;
    /**
     * 是否显示路况
     */
    showsTraffic?: boolean;
    /**
     * 最大缩放级别
     */
    maxZoomLevel?: number;
    /**
     * 最小缩放级别
     */
    minZoomLevel?: number;
    /**
     * 限制地图只能显示某个矩形区域
     */
    limitRegion?: Region;
    /**
     * 是否启用缩放手势，用于放大缩小
     */
    zoomEnabled?: boolean;
    /**
     * 是否启用滑动手势，用于平移
     */
    scrollEnabled?: boolean;
    /**
     * 是否启用旋转手势，用于调整方向
     */
    rotateEnabled?: boolean;
    /**
     * 是否启用倾斜手势，用于改变视角
     */
    tiltEnabled?: boolean;
    /**
     * 点击事件
     */
    onClick?: (coordnate: LatLng) => void;
    /**
     * 长按事件
     */
    onLongClick?: (coordnate: LatLng) => void;
    /**
     * 地图状态改变事件，在动画结束后触发
     */
    onStatusChangeComplete?: (status: MapStatus) => void;
    /**
     * 定位事件
     */
    onLocation?: (location: Location) => void;
    /**
     * 动画取消事件
     */
    onAnimateCancel?: () => void;
    /**
     * 动画完成事件
     */
    onAnimateFinished?: () => void;
}
/**
 * @ignore
 */
export default class MapView extends Component<MapViewProps> {
    static propTypes: any;
    nativeComponent: string;
    /**
     * 设置地图状态（坐标、缩放级别、倾斜度、旋转角度），支持动画过度
     *
     * @param status
     * @param duration
     */
    setStatus(status: MapStatus, duration?: number): void;
    render(): JSX.Element;
    static Marker: typeof Marker;
    static Polyline: typeof Polyline;
    static Polygon: any;
    static Circle: any;
    static HeatMap: any;
    static MultiPoint: typeof MultiPoint;
    static SmoothMoveMarker: typeof SmoothMoveMarker;
}
