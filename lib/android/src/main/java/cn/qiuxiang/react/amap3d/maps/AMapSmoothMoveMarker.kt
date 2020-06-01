package cn.qiuxiang.react.amap3d.maps

import android.content.Context
import android.os.Handler
import cn.qiuxiang.react.amap3d.toLatLngList
import cn.qiuxiang.react.amap3d.toWritableMap
import com.amap.api.maps.AMap
import com.amap.api.maps.CameraUpdateFactory
import com.amap.api.maps.model.*
import com.amap.api.maps.utils.SpatialRelationUtil.calShortestDistancePoint
import com.amap.api.maps.utils.overlay.MovingPointOverlay
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.bridge.WritableMap
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.events.RCTEventEmitter
import com.facebook.react.views.view.ReactViewGroup


class AMapSmoothMoveMarker(context: Context) : ReactViewGroup(context), AMapOverlay {
    private val eventEmitter: RCTEventEmitter = (context as ThemedReactContext).getJSModule(RCTEventEmitter::class.java)
    private  var autoStart: Boolean = false
    private  var mk: Marker? =null
    private var  subList:List<LatLng> =  ArrayList()
    private  var enableListen:Boolean = false
    private var smoothMarker: MovingPointOverlay? = null
    private var bitmapDescriptor: BitmapDescriptor? = null

    private  var totalDutation : Int = 40
    private var coordinates: ArrayList<LatLng> = ArrayList()
    private val handlerTime = Handler()
    private val counter = object : Runnable {
        var lastPoi: LatLng? = null
        override fun run() {
            handlerTime.postDelayed(this, 17)
            if(mk!==null ){
                val curPosition =  mk!!.position
                if(curPosition != lastPoi){
                    val map =   curPosition.toWritableMap()
                    emit(id, "onMarkerMove", map)
                    lastPoi = curPosition
                }
            }
        }
    }


    fun setAutoStart(start: Boolean){
        this.autoStart =start
    }

    fun setEnableListen(lis: Boolean){
        this.enableListen = lis;
    }

    fun setCoordinates(coordinates: ReadableArray) {
        val list =coordinates.toLatLngList()
        smoothMarker?.setPoints(list)
        this.coordinates = list
        this.subList = list
        if(this.autoStart){
            smoothMarker?.startSmoothMove()
        }
    }

    fun setTotalDuration(duration: Int) {
        this.totalDutation = duration
    }

    fun setImage(name: String) {
        Handler().postDelayed({
            val drawable = context.resources.getIdentifier(name, "drawable", context.packageName)
            bitmapDescriptor = BitmapDescriptorFactory.fromResource(drawable)
//            smoothMarker?.setDescriptor(bitmapDescriptor)
        }, 0)
    }

    fun stopMove(){
        smoothMarker?.stopMove()
    }

    fun startSmoothMove(){
        smoothMarker?.startSmoothMove()
    }

    fun reStartMove( args: ReadableArray?){
       smoothMarker?.setPoints(subList)
        if(args!==null){
            smoothMarker?.startSmoothMove()
        }
    }

    private fun emit(id: Int?, event: String, data: WritableMap = Arguments.createMap()) {
        id?.let { eventEmitter.receiveEvent(it, event, data) }
    }

    override fun add(map: AMap) {
        val points: MutableList<LatLng> = this.coordinates
        val bounds = LatLngBounds(points[0], points[points.size - 2])
        map.animateCamera(CameraUpdateFactory.newLatLngBounds(bounds, 50))
        val marker = map.addMarker(MarkerOptions().icon(bitmapDescriptor))
        this.mk = marker
        if(enableListen){
           handlerTime.post(counter)
        }
        val smoothMarker = MovingPointOverlay(map,marker)
        this.smoothMarker = smoothMarker
        val drivePoint = points[0]
        val pair = calShortestDistancePoint(points, drivePoint)
        val first = pair.first
        points[first] = drivePoint
        val subList: List<LatLng> = points.subList(first, points.size)
        this.subList= subList
        // 设置滑动的轨迹左边点
        smoothMarker.setPoints(subList)
        // 设置滑动的总时间
        smoothMarker.setTotalDuration(this.totalDutation)
        // 开始滑动
        if(this.autoStart){
            smoothMarker.startSmoothMove()
        }
    }

    override fun remove() {
        smoothMarker?.destroy()
        handlerTime.removeCallbacks(counter)
    }


}


