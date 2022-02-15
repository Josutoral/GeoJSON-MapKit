//
//  MapView.swift
//  GeoJSON
//
//  Created by Marek Roslik on 14.02.22.
//

import SwiftUI
import MapKit

//create custom view
let mapView = MKMapView(frame: UIScreen.main.bounds)

struct MapView: UIViewRepresentable {
    
    @State private var myMapView: MKMapView?
  
    //set initial values
    func makeUIView(context: Context) -> MKMapView {
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 66.25,
                                                                    longitude: 94.15),
                                        span: MKCoordinateSpan(latitudeDelta: 100,
                                                               longitudeDelta: 100))
        mapView.region = region
        mapView.delegate = context.coordinator
        return mapView
    }
    //protocol confirm
    func updateUIView(_ uiView: MKMapView, context: Context) {
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        let sfCoord = CLLocationCoordinate2D(latitude: 56, longitude: 38)
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
            if let annotationView = views.first {
                if let annotation = annotationView.annotation {
                    if annotation is MKUserLocation {
                        let region = MKCoordinateRegion(center: annotation as! CLLocationCoordinate2D, latitudinalMeters: 2000, longitudinalMeters: 2000 )
                        mapView.setRegion(region, animated: true)
                    }
                }
            }
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if overlay is MKMultiPolygon {
                let multiPolygon = MKMultiPolygonRenderer(overlay: overlay)
                multiPolygon.strokeColor = .orange
                return multiPolygon
            } else if overlay is MKMultiPolyline {
                let multiPolyline = MKMultiPolylineRenderer(overlay: overlay)
                multiPolyline.strokeColor = .orange
                return multiPolyline
            }
            return MKOverlayRenderer()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
