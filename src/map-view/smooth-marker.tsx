import * as React from "react";
import * as PropTypes from "prop-types";
import { requireNativeComponent, ViewPropTypes, Platform } from "react-native";
import { LatLng } from "../types";
import { LatLngPropType } from "../prop-types";
import Component from "./component";

export interface SmoothMoveMarkerProps {
  /**
   * 坐标集合
   */
  coordinates: LatLng[];
  bounds?:LatLng[];
  image?: string;
  start?: () => void;
  stop?: () => void;
  restart?: (autoStart: boolean) => void;
  autoStart?: boolean;
  enableListen?: boolean;
  offsetBottom?:number;
}

const events = ["onMarkerMove"];

/**
 * @ignore
 */
export default class SmoothMoveMarker extends Component<SmoothMoveMarkerProps>{

  static propTypes = {
    ...ViewPropTypes,
    coordinates: PropTypes.arrayOf(LatLngPropType).isRequired,
    image: PropTypes.string,
    duration: PropTypes.number,
  }
  nativeComponent = "AMapSmoothMoveMarker";
  start() {
    this.call("start");
  }
  stop() {
    console.log("调用停止方法");
    this.call("stop");
  }
  setMapBounds(){
    this.call("setMapBounds");
  }
  restart(autoStart = false) {
    if(Platform.OS==='ios'){
      // ios 默认restart
      this.call("restart");
      return;
    }
    if (autoStart === true) {
      this.call("restart", [1]);
      return;
    }
    this.call("restart");
  }
  render() {
    const props = {
      ...this.props,
      mapBounds:this.props.bounds || [],
      ...this.handlers(events)
    };
    return <AMapSmoothMoveMarker {...props  } />
  }
}

// @ts-ignore
const AMapSmoothMoveMarker = requireNativeComponent("AMapSmoothMoveMarker", SmoothMoveMarker);
