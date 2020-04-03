export declare const LatLngPropType: import("prop-types").Requireable<import("prop-types").InferProps<{
    latitude: import("prop-types").Validator<number>;
    longitude: import("prop-types").Validator<number>;
}>>;
export declare const RegionPropType: import("prop-types").Requireable<import("prop-types").InferProps<{
    latitude: import("prop-types").Validator<number>;
    longitude: import("prop-types").Validator<number>;
    latitudeDelta: import("prop-types").Validator<number>;
    longitudeDelta: import("prop-types").Validator<number>;
}>>;
export declare const PointPropType: import("prop-types").Requireable<import("prop-types").InferProps<{
    x: import("prop-types").Validator<number>;
    y: import("prop-types").Validator<number>;
}>>;
export declare const LocationStylePropType: import("prop-types").Requireable<import("prop-types").InferProps<{
    image: import("prop-types").Requireable<string>;
    fillColor: import("prop-types").Requireable<string>;
    strokeColor: import("prop-types").Requireable<string>;
    strokeWidth: import("prop-types").Requireable<number>;
}>>;
export declare const mapEventsPropType: (events: any) => any;
