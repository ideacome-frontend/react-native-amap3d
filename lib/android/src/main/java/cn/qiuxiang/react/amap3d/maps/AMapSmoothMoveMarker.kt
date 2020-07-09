package cn.qiuxiang.react.amap3d.maps

import android.content.Context
import android.os.Handler
import cn.qiuxiang.react.amap3d.toLatLngList
import cn.qiuxiang.react.amap3d.toWritableMap
import com.amap.api.maps.AMap
import com.amap.api.maps.CameraUpdateFactory
import com.amap.api.maps.model.*
import com.amap.api.maps.model.LatLngBounds
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
    private  var _map:AMap?=null;
    private var  subList:List<LatLng> =  ArrayList()
    private  var enableListen:Boolean = false
    private var smoothMarker: MovingPointOverlay? = null
    private var bitmapDescriptor: BitmapDescriptor? = null
    private  var totalDutation : Int = 40
    private var coordinates: ArrayList<LatLng> = ArrayList()
    private var bounds: ArrayList<LatLng> = ArrayList()
    private val handlerTime = Handler()
    private val counter = object : Runnable {
        var lastPoi: LatLng? = null
        override fun run() {
            handlerTime.postDelayed(this, 16)
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

    fun setBounds(coordinates: ReadableArray){
        val list =coordinates.toLatLngList()
        if(bounds.size>0){
            val tBounds = this.getLatLngBounds(list)
            val beras:Float = _map!!.cameraPosition.bearing
            _map!!.moveCamera(CameraUpdateFactory.newLatLngBounds(tBounds, 50))
            _map!!.moveCamera(CameraUpdateFactory.changeBearing(beras))
        }
        this.bounds = list;
    }

    fun setCoordinates(coordinates: ReadableArray) {
        val list =coordinates.toLatLngList()
//        list.removeAt(list.size-1)
        smoothMarker?.setPoints(list)
        this.coordinates = list
        this.subList = list
        if(this.autoStart){
            smoothMarker?.startSmoothMove()
        }
//        this.zoomToSpan();
        if(_map!=null && ! _map!!.projection.visibleRegion.latLngBounds.contains(list.get(list.size -1 ) )){
            // 如果地图无法显示终点的坐标 则缩放地图不改变中心点
            this.zoomToSpanWithCenter();
        }
//        this.zoomToSpanWithCenter()
    }

    fun setTotalDuration(duration: Int) {
        this.totalDutation = duration
    }

    fun setImage(name: String) {
        Handler().postDelayed({
            val drawable = context.resources.getIdentifier(name, "drawable", context.packageName)
            bitmapDescriptor = BitmapDescriptorFactory.fromResource(drawable)
//            smoothMarker?.setDescriptor(bitmapDescriptor)
            if(this.mk!==null){
                mk!!.setIcon((bitmapDescriptor))
            }
        }, 0)
        Handler().postDelayed({
            if(this.mk!==null){
                mk!!.setIcon((bitmapDescriptor));
            }
        }, 200)
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
        var tBounds:MutableList<LatLng>
        if(bounds.size>0){
            tBounds = bounds
        }else{
            tBounds = points
        }
        map.animateCamera(CameraUpdateFactory.newLatLngBounds(getLatLngBounds(tBounds), 50))
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
        val subList: List<LatLng> = points.subList(first, points.size);
        this.subList= subList
        // 设置滑动的轨迹左边点
        smoothMarker.setPoints(subList)
        // 设置滑动的总时间
        smoothMarker.setTotalDuration(this.totalDutation)
        // 开始滑动
        if(this.autoStart){
            smoothMarker.startSmoothMove()
        }
        this._map =map;
    }

    override fun remove() {
        smoothMarker?.destroy()
        handlerTime.removeCallbacks(counter)
    }


    fun zoomToSpanWithCenter() {
        if ( coordinates.isNotEmpty()) {
            if (_map== null) return
            val bounds = getLatLngBounds(_map!!.cameraPosition.target, coordinates)
            val beras:Float = _map!!.cameraPosition.bearing
            _map!!.moveCamera(CameraUpdateFactory.newLatLngBounds(bounds, 50))
            _map!!.moveCamera(CameraUpdateFactory.changeBearing(beras))
        }
    }

    //根据中心点和自定义内容获取缩放bounds
    private fun getLatLngBounds(centerpoint: LatLng?, pointList: List<LatLng>): LatLngBounds {
        val b = LatLngBounds.builder()
        if (centerpoint != null) {
            for (i in pointList.indices) {
                val p = pointList[i]
                val p1 = LatLng(centerpoint.latitude * 2 - p.latitude, centerpoint.longitude * 2 - p.longitude)
                b.include(p)
                b.include(p1)
            }
        }
        return b.build()
    }

    /**
     * 缩放移动地图，保证所有自定义marker在可视范围中。
     */
    fun zoomToSpan() {
        if (  coordinates.isNotEmpty()) {
            if (_map == null) return
            val bounds = getLatLngBounds(coordinates)
            _map!!.moveCamera(CameraUpdateFactory.newLatLngBounds(bounds, 50))
        }
    }

    /**
     * 根据自定义内容获取缩放bounds
     */
    private fun getLatLngBounds(pointList: List<LatLng>): LatLngBounds {
        val b = LatLngBounds.builder()
        for (i in pointList.indices) {
            val p = pointList[i]
            b.include(p)
        }
        return b.build()
    }

}


