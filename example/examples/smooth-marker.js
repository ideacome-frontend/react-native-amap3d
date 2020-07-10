import React, { Component } from "react";
import { StyleSheet, Alert, TouchableOpacity, View, Text, Platform } from "react-native";
import { MapView } from "react-native-amap3d";

export default class SmoothMarkerExample extends Component {
  constructor(props) {
    super(props);
    this.state = {
      smoothLine: this._line4.slice(0, 3),
    };
  }

  static navigationOptions = {
    title: "平滑移动",
  };

  _line3 = [
    {
      latitude: 39.806901,
      longitude: 116.097972,
    },
    {
      latitude: 39.806901,
      longitude: 116.257972,
    },
    {
      latitude: 39.806901,
      longitude: 116.457972,
    },
    {
      latitude: 39.806901,
      longitude: 116.597972,
    },
  ]

  _line4 = [
    [113.401049, 23.159054],
    [113.401393, 23.16225],
    [113.400062, 23.165801],
    [113.399161, 23.167221],
    [113.399161, 23.167261],
    [113.399234, 23.167281],
    [113.399234, 23.167321],
  ].map((v) => {
    return {
      longitude: v[0],
      latitude: v[1],
    };
  });
  _onPress = () => Alert.alert("onPress");
  render() {
    return (
      <View style={{ flex: 1 }}>
        <MapView style={StyleSheet.absoluteFill}>
          <MapView.Polyline width={5} onPress={this._onPress} coordinates={this._line4} />
          <MapView.SmoothMoveMarker
            autoStart={true}
            ref={(r) => (this.smoothMarker = r)}
            coordinates={this.state.smoothLine}
            image="flag"
            duration={3}
            enableListen={true} 
            onMarkerMove={(position) => {
                // only  enableListen={true} 
                //  android 每60ms 调用一次 ios每帧调用一次，自行降低
              console.log(position);
            }}
            bounds={this._line4}
            offsetBottom={ Platform.OS==='android' ? 400 : 0.3333}
          />
        </MapView>
        <View style={styles.buttons}>
          <TouchableOpacity onPress={() => this.smoothMarker.stop()}>
            <Text>停止</Text>
          </TouchableOpacity>
          <TouchableOpacity onPress={() => this.smoothMarker.start()}>
            <Text>开始</Text>
          </TouchableOpacity>
          <TouchableOpacity onPress={() => this.smoothMarker.restart(true)}>
            <Text>重启</Text>
          </TouchableOpacity>
          <TouchableOpacity
            onPress={() => {
                this.setState({
                  smoothLine: this._line4.slice(2, 7),
                });
            }}
          >
            <Text>改变</Text>
          </TouchableOpacity>
        </View>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  buttons: {
    position: "absolute",
    top: 40,
    left: 0,
    zIndex: 999,
    flexDirection: "row",
    width: "100%",
    justifyContent: "space-around",
  },
});
