//
//  ContentView.swift
//  GeoJSON
//
//  Created by Marek Roslik on 14.02.22.
//

import SwiftUI
import MapKit

struct ContentView: View {
    //API data
    var geoManager = GeoManager()
    @State var geoData: GeoData?
    //UI info text
    @State var distanceText: String = ""
    
    var body: some View {
        //Data check for view
        if geoData != nil {
            //Data loading
            ZStack(alignment: .bottom) {
                MapView()
                    .ignoresSafeArea(.all)
                
                VStack {
                    Text(distanceText)
                        .font(.subheadline).foregroundColor(.black)
                    Spacer()
                    Button("Show border".uppercased()) {
                        distanceText = "Border length \(Int(showBorder())) meters"
                    }
                    .font(.headline).foregroundColor(.black)
                    .padding(.bottom, 5)
                }
            }
        } else {
            //Data not loading
            ProgressView()
                .task {
                    do {
                        //API call
                        geoData = try await geoManager.getCurrentData()
                    } catch {
                        print ("Error \(error)")
                    }
                }
        }
    }
    //Func for border showing
    func showBorder() -> Double {
        //Temp var
        var borderCLL = [CLLocationCoordinate2D]()
        var polygonCLL = [MKPolygon]()
        var distance = 0.0
        //Convert coordinates. MKGeoJSONDecoder didnt use because API have 180+ coordinates
        for multiPolygon in geoData!.features[0].geometry.coordinates {
            for polygon in multiPolygon {
                for point in polygon {
                    if point[0] < 180 {
                        borderCLL.append(CLLocationCoordinate2D(latitude: point[1], longitude: point[0]))
                    } else {
                        borderCLL.append(CLLocationCoordinate2D(latitude: point[1], longitude: 360 - point[0]))
                    }
                    
                }
                polygonCLL.append(MKPolygon(coordinates: borderCLL, count: borderCLL.count))
                //count distance by coordinates
                for i in 0..<borderCLL.count - 1 {
                    distance += CLLocation(latitude: borderCLL[i].latitude, longitude: borderCLL[i].longitude).distance(from: CLLocation(latitude: borderCLL[i+1].latitude, longitude: borderCLL[i+1].longitude))
                }
                borderCLL = []
            }
        }
        //View call
        mapView.renderer(for: MKMultiPolygon(polygonCLL) as MKOverlay)
        mapView.addOverlay(MKMultiPolygon(polygonCLL) as MKOverlay)
        return distance
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
