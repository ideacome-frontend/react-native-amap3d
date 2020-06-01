package cn.qiuxiang.react.amap3d.maps

import com.facebook.react.bridge.ReadableArray
import com.facebook.react.common.MapBuilder
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewGroupManager
import com.facebook.react.uimanager.annotations.ReactProp

@Suppress("unused")
internal class AMapSmoothMoveMarkerManager : ViewGroupManager<AMapSmoothMoveMarker>() {
    override fun createViewInstance(reactContext: ThemedReactContext): AMapSmoothMoveMarker {
        return AMapSmoothMoveMarker(reactContext)
    }

    override fun getName(): String {
        return "AMapSmoothMoveMarker"
    }

    override fun getExportedCustomDirectEventTypeConstants(): Map<String, Any> {
        return MapBuilder.of(
                "onMarkerMove", MapBuilder.of("registrationName", "onAMapMarkerMove")
        )
    }

    @ReactProp(name = "coordinates")
    fun setCoordinate(smoothMoveMarker: AMapSmoothMoveMarker, coordinates: ReadableArray) {
        smoothMoveMarker.setCoordinates(coordinates)
    }

    @ReactProp(name = "image")
    fun setImage(smoothMoveMarker: AMapSmoothMoveMarker, image: String) {
        smoothMoveMarker.setImage(image)
    }

    @ReactProp(name = "autoStart")
    fun setAutoStart(smoothMoveMarker: AMapSmoothMoveMarker, start: Boolean) {
        smoothMoveMarker.setAutoStart(start)
    }

    @ReactProp(name = "enableListen")
    fun setEnableListen(smoothMoveMarker: AMapSmoothMoveMarker, lis: Boolean) {
        smoothMoveMarker.setEnableListen(lis)
    }

    @ReactProp(name = "duration")
    fun setDuration(smoothMoveMarker: AMapSmoothMoveMarker, duration: Int) {
        smoothMoveMarker.setTotalDuration(duration)
    }

    companion object {
        const val START = 1
        const val STOP = 2
        const val RESTART = 3
    }

    override fun getCommandsMap(): Map<String, Int> {
        return mapOf(
                "start" to START,
                "stop" to STOP,
                "restart" to RESTART
        )
    }

    override fun receiveCommand(smoothMoveMarker: AMapSmoothMoveMarker, commandId: Int, args: ReadableArray?) {
        when (commandId) {
            START -> smoothMoveMarker.startSmoothMove()
            STOP -> smoothMoveMarker.stopMove()
            RESTART -> smoothMoveMarker.reStartMove(args)
        }
    }
}
