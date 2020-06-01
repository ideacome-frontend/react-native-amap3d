import * as React from "react";
import * as PropTypes from "prop-types";
import { requireNativeComponent, ViewPropTypes } from "react-native";
import { LatLng } from "../types";
import { LatLngPropType } from "../prop-types";
import Component from "./component";

export interface SmoothMoveMarkerProps {
  /**
   * 坐标集合
   */
  coordinates: LatLng[];
  image?: string;
  start?: () => void;
  stop?: () => void;
  restart?: (autoStart: boolean) => void;
  autoStart?: boolean;
  enableListen?: boolean;
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
  restart(autoStart = false) {
    if (autoStart === true) {
      this.call("restart", [1]);
      return;
    }
    this.call("restart");
  }
  render() {
    const props = {
      ...this.props,
      ...this.handlers(events)
    };
    return <AMapSmoothMoveMarker {...props  } />
  }
}

// @ts-ignore
const AMapSmoothMoveMarker = requireNativeComponent("AMapSmoothMoveMarker", SmoothMoveMarker);
