"use strict";
var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
var __assign = (this && this.__assign) || function () {
    __assign = Object.assign || function(t) {
        for (var s, i = 1, n = arguments.length; i < n; i++) {
            s = arguments[i];
            for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p))
                t[p] = s[p];
        }
        return t;
    };
    return __assign.apply(this, arguments);
};
exports.__esModule = true;
var React = require("react");
var PropTypes = require("prop-types");
var react_native_1 = require("react-native");
var prop_types_1 = require("../prop-types");
var component_1 = require("./component");
var events = ["onMarkerMove"];
/**
 * @ignore
 */
var SmoothMoveMarker = /** @class */ (function (_super) {
    __extends(SmoothMoveMarker, _super);
    function SmoothMoveMarker() {
        var _this = _super !== null && _super.apply(this, arguments) || this;
        _this.nativeComponent = "AMapSmoothMoveMarker";
        return _this;
    }
    SmoothMoveMarker.prototype.start = function () {
        this.call("start");
    };
    SmoothMoveMarker.prototype.stop = function () {
        console.log("调用停止方法");
        this.call("stop");
    };
    SmoothMoveMarker.prototype.restart = function (autoStart) {
        if (autoStart === void 0) { autoStart = false; }
        if (autoStart === true) {
            this.call("restart", [1]);
            return;
        }
        this.call("restart");
    };
    SmoothMoveMarker.prototype.render = function () {
        var props = __assign(__assign({}, this.props), this.handlers(events));
        return <AMapSmoothMoveMarker {...props}/>;
    };
    SmoothMoveMarker.propTypes = __assign(__assign({}, react_native_1.ViewPropTypes), { coordinates: PropTypes.arrayOf(prop_types_1.LatLngPropType).isRequired, image: PropTypes.string, duration: PropTypes.number });
    return SmoothMoveMarker;
}(component_1["default"]));
exports["default"] = SmoothMoveMarker;
// @ts-ignore
var AMapSmoothMoveMarker = react_native_1.requireNativeComponent("AMapSmoothMoveMarker", SmoothMoveMarker);
